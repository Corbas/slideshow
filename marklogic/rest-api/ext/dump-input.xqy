xquery version "1.0-ml";

module namespace slides = "http://marklogic.com/rest-api/resource/dump-input";

declare namespace roxy = "http://marklogic.com/roxy";
declare namespace rapi = "http://marklogic.com/rest-api";

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
%roxy:params("")
function slides:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "text/html"),
  map:put($context, "output-status", (200, "OK")),
  
  document {
    <html>
      <head><title>Parameter/Context Dump</title>
      </head>
      <body>
        <h1>Parameter/Context Dump</h1>
        
        <h2>Parameters</h2>
        <table>
          <thead>
          <tr>
          <th>Parameter</th>
          <th>Value(s)</th>
          </tr>
          </thead>
          <tbody>
          
            { 
                for $key in map:keys($params)
                return <tr><td>{$key}</td><td>{
                  for $val in map:get($params, $key) return if ($val instance of xs:anySimpleType) then ($val, <br/>) else ('binary', <br/>) 
                }</td></tr>
            }
            
          
          </tbody>
          
          </table>
          
        <h2>Context</h2>
        <table>
          <thead>
          <tr>
          <th>Parameter</th>
          <th>Value(s)</th>
          </tr>
          </thead>
          <tbody>
          
            { 
                for $key in map:keys($context)
                return <tr><td>{$key}</td><td>{
                  for $val in map:get($context, $key) return if ($val instance of xs:anySimpleType) then ($val, <br/>) else ('binary', <br/>) 
                }</td></tr>
            }
            
          
          </tbody>
          
          </table>
          
      </body>
      </html> }
  
};

