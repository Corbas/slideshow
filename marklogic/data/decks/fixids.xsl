<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="http://www.corbas.co.uk/ns/presentations"
  xpath-default-namespace="http://www.corbas.co.uk/ns/presentations"
  exclude-result-prefixes="xs math xd"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 21, 2017</xd:p>
      <xd:p><xd:b>Author:</xd:b> nicg</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="slide[not(@xml:id)]">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="xml:id" select="generate-id()"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>