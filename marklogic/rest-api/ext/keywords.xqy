xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/keywords";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace p = "http://www.corbas.co.uk/ns/presentations";



(:
  Generate a list of unique keyword values
 :)
declare 
%roxy:params("")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "application/json"),
  map:put($context, "output-status", (200, "OK")),
  document { object-node { 'keywords' : xdmp:to-json(cts:element-values(xs:QName('p:keyword'))) } }
};

