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
declare function su:bad-content-type($context as map:map) as document-node()*
{
  
  map:put($context, "output-types", "text/plain"),
  map:put($context, "output-status", (500, "Internal System Error")),
  document { "Acceptable content types did not contain XML or JSON" }
};



(:
  Load a deck from the database and simplify it to exclude slide content.
  This is used when loading presentations or loading decks for editing.
  We use xdmp:directory here because the search set is tiny.
:)
declare function su:load-and-simplify-deck($deck-id as xs:string) as element(pres:deck)?
{
  let $deck := xdmp:directory('/decks/')/pres:div[pres:meta/pres:id = $deck-id]
  
  return
   <pres:div>
    {
      $deck/pres:meta, $deck/pres:title
    }
    { for $slide in $deck/pres:slide
        return 
          <pres:slide>
            {$slide/@*, $slide/pres:title}
          </pres:slide>
    }
  </pres:div>

};