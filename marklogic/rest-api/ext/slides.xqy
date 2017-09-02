xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/slides";

import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://www.corbas.co.uk/ns/presentations";


(:
 : Extension to fech a single slide for a deck as html.
 : Deck and slide ids are required.
 : The deck id (deck parameter) is required and either the slide id (slide parameter)
 : or the slide index (index param) is required.
:)

(:
 :)
declare 
%roxy:params("deck=xs:string", "slide=xs:string?", "index=xs:string?")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "application/xml"),
  map:put($context, "output-status", (200, "OK")),
  slides:transform-slide(slides:get-slide($params))
};


(:
  Return true if the required parameters are found. False if not.
:)
declare function slides:params-present($params as map:map) as xs:boolean
{
  map:contains($params, 'deck') and (map:contains($params, 'slide') or map:contains($params, 'index'))
};


(:
   The slides in the deck are in an XML/XHTML5 hybrid format. Convert them and set up code blocks
   for use by highlight.js
:)
declare function slides:transform-slide($slide as element(pres:slide)) as document-node()
{
  xdmp:xslt-invoke('/slides.xsl', $slide)
};

(:
  Load a slide from the deck and return it (as xml).
  Returns an empty sequence if not found.
:)
declare function slides:get-slide($params as map:map) as element(pres:slide)?
{
    if (map:contains($params, 'index')) then slides:get-slide-by-index($params) else slides:get-slide-by-id($params)
};

(:
  Load a slide from the deck by index (number of slide in the deck).
  We could do this via search but leave that until there are enough decks to make it worthwhile
:)
declare function slides:get-slide-by-index($params as map:map) as element(pres:slide)?
{
  let $deck := map:get($params, 'deck')
  let $index := map:get($params, 'index')
  
  return (xdmp:directory('/decks/')/pres:div[pres:meta/pres:id[. = $deck]]//pres:slide)[position() = xs:integer($index)]  
};


(:
  Load a slide from the deck by index (number of slide in the deck).
  We could do this via search but leave that until there are enough decks to make it worthwhile
:)
declare function slides:get-slide-by-id($params as map:map) as element(pres:slide)?
{
  let $deck := map:get($params, 'deck')
  let $id := map:get($params, 'id')
  
  return (xdmp:directory('/decks/')/pres:div[pres:meta/pres:id[. = $deck]]//pres:slide)[(@id, @xml:id) = $id]
};


(:
  If the parameters aren't both present return an error
:)
declare function slides:bad-params($context as map:map) as item()*
{
  fn:error((), "RESTAPI-SRVEXERR", (400, "Missing parameter(s)", "The 'deck' and 'slide/index' parameters are required"))
};


(:
  If the slide isn't found return an error
:)
declare function slides:missing-slide($context as map:map) as item()*
{
    fn:error((), "RESTAPI-SRVEXERR", (404, "Slide not found", "The requested slide was not found"))
};