<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Author:    "Miroslav Safr" <miroslav.safr@gmail.com>
 - Version:   1.1.6 20140624_1104
 - Desc:      test list of extra installed packages
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
<xsl:param name="basefile" select="''" />
    <xsl:template match="/">
		<xsl:variable name="docA" select="/" />
		<xsl:variable name="docB" select="document($basefile)"/>
        <xsl:for-each select="$docA//system/packages/package">
                <xsl:variable name="currentname" select="@name" />
			    <xsl:choose>
		            <xsl:when test="$currentname = $docB/system/packages/package/@name">
		            </xsl:when>
				    <xsl:otherwise>
						<xsl:value-of select="$currentname"/>
						<xsl:text> </xsl:text>
				    </xsl:otherwise>
			   </xsl:choose>
        </xsl:for-each>
<xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
