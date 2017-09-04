xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/deck";

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
 : Fetch deck metadata from the database. The metadata is the deck, its metadata 
 : and the id and title of each slide with an enabled/disabled flag.
 : 
 : 
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
%roxy:params("deck=xs:string")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  let $content-type as xs:string? := su:get-format($context, $params)
  
  return if ($content-type) then
    slides:deck-as($context, $params, $content-type)
    else su:bad-content-type($context)
};


(:
  Choose whether to return the presentations info as XML or JSON
  (the document in the DB is natively JSON) but we default to returning XML
:)
declare function slides:deck-as($context as map:map, $params as map:map, $format as xs:string) as document-node()*
{
   
    map:put($context, 'output-types', $format),
    map:put($context, "output-status", (200, "OK")),
    if ($format eq 'application/xml') 
      then document { slides:load-deck($params) }  
      else du:convert-decks-to-json(slides:load-deck($params))
};


(:
    Extract the deck id from the parameters and fetch the
    deck from the database. Raises errors if the parameter is missing
    or if no deck with that id exists.
:)
declare function slides:load-deck($params) as document-node()?
{
    let $deck-id := map:get($params, 'deck')
    let $deck := if ($deck-id) then  document { du:load-and-simplify-deck($deck-id) } 
      else fn:error((), "RESTAPI-SRVEXERR", (400, "Missing parameter", "The 'deck' parameter is required"))
    
    return if ($deck) then $deck 
      else fn:error((), "RESTAPI-SRVEXERR", (404, "Deck not found", concat("Deck with id", $deck-id, " not found")))
};

