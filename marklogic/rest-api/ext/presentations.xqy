xquery version "1.0-ml";

module namespace presentations = "http://marklogic.com/rest-api/resource/presentations";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";
    
import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://www.corbas.co.uk/ns/presentations";
  

(:
  Generate a list of the presentations in the database. Return XML or JSON depending on 
  requested format (either in the 'format' parameter or the header. If the headers allow for 
  both XML & JSON and no format is defined, return XML. A basic outline of the decks in the
  presentations is returned. 
  
  If a single presentation is requested (using the presentation parameter) then detail level
  is increased and the title and id of all slides is returned. 
  
:)
declare 
%roxy:params("presentation=xs:string?,format=xs:string?")
function presentations:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{

  let $content-type as xs:string? := su:get-format($context, $params)
  let $presentation-id as xs:string? := map:get($params, 'presentation')
  
   let $presentations as object-node()* :=   
      if ($presentation-id) 
      then presentations:load-single-presentation($presentation-id)
      else presentations:load-all-presentations()

    return if ($content-type) 
    then
      if ($presentation-id) 
        then presentations:single-presentation-as($context, $content-type, $presentations)
        else presentations:all-presentations-as($context, $content-type, $presentations)     
    else 
      su:bad-content-type($context)

};

(:
  Update a presentation.
  
  Updates presentation data, presentation decks or slide visibility depending on
  parameters.
  
  There isn't any particularly obvious thing to return from this call. In order
  to be reasonable about this we treat it as a call to get the presentation 
  and return the changed result (note - had to create the 'changed' doc in order
  to return it as we are in a transaction and don't see the change).
  
  NOTE: how do we sanitise inputs properly in ML REST extensions? 
:)
declare 
%roxy:params("presentation=xs:string,deck=xs:string,slide=xs:string,format=xs:string?")
%rapi:transaction-mode("update")
function presentations:post(
  $context as map:map,
  $params as map:map,
  $input as document-node()*
) as document-node()*
{
  let $content-type as xs:string? := su:get-format($context, $params)
  let $presentation-id  as xs:string? := map:get($params, 'presentation')
  let $deck-id as xs:string? := map:get($params, 'deck')
  let $slide-id as xs:string? := map:get($params, 'slide')
  
  (: Because this call returns data, we need to know if we have a reasonable
     content type before we do anything - updating and then finding an error
     would be bad 
  :)
  let $dummy := if (not($content-type)) 
    then su:bad-content-type($context)
    else ()
  
  
  let $dummy := if (not($presentation-id) )
    then fn:error((), "RESTAPI-SRVEXERR", (500, "Parameter(s) missing", 
        "The presentation parameter is required."))
    else ()
    
  let $presentation as object-node() := presentations:load-single-presentation($presentation-id)
  
  (: The number of parameters defines what we are doing :)
  return 
    if ($deck-id and $slide-id) 
      then presentations:update-slide-in-presentation($context, $content-type, $presentation, $deck-id, $slide-id)
      else if ($deck-id)
            then presentations:update-deck-in-presentation($context, $content-type, $presentation, $deck-id)
            else presentations:update-presentation($context, $content-type, $presentation, $input)
};



(:
  Add a new presentation.
  The input document must be a JSON document representing the new presentation. At creation
  time we only require the title of the presentation to be present. Other fields can be omitted.
:)
declare 
%roxy:params("format=xs:string?")
%rapi:transaction-mode("update")
function presentations:put(
  $context as map:map,
  $params as map:map,
  $input as document-node()*
) as document-node()?
{
  let $content-type as xs:string? := su:get-format($context, $params)
  let $data := $input/node()
  let $type := xdmp:node-kind($data)

  (: Because this call returns data, we need to know if we have a reasonable
     content type before we do anything - updating and then finding an error
     would be bad 
  :)
  let $dummy := if (not($content-type)) 
    then su:bad-content-type($context)
    else ()
    
  (: We *must* have a uploaded document :)
  let $dummy := if (empty($input))
    then fn:error((), "RESTAPI-SRVEXERR", (500, "Body required", 
        "There is not presentation to create!"))
    else ()   
    
  (: And that uploaded document must be of type object or element :)
  let $dummy := if (not($type = ('element', 'object')))
    then fn:error((), "RESTAPI-SRVEXERR", (500, "Invalid content", 
        "Document must be a JSON object"))
    else ()
    
  (: Don't use the object directly, create a new presentation based
  on the input. We are liberal here since a presentation can be 
  valid (in some sense) with only an id. We set the title and author
  because an empty sequence is generated without the if and that's
  invalid in JSON :)
  
  let $title := if ($type = 'element') then $data/pres:title/data() else $data/title
  let $author := if ($type = 'element') then $data/pres:author/data() else $data/author
  let $description := if ($type = 'element') then $data/pres:description/data() else $data/description
  
  let $presentation := object-node { 
    'id':  concat('pres', generate-id($input/node())), 
    'title': ($title, '')[1],
    'author': ($author, '')[1],
    'description': ($description, '')[1],
    'updated': format-date(current-date(), '[Y0001]-[M01]-[D01]'),
    'decks': array-node{ () } 
   }
   
  (: Now we need to append that to the presentations document. We get the document
  and overwrite the original as we are only appending to the list. :)
  let $presentations := array-node { 
      doc('/presentations/presentations.json')/array-node()/object-node(),
      $presentation }
  
  let $dummy := xdmp:document-insert('/presentations/presentations.json', $presentations)
    
  return presentations:single-presentation-as($context, $content-type, $presentation )
};


(:
  Delete a presentation.
  If the presentation exists it is deleted and the deleted presentation is returned.
  If not a 404 error is raised.
:)
declare 
%roxy:params("presentation=xs:string,format=xs:string?")
function presentations:delete(
    $context as map:map,
    $params  as map:map
) as document-node()?
{
  let $content-type as xs:string? := su:get-format($context, $params)
  let $presentation-id as xs:string? := map:get($params, 'presentation')
  
   (: Because this call returns data, we need to know if we have a reasonable
     content type before we do anything - updating and then finding an error
     would be bad 
  :)
  let $dummy := if (not($content-type)) 
    then su:bad-content-type($context)
    else ()
    
  (: If we have no presentation id, return an error :)
  let $dummy := if (not($presentation-id))
    then fn:error((), "RESTAPI-SRVEXERR", (400, "Parameter(s) missing", 
        "The presentation is required."))
    else ()


  (:  Rewrite without the presentation to be deleted :)
  let $presentations as object-node()* := presentations:load-all-presentations()
  
  (: Get the one we are deleting :)
  let $to-delete := $presentations[id = $presentation-id]
  
  (: Got it? :)
  let $dummy := if (not($to-delete))
    then fn:error((), "RESTAPI-SRVEXERR", (404, "Presentation not found", 
        concat("Presentation with id ", $presentation-id, " not found")))
    else ()
    
  (: Rewrite :)
  let $remainder := array-node { $presentations[not(id = $presentation-id)] }
  let $dummy := xdmp:document-insert('/presentations/presentations.json', $remainder)

  (: Done :)
  return presentations:single-presentation-as($context, $content-type, $to-delete )
};




(: 
  Update the presence of a deck in a presentation. If already present, remove it
  and if not add it.
:)
declare 
%rapi:transaction-mode("update")
function presentations:update-deck-in-presentation( 
  $context-as map:map,
  $content-type as xs:string, 
  $presentation as object-node(),
  $deck-id as xs:string) 
  as document-node()
{
 (: find the deck within that presentation :)
  let $decks as array-node() := $presentation/array-node('decks')
  let $deck := $decks/object-node()[id = $deck-id]

  let $new-decks := 
    array-node {  
      if ($deck) 
      then $decks/object-node()[not(id = $deck-id)]
      else ($decks/object-node(), object-node { "id": $deck-id, "exclude": array-node{()}})
    } 

  (: Update - TODO - put this into a separate transaction so we 
  can simply return the changed doc :)
  let $dummy := xdmp:node-replace($decks, $new-decks)

  
  (: Build an 'updated' copy of the input to return :)
  let $new-presentation := object-node {
    'id': $presentation/id,
    'title': $presentation/title,
    'description': $presentation/description,
    'author': $presentation/author,
    'updated': $presentation/updated,
    'decks': $new-decks
  }


  return presentations:single-presentation-as($context, $content-type, $new-presentation )
};


declare
%rapi:transaction-mode("update")
function presentations:update-presentation(
  $context as map:map,
  $content-type as xs:string,
  $presentation as document-node(), 
  $new-presentation as document-node())
as document-node()
{
  presentations:single-presentation-as($context, $content-type, $presentation )
};


(: 
  Update a slide's visibility in a presentation. Given the ids of the presentation
  and deck, the slide id is added to the excludes array if not present and removed
  if it is present. No checking is done on the slide id as no particular damage is 
  done if it is not correct (this should change in future).
  
:)
declare 
%rapi:transaction-mode("update")
function presentations:update-slide-in-presentation( 
  $context-as map:map
  $content-type as xs:string, 
  $presentation as object-node(),
  $deck-id as xs:string, 
  $slide-id as xs:string) 
  as document-node()
{

  (: find the deck within that presentation :)
  let $deck as object-node()? := $presentation/decks[id = $deck-id]

  (: It's an error if that deck is not present :)
  let $dummy := if (not($deck))
    then fn:error((), "RESTAPI-SRVEXERR", (404, "Deck not found.", 
        concat("The presentation with id ", $presentation/id, " does not contain the deck with id ", $deck-id)))
    else ()  
  
  (: Now check for the presence of the slide. We append it to the array and update if not present and
     remove it and update if it is :)
  let $excludes := $deck/array-node('exclude')
  
  let $new-excludes := if ($slide-id = $excludes/node()) 
    then array-node { $excludes/node()[not(. = $slide-id)] }
    else array-node { ($excludes/node(), $slide-id) }
    
  (: Update - TODO - put this into a separate transaction so we 
  can simply return the changed doc :)
  let $dummy := xdmp:node-replace($excludes, $new-excludes)
  
  (: Build an 'updated' copy of the input to return :)
  let $new-presentation := object-node {
    'id': $presentation/id,
    'title': $presentation/title,
    'description': $presentation/description,
    'author': $presentation/author,
    'updated': $presentation/updated,
    'decks': array-node {
    for $deck in $presentation/decks 
      return if ($deck/id = $deck-id) 
        then object-node { 'id': $deck/id, 'exclude': $new-excludes }
        else $deck }
  }
  
  return presentations:single-presentation-as($context, $content-type, $new-presentation )

};


(:
  Choose whether to return a single presentation as XML or JSON
:)
declare function presentations:single-presentation-as(
  $context as map:map, 
  $format as xs:string, 
  $presentation as object-node()) as document-node()*
{
    map:put($context, 'output-types', $format),
    map:put($context, "output-status", (200, "OK")),
    if ($format eq 'application/json') 
      then document { $presentation } 
      else document { presentations:presentation-as-xml($presentation) } 
};

(:
  Choose whether to return the presentations info as XML or JSON
  (the document in the DB is natively JSON) but we default to returning XML
:)
declare function presentations:all-presentations-as(
  $context as map:map, 
  $format as xs:string, 
  $presentations as object-node()*) as document-node()*
{ 
    map:put($context, 'output-types', $format),
    map:put($context, "output-status", (200, "OK")),
    if ($format eq 'application/json') 
      then document { array-node { $presentations }} 
      else document { 
        <pres:presentations>
        {
          for $pres in $presentations return presentations:presentation-as-xml($pres) 
        }
        </pres:presentations> }   
};


(:
  Load a single presentation from the presentations document
:)
declare function presentations:load-single-presentation($presentation-id as xs:string) as object-node()
{
    let $pres as object-node() := 
      doc('/presentations/presentations.json')/array-node()/object-node()[id = $presentation-id]
    
    return 
      if ($pres) then presentations:merge-presentation($pres)
      else fn:error((), "RESTAPI-SRVEXERR", (404, "Presentation not found", 
        concat("Presentations with id ", $presentation-id, " not found")))
};


(:
  Load all the documents from the input and return as a sequence of nodes
  rather than an array (in order to make the rest of the code work consistently)
:)
declare function presentations:load-all-presentations() as object-node()*
{
   document('/presentations/presentations.json')/array-node()/object-node()
};

(:
  Return the JSON document as XML. It needs a little reformatting
  to be as we want it.
:)
declare function presentations:presentation-as-xml($presentation as object-node()) as element(pres:presentation)
{

  <pres:presentation id="{$presentation/id}">       
      <pres:title>{$presentation/title}</pres:title>
      <pres:author>{$presentation/author}</pres:author>
      <pres:updated>{$presentation/updated}</pres:updated> 

      <decks>
      { 
        for $deck in $presentation/decks return 
          <pres:deck id="{$deck/id}">
          { 
            for $title in $deck/title return
              <pres:title>{$title/data()}</pres:title>,
                            
            for $slide in $deck/slides return
              <pres:slide>
                <pres:title>{$slide/title/data()}</pres:title>
                <pres:id>{$slide/id/data()}</pres:id>
              </pres:slide>

          }
          </pres:deck>
       }
       </decks>
  </pres:presentation>
};


(: Merge decks for a presentation into that presentation :)
declare function presentations:merge-presentation($presentation as object-node()) as object-node()
{ 
  let $decks := 
    for $deck in $presentation/decks return su:convert-deck-to-json(su:load-single-deck($deck/id))
    
  return object-node {
    "id": $presentation/id,
    "title": $presentation/title,
    "author": $presentation/author,
    "updated": $presentation/updated,  
    "description": $presentation/description,
    "decks":  
      array-node 
      { 
        $decks
      }    
    }
};
