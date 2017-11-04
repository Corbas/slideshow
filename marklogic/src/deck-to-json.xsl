<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:json="http://marklogic.com/xdmp/json"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:pres="http://www.corbas.co.uk/ns/presentations" exclude-result-prefixes="math xd"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 1, 2017</xd:p>
      <xd:p><xd:b>Author:</xd:b> nicg</xd:p>
      <xd:p>Convert a deck into an XML representation of JSON. The deck will already have been simplified.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:output indent="yes"/>

  <xd:doc>
    <xd:desc>Transform a deck into an object.</xd:desc>
  </xd:doc>
  <xsl:template match="pres:div">
    <json:object>
      <xsl:apply-templates select="pres:meta | pres:title"/>
      <json:entry>
        <json:key>slides</json:key>
        <json:value>
          <json:array>
            <xsl:apply-templates select="pres:slide"/>
          </json:array>
        </json:value>
      </json:entry>
    </json:object>
  </xsl:template>


  <xd:doc>
    <xd:desc>The level, id and title elements simply transform to entries.</xd:desc>
  </xd:doc>
  <xsl:template match="pres:id | pres:level | pres:title | pres:slide/@xml:id">
    <json:entry>
      <json:key>
        <xsl:value-of select="local-name()"/>
      </json:key>
      <json:value xsi:type="xs:string">
        <xsl:value-of select="."/>
      </json:value>
    </json:entry>
  </xsl:template>

  <xd:doc>
    <xd:desc>Transform keywords into JSON values to placed in the keywords array</xd:desc>
  </xd:doc>
  <xsl:template match="pres:keyword">
    <json:value xsi:type="xs:string">
      <xsl:value-of select="."/>
    </json:value>
  </xsl:template>

  <xd:doc>
    <xd:desc> Transform metadata into a JSON entry containing level, keywords and id data. </xd:desc>
  </xd:doc>
  <xsl:template match="pres:meta">
    <json:entry>
      <json:key>meta</json:key>
      <json:value>
        <json:object>
          <xsl:apply-templates select="pres:id | pres:level"/>
          <json:entry>
            <json:key>keywords</json:key>
            <json:value><json:array>
              <xsl:apply-templates select="pres:keyword"/>
            </json:array></json:value>
          </json:entry>
        </json:object>
      </json:value>
    </json:entry>
  </xsl:template>

  <xd:doc>
    <xd:desc> Transform a slide into an entry with an object value. </xd:desc>
  </xd:doc>
  <xsl:template match="pres:slide">
      <json:value>
        <json:object>
          <xsl:apply-templates select="@xml:id | pres:title"/>
        </json:object>
      </json:value>
  </xsl:template>

</xsl:stylesheet>
