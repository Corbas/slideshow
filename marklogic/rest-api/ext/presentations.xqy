xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/presentations";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";


(:
  Generate a list of the presentations in the database. Return XML or JSON depending on 
  requested format (either in the 'format' parameter or the header. If the headers allow for 
  both XML & JSON and no format is defined, return XML.
:)
declare 
%roxy:params("")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{

  let $content-type as xs:string? := slides:get-format($context, $params)
  let $ignore := xdmp:log(concat("format found was ", $content-type))
  
  return if ($content-type) then
    slides:presentations-as($context, $content-type)
    else slides:bad-content-type($context)

};



(:
  Get the content type for return. If it isn't xml or json this 
  will return an empty sequence. If it is, it will return the 
  content type

:)
declare function slides:get-format($context as map:map, $params as map:map) as xs:string?
{
    let $accept as xs:string+ :=  map:get($context, 'accept-types')
    let $format as xs:string? := map:get($params, 'format')[1]

    return (slides:get-format-as-content-type($params), slides:get-accepted-type($context))[1]
};

(:
  Choose whether to return the presentations info as XML or JSON
  (the document in the DB is natively JSON)
:)
declare function slides:presentations-as($context as map:map, $format as xs:string) as document-node()*
{
  
    map:put($context, 'output-types', $format),
    map:put($context, "output-status", (200, "OK")),
    if ($format eq 'application/json') 
      then document('/presentations/presentations.json') 
      else document { slides:presentations-as-xml() }
    
};





(:
  Extract a format parameter from params if found
  If the parameter contains xml then  return 'application/xml'
  If it doesn't and it does contain 'json' then return 'application/json' 
  Otherwise return an empty sequence
:)
declare function slides:get-format-as-content-type($params as map:map) as xs:string?
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
  Return the JSON document as XML
:)
declare function slides:presentations-as-xml() as element()
{
  let $config := json:config("custom")
  let $json := doc("/presentations/presentations.json")
  let $xml := json:transform-from-json($json, $config)
  
  return 
  <presentations>
  {
    for $presentation in $xml
      return 
        <presentation>
        
        { 
          $presentation/id, $presentation/author, $presentation/title, $presentation/updated,
          <decks>
            { for $deck in $presentation/decks return 
            <deck>{$deck/node()}</deck> }
          </decks>
        }
        </presentation>
  }
  </presentations>
      

};



(:
  Extract from the 'accept-types' key.
  If it contains 'application/xml' return that
  If not and it contains 'application/json' return that
  If not return an empty sequence.
:)
declare function slides:get-accepted-type($context as map:map) as xs:string?
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
declare function slides:bad-content-type($context as map:map) as document-node()*
{
  map:put($context, "output-types", "text/plain"),
  map:put($context, "output-status", (500, "Internal System Error")),
  document { "Acceptable content types did not contain XML or JSON" }
};


