xquery version "1.0-ml";

module namespace du = "http://www.corbas.co.uk/ns/deck-utils";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";


declare namespace pres = "http://www.corbas.co.uk/ns/presentations";

(:
  Load a deck from the database and simplify it to exclude slide content.
  This is used when loading presentations or loading decks for editing.
  We use xdmp:directory here because the search set is tiny.
  
  We force the order of metadata because the schema doesn't require it.
:)
declare function du:load-and-simplify-deck($deck-id as xs:string) as element(pres:div)?
{
  let $deck := du:load-deck($deck-id)
  return if ($deck) then du:simplify-deck($deck) else () 
};

(:
  Load and simplify all decks 
:)
declare function du:load-and-simplify-all-decks() as element(pres:div)*
{
  for $deck in du:load-all-decks() return du:simplify-deck($deck)
};

(:
    Load a single deck via its id
:)
declare function du:load-deck($deck-id as xs:string) as element(pres:div)?
{
  xdmp:directory('/decks/')/pres:div[pres:meta/pres:id = $deck-id]
};


(:
    Load all the decks 
:)
declare function du:load-all-decks() as element(pres:div)*
{
  for $deck in xdmp:directory('/decks/') order by $deck/pres:div/pres:title return $deck/pres:div
};

(:
  Simplify a deck. Refactored from load-and-simplify to be used
  when loading all decks. Simplified decks have all the slide content removed.
  In a future version it would be helpful to store slides separately to decks
  and this gives a API that won't change.
:)
declare function du:simplify-deck($deck as element(pres:div)) as element(pres:div)
{
 <pres:div>
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
  </pres:div>
};


(:
    Given an XML document representing a deck transform it to JSON.
:)
declare function du:convert-decks-to-json($decks as element(pres:div)*) as document-node()*
{
    let $config := json:config('custom')
    let $x := map:put($config, 'whitespace', 'ignore')
    let $x := map:put($config, 'array-element-names', (xs:QName('pres:slide'), xs:QName('pres:keyword') ))
    
    for $deck in $decks return  document { json:transform-to-json($deck ,$config) }      
};
