xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/list-presentations";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";
    
import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://wwww.corbas.co.uk/ns/presentations";
  

(:
  Generate a list of the presentations in the database. Return XML or JSON depending on 
  requested format (either in the 'format' parameter or the header. If the headers allow for 
  both XML & JSON and no format is defined, return XML. A basic outline of the decks in the
  presentations is returned. The empty fields are used to keep TypeScript happy.
:)
declare 
%roxy:params("")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{

  let $content-type as xs:string? := su:get-format($context, $params)
  
  return if ($content-type) then
    slides:presentations-as($context, $content-type)
    else su:bad-content-type($context)
};



(:
  Choose whether to return the presentations info as XML or JSON
  (the document in the DB is natively JSON) but we default to returning XML
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
  Return the JSON document as XML. It needs a little reformatting
  to be as we want it.
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
            <deck>{$deck/data()}</deck>
             }
          </decks>
        }
        </presentation>
  }
  </presentations>
      

};


