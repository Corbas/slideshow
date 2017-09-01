<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:p="http://www.corbas.co.uk/ns/presentations"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:cfn="http://www.corbas.co.uk/ns/functions"
	xmlns:xdmp="http://marklogic.com/xdmp" 	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xpath-default-namespace="http://www.corbas.co.uk/ns/presentations"
	exclude-result-prefixes="xs xdmp xsl p xd cfn" version="2.0">
	
	<xsl:import href="verbatim-base.xsl"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Stylesheet to convert slides into HTML for presentation. The conversion of XML/XHTML to 
			escaped text is a bit rough and ready but should work for these purposes.</xd:p>
		</xd:desc>
		<xd:param name="output-root-element">The top level element for a slide. Defaults to 'div'.</xd:param>
		<xd:param name="title-element">The element to use for slide titles. Defaults to 'h2'</xd:param>
	</xd:doc>


	<xsl:strip-space elements="p:code"/>
	<xsl:param name="output-root-element" select="'div'"/>
	<xsl:param name="title-element" select="'h2'"/>

	<xd:doc>
		<xd:desc>
			<xd:p>By default we copy to the output.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@* | node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p xmlns="http://www.w3.org/1999/xhtml">Slides just contain elements which may or may not be processed. Apply templates to the lot.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="slide">
		<xsl:element name="{$output-root-element}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class" select="string-join(('slide', @class), ' ')"/>
			<xsl:attribute name="id" select="(@xml:id, @id, generate-id())[1]"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="title">
		<xsl:element name="{$title-element}"><xsl:apply-templates/></xsl:element>
	</xsl:template>


	<xsl:template match="output[@type = ('xml', 'xhtml') or not(@type)]" priority="1">
		<pre class="{string-join((@type, @class), ' ')}">
			<code>
				<xsl:text>&#x0A;</xsl:text>
				<xsl:apply-templates select="node()" mode="verbatim"/>
			</code>
		</pre>
	</xsl:template>

	<xsl:template match="code[@type = ('xml', 'xhtml') or not(@type)]" priority="1">
		<pre class="{string-join((@class, (@type, 'xml')[1]), ' ')}">
			<code>
				<xsl:text>&#x0A;</xsl:text>
				<xsl:apply-templates select="node()" mode="verbatim"/>
			</code>
		</pre>
	</xsl:template>
	
	<xsl:template match="code[@type][not(@type = ('xhtml', 'xml'))]">
		<pre class="{string-join((@class, @type), ' ')}">
			<code><xsl:apply-templates/></code>
		</pre>
	</xsl:template>


	<!-- ignore notes elements in normal output -->
	<xsl:template match="notes" mode="#all"/>

	<!-- ignore *ANYTHING* with suppress set to true -->
	<xsl:template match="*[@suppress = 'always']" priority="100" mode="#all"/>


</xsl:stylesheet>
