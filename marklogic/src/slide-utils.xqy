xquery version "1.0-ml";

module namespace su = "http://www.corbas.co.uk/ns/slides-utils";

declare namespace pres = "http://www.corbas.co.uk/ns/presentations";
 
(:
  Get the content type for return. If it isn't xml or json this 
  will return an empty sequence. If it is, it will return the 
  content type.

:)
declare function su:get-format($context as map:map, $params as map:map) as xs:string?
{
    (su:get-format-as-content-type($params), su:get-accepted-type($context))[1]
};


(:
  Extract a format parameter from params if found
  If the parameter contains xml then  return 'application/xml'
  If it doesn't and it does contain 'json' then return 'application/json' 
  Otherwise return an empty sequence
:)
declare function su:get-format-as-content-type($params as map:map) as xs:string?
{
  let $format as xs:string* := map:get($params, 'format')[1]
  
  return 
    if ($format) then 
      if ($format eq 'xml') then 'application/xml'
      else 
        if ($format eq 'json') then 'application/json'
        else ()
    else () 
};

(:
  Extract from the 'accept-types' key.
  If it contains 'application/xml' return that
  If not and it contains 'application/json' return that
  If not return an empty sequence.
:)
declare function su:get-accepted-type($context as map:map) as xs:string?
{
  let $accepted as xs:string* := map:get($context, 'accept-types')
      
  return 
    if ($accepted) then 
      if ($accepted = 'application/xml') then 'application/xml'
      else 
        if ($accepted = 'application/json') then 'application/json'
        else ()
    else ()
};

(:
  If the content type is not acceptoble, return a simple error
:)
declare function su:bad-content-type($context as map:map) as item()*
{
   fn:error((), "RESTAPI-SRVEXERR", (400, "No usable content type", "Acceptable content types did not contain XML or JSON"))
};


(:
  The deck to json code is used in presentation and deck
  modules so we keep it here
:)
(:
    Given an XML document representing a deck transform it to JSON.
:)
declare function su:convert-deck-to-json($deck as element(pres:deck)) as object-node()
{
    object-node {
        "id"  : text { $deck/pres:meta/pres:id },
        "title" : text { $deck/pres:title } ,
         "level": text { $deck/pres:meta/pres:level },
        "author": text { $deck/pres:meta/pres:author },
        "updated": text { $deck/pres:meta/pres:updated },
        "keywords": array-node {
          for $kw in $deck/pres:meta/pres:keyword return text { $kw } },
         "slides": array-node {
          for $slide in $deck/pres:slide return 
            object-node { 
               "id": text { $slide/@xml:id },
               "title": text { $slide/pres:title } }
        }
      }                  
};




(:
    Extract the deck id from the parameters and fetch the
    deck from the database. Raises errors if the parameter is missing
    or if no deck with that id exists. This function is also used in
    multiple modules.
:)
declare function su:load-single-deck($deck-id as xs:string) as element(pres:deck)?
{
    let $deck := if ($deck-id) then  xdmp:directory('/decks/')/pres:deck[pres:meta/pres:id = $deck-id]  
      else fn:error((), "RESTAPI-SRVEXERR", (400, "Missing parameter", "The 'deck' parameter is required"))
    
    return if ($deck) then $deck
      else fn:error((), "RESTAPI-SRVEXERR", (404, "Deck not found", concat("Deck with id ", $deck-id, " not found")))
};