xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/list-decks";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";
    
import module namespace du = "http://www.corbas.co.uk/ns/deck-utils"
    at "/deck-utils.xqy";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://www.corbas.co.uk/ns/presentations";

(:
  : Handle CORS options requests
:)
declare
%roxy:params("")
function slides:options(
  $context as map:map,
  $params as map:map
) as document-node()* {

    map:put($context, 'output-types', "text/plan"),
    map:put($context, "output-status", (200, "OK")),
    document {'ok'}
};

(:
  Return all the decks in the database. 
 :)
declare 
%roxy:params("")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()* {

  let $content-type as xs:string? := su:get-format($context, $params)
  let $deck-id as xs:string? := map:get($params, 'deck')
 
  
  return if ($content-type) 
    then
      if ($deck-id) 
        then slides:deck-as($context, $content-type)
        else slides:decks-as($context, $content-type)
    else 
      su:bad-content-type($context)
};


declare function slides:decks-as($context, $content-type) as document-node()? {

    map:put($context, 'output-types', $content-type),
    map:put($context, "output-status", (200, "OK")),
    if ($content-type eq 'application/xml')
      then  
        document { slides:decks-as-xml() }
      else 
        document { slides:decks-as-json() }
};


declare function slides:decks-as-xml() as element(pres:decks)?
{
  <pres:decks>
  {
    for $deck in du:load-all-decks() return du:simplify-deck($deck)
  }
  </pres:decks>
 
};

declare function slides:decks-as-json() as array-node()
{
  du:convert-decks-to-json(du:load-and-simplify-all-decks())
};