xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/decks";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";
    
declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://www.corbas.co.uk/ns/presentations";

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
  
  let $decks as element(pres:deck)* :=  
    for $deck in (if ($deck-id) 
      then su:load-single-deck($deck-id)
      else slides:load-all-decks()) return slides:simplify-deck($deck)
  
  return if ($content-type) 
    then
      if ($deck-id) 
        then slides:single-deck-as($context, $content-type, $decks)
        else slides:all-decks-as($context, $content-type, $decks)     
    else 
      su:bad-content-type($context)
};

(:
  Structure a single deck for output
:)
declare function slides:single-deck-as(
  $context as map:map, 
  $content-type as xs:string, 
  $deck as element(pres:deck))
  as document-node()? {
   
    map:put($context, 'output-types', $content-type),
    map:put($context, "output-status", (200, "OK")),
    if ($content-type eq 'application/xml')
      then  
        document { $deck }
      else 
        document { su:convert-deck-to-json($deck) }
};


(:
  Structure multiple decks for a deck listing for output
:)
declare function slides:all-decks-as(
  $context as map:map, 
  $content-type as xs:string,
  $decks as element(pres:deck)*) as document-node()? {

    map:put($context, 'output-types', $content-type),
    map:put($context, "output-status", (200, "OK")),
    if ($content-type eq 'application/xml')
      then  
        document { <pres:decks>{ $decks }</pres:decks> }
      else 
        document { array-node { for $deck in $decks return su:convert-deck-to-json($deck) } }
};



(:
    Load all the decks 
:)
declare function slides:load-all-decks() as element(pres:deck)*
{
  for $deck in xdmp:directory('/decks/') order by $deck/pres:deck/pres:title return $deck/pres:deck
};

(:
  Simplify a deck. Refactored from load-and-simplify to be used
  when loading all decks. Simplified decks have all the slide content removed.
  In a future version it would be helpful to store slides separately to decks
  and this gives an API that shouldn't change.
:)
declare function slides:simplify-deck($deck as element(pres:deck)) as element(pres:deck)
{
 <pres:deck>
    {
      $deck/pres:meta/pres:id, 
      $deck/pres:meta/pres:keyword,
      $deck/pres:meta/pres:level,
      $deck/pres:meta/pres:author,
      $deck/pres:meta/pres:updated,
      $deck/pres:title
    }
    { for $slide in $deck/pres:slide
        return 
          <pres:slide>
            {$slide/@*, $slide/pres:title}
          </pres:slide>
    }
  </pres:deck>
};




