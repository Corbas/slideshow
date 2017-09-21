xquery version "1.0-ml";

module namespace facets = "http://marklogic.com/rest-api/resource/facets";

import module namespace search="http://marklogic.com/appservices/search"
                    at "/MarkLogic/appservices/search/search.xqy";

import module namespace su = "http://www.corbas.co.uk/ns/slides-utils"
    at "/slide-utils.xqy";
    
    
declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";
declare namespace pres = "http://www.corbas.co.uk/ns/presentations";

(:
Implements the API used for faceted search and browse. 
Calling this with no parameters will return all the facets. 
Calling with parameters (facet) will return results.
 :)
declare 
%roxy:params("format=xs:string?")
function facets:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  let $content-type as xs:string? := su:get-format($context, $params)
  
  
  let $facets as element(pres:facets) :=  facets:get-facets()
  
  return if ($content-type) 
    then facets:get-facets-as($context, $content-type, $facets)
    else 
      su:bad-content-type($context)
};


(:
  Get facets and convert them to our (simplified) XML
:)
declare function facets:get-facets() as element(pres:facets)
{
  let $results :=  search:search("",
    <options xmlns="http://marklogic.com/appservices/search">
      <return-results>false</return-results>
      <return-facets>true</return-facets>
      <constraint name="keywords"  facet="true">
        <range type="xs:string">
            <element ns="http://www.corbas.co.uk/ns/presentations" name="keyword"/>
        </range>
      </constraint>
            <constraint name="levels"  facet="true">
        <range type="xs:string">
            <element ns="http://www.corbas.co.uk/ns/presentations" name="level"/>
        </range>
      </constraint>
    </options>)

    return 
    <pres:facets>
    {
      for $facet in $results/search:facet return
      <pres:facet name="{$facet/@name}">
      {
        for $value in $facet/search:facet-value
        order by $value/@count descending, $value/@name
        return <pres:value name="{$value/@name}" count="{$value/@count}"/>
      }
      </pres:facet>
    }
    </pres:facets>

};


(:
  Determine whether to return JSON or XML
:)
declare function 
  facets:get-facets-as($context as map:map, $content-type as xs:string, $facets as element(pres:facets))
  as document-node()
{
    map:put($context, 'output-types', $content-type),
    map:put($context, "output-status", (200, "OK")),

    if ($content-type eq 'application/xml') 
      then document { $facets } 
      else document { facets:facets-as-json($facets) } 
};


(:
  Return facets as JSON
:)
declare function facets:facets-as-json($facets as element(pres:facets)) as array-node()
{ 
    array-node {
      for $facet in $facets/pres:facet  
      return
        object-node {
          "name":   text {$facet/@name },
          "values":  array-node {
            for $value in $facet/pres:value
            return object-node { "name": text { $value/@name }, "count": text { $value/@count }}
           }
        }
      }
};


