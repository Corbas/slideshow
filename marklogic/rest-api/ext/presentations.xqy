xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/presentations";

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

 
  map:put($context, "output-types", "application/xml"),
  map:put($context, "output-status", (200, "OK")),
  document { "GET called on the ext service extension" }
};



declare function slides:get-output-format($context as map:map) 
{
    


}