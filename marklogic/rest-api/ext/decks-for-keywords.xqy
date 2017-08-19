xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/decks-for-keywords";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace p = "http://www.corbas.co.uk/ns/presentations";

(:
 : To add parameters to the functions, specify them in the params annotations.
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") slides:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :
 : To report errors in your extension, use fn:error(). For details, see
 : http://docs.marklogic.com/guide/rest-dev/extensions#id_33892, but here's
 : an example from the docs:
 : fn:error(
 :   (),
 :   "RESTAPI-SRVEXERR",
 :   ("415","Raven","nevermore"))
 :)

(:
 :)
declare 
%roxy:params("keyword=xs:string+")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "application/json"),
  map:put($context, "output-status", (200, "OK")),
  document { object-node { 'decks' : xdmp:to-json(slides:find-docs(map:get($params, 'keyword'))) } }
};




(:
  given a set of keywords return the ids of the
  decks which have all the matching keywords
:)
declare function slides:find-docs(
  $keywords as xs:string*) as map:map*
{
  let $docs := cts:search(fn:collection(), 
    cts:and-query(
      for $keyword in $keywords return cts:element-value-query(xs:QName('p:keyword'), $keyword)
      )
    )
    
  return map:new(
    for $doc in $docs return map:entry($doc//p:id/data(), document-uri($doc)))
  

};