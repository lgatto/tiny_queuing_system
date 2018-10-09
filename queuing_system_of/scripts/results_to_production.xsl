<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" />
  <xsl:template match="/oligofaktory">
\&lt;DESCRIPTION\&gt;
\&lt;OLIGOORDER\&gt;
\&lt;KDNR\&gt; <xsl:value-of select="entry[@name='customerNumber']/@value"/>
\&lt;UNI\&gt; <xsl:value-of select="entry[@name='organisation']/@value"/>
\&lt;INSTITUT\&gt;
\&lt;AK\&gt;
\&lt;STREET\&gt; <xsl:value-of select="entry[@name='street']/@value"/>
\&lt;PLZ\&gt; <xsl:value-of select="entry[@name='zip']/@value"/>
\&lt;CITY\&gt; <xsl:value-of select="entry[@name='city']/@value"/>
\&lt;COUNTRY\&gt; <xsl:value-of select="entry[@name='country']/@value"/>
\&lt;NAME\&gt; <xsl:value-of select="entry[@name='name']/@value"/>
\&lt;PHONE\&gt; <xsl:value-of select="entry[@name='telephone']/@value"/>
\&lt;FAX\&gt;\&lt;EMAIL\&gt; <xsl:value-of select="entry[@name='email']/@value"/>
\&lt;ORDERNO\&gt; <xsl:value-of select="entry[@name='purchaseNumber']/@value"/>
\&lt;DATE\&gt; <xsl:value-of select="entry[@name='date']/@value"/>
\&lt;DELIVERY\&gt; Standard
\&lt;COMMENT\&gt;
<xsl:value-of select="entry[@name='billAdress']/@value"/>
Comment: <xsl:value-of select="entry[@name='comments']/@value"/>
    <!-{}- parse leaf nodes of the sequence hierarchy -{}->
    <xsl:apply-templates select="//oligo" />
\&lt;OLIGOORDEREND\&gt;
  </xsl:template>
  <xsl:template match="oligo">
\&lt;OLIGO\&gt; <xsl:value-of select="@name"/>
\&lt;SEQUENCE\&gt;<xsl:value-of select="dna"/>
\&lt;SCALE\&gt; <xsl:value-of select="//entry[@name='scale']/@value"/>
\&lt;DOC\&gt; Standard
\&lt;CLEAN\&gt; <xsl:value-of select="//entry[@name='purification']/@value"/>
\&lt;MODIFICATION\&gt; 
5'= <xsl:value-of select="//entry[@name='tailModification5']/@value"/>
\&lt;MODIFICATION\&gt; 
3'= <xsl:value-of select="//entry[@name='tailModification3']/@value"/>
\&lt;MODIFICATION\&gt; 
INT= <xsl:value-of select="//entry[@name='internalModification']/@value"/>
\&lt;MODIFICATION\&gt; 
<xsl:if test="//entry[@name='phosphorothioate']/@value = 'true'">PTO</xsl:if>
\&lt;COMMENT\&gt;
\&lt;OLIGOEND\&gt;
  </xsl:template>
</xsl:stylesheet>
