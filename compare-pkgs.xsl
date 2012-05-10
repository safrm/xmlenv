<?xml version="1.0" encoding="utf-8"?>
<!--
 - Author:    "Miroslav Safr" <miroslav.safr@gmail.com>
 - Version:   
 - ThanksTo:  Matusz for help with version XSLT transformation - Dezso Denes <denes.dezco@gmail.com>
 - Desc:      package versions comparation for xmlenv files 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exslt="http://exslt.org/common" version="1.0" exclude-result-prefixes="exslt">
 <xsl:output method="html"/>
 <xsl:param name="basefile" select="'base.xml'" />
 <xsl:param name="fullreport" select="'false'" />

  <!-- Replace // with / everywhere if we're only interested
   	in immediate children of /RootElement. -->

  <xsl:variable name="docA" select="/" />
  <xsl:variable name="docB" select="document($basefile)"/>

  <!-- This produces a whole nother copy of both docs!
       So, is the performance cost worth it?? -->

  <xsl:variable name="sortedNodesA">
    <!-- produce a sorted, flattened RTF of A's nodes -->
    <xsl:for-each select="$docA/system/packages/package">
      <xsl:sort select="name" />
      <xsl:copy-of select="." />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="sortedNodesB">
    <!-- produce a sorted, flattened RTF of B's nodes -->
    <xsl:for-each select="$docB/system/packages/package">
      <xsl:sort select="name" />
      <xsl:copy-of select="." />
    </xsl:for-each>
  </xsl:variable>


 <xsl:template match="/">
    <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">]]></xsl:text>
    <html>
        <head>
            <title>xmlenv comparation results </title>
            <style type="text/css">
                body { font-family: Calibri, Verdana, Arial, sans-serif; background-color: White; color: Black; }
                table.data  { border-top: 1px solid black; border-bottom: 1px solid black; border-collapse: collapse; }
                tr.head     { font-weight: bold; border-bottom: 1px solid black;}
                tr.sysinfo  { border-bottom: 1px solid black;}
                td.equal    { background-color:  #5BE16B; }
                td.higher   {  background-color: #D7FF95; }
                td.lower    {  background-color: #ff9593; }
                td.not-installed   { background-color: #990000; }
                td.extra-installed { background-color: #00BFFF; }
                td.not-recognized  { background-color: #D044A6; }
            </style>
        </head>
        <body>
            <table border="0" cellspacing="0" cellpadding="0" class="data" style="width: 800px">
    		    <tr class="head">
        	    	<td class="head">Package name   </td>
				    <td class="head">Current version</td>
				    <td class="head">X   </td>
				    <td class="head">Base version   </td>
        		</tr>
			    <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>xmlfile</xsl:text></td>
				    <td width="23%"></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$basefile"/></td>
			    </tr>
                            <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>comment</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@comment"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@comment"/></td>
			    </tr>
			    <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>package counts</xsl:text></td>
				    <td width="23%"><xsl:value-of select="count($docA/system/packages/package)"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="count($docB/system/packages/package)"/></td>
			    </tr>
			    <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>type</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@type"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@type"/></td>
			    </tr>
     		        <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>systemname</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@systemname"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@systemname"/></td>
			    </tr>
   		        <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>arch</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@arch"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@arch"/></td>
			    </tr>
   		        <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>hostname</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@hostname"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@hostname"/></td>
			    </tr>
                        <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>pkgmanager</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@pkgmanager"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@pkgmanager"/></td>
                 	</tr>

                        <tr class="sysinfo"> 
        			<td width="40%"><xsl:text>info</xsl:text></td>
				    <td width="23%"><xsl:value-of select="$docA/system/@info"/></td>
				    <td width="4%"></td>
				    <td width="23%"><xsl:value-of select="$docB/system/@info"/></td>
                 	</tr>

                <xsl:call-template name="recurse">
                  <xsl:with-param name="nodesA"
                    select="exslt:node-set($sortedNodesA)/*" />
                  <xsl:with-param name="nodesB"
                    select="exslt:node-set($sortedNodesB)/*" />
                </xsl:call-template>
    		</table>
        </body>
    </html>
  </xsl:template>
 
  <xsl:template name="recurse">
    <xsl:param name="nodesA" />
    <xsl:param name="nodesB" />
    <xsl:if test="$nodesA | $nodesB">
      <xsl:variable name="nameA" select="$nodesA[1]/@name" />
      <xsl:variable name="nameB" select="$nodesB[1]/@name" />
      <xsl:variable name="compar">
        <xsl:call-template name="compare-names">
          <xsl:with-param name="a" select="$nodesA[1]" />
          <xsl:with-param name="b" select="$nodesB[1]" />
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="0 > $compar"> <!-- $nodesA[1] is alph. first -->
            <xsl:if test="$fullreport = 'true'">
            <tr>
               <td><xsl:value-of select="$nameA" /></td>
               <td class="extra-installed"><xsl:value-of select="$nodesA/@version" /></td>
               <td class="extra-installed">+</td>
               <td class="extra-installed"><xsl:text>extra installed</xsl:text></td>
           </tr>
          </xsl:if>
          <xsl:call-template name="recurse">
            <xsl:with-param name="nodesA" select="$nodesA[position()>1]" />
            <xsl:with-param name="nodesB" select="$nodesB" />
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="$compar > 0"> <!-- $nodesB[1] is alph. first -->
            <tr>
               <td><xsl:value-of select="$nameB" /></td>
               <td class="not-installed"><xsl:text>not installed</xsl:text></td>
               <td class="not-installed">!</td>
               <td class="equal"><xsl:value-of select="$nodesB/@version" /> </td>
           </tr>
          <xsl:call-template name="recurse">
            <xsl:with-param name="nodesA" select="$nodesA" />
            <xsl:with-param name="nodesB" select="$nodesB[position()>1]" />
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          
        <!-- VERSION COMPARATION  [epoch:]upstream_version[-debian_revision]  - Do I need string(text(...))? -->
        <xsl:variable name="version1"> <xsl:value-of select="string($nodesA[1]/@version)"/> </xsl:variable>
        <xsl:variable name="version2"> <xsl:value-of select="string($nodesB[1]/@version)"/> </xsl:variable>
        
        <xsl:choose>
        <xsl:when test="$version1 = $version2">
            <xsl:if test="$fullreport = 'true'">
            <tr>
               <td><xsl:value-of select="$nameA" /></td>
               <td class="equal"><xsl:value-of select="$nodesA/@version" /></td>
               <td class="equal">=</td>
               <td class="equal"><xsl:value-of select="$nodesB/@version" /></td>
           </tr>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
           <xsl:variable name="version1-upstreamwithepoch">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space($version1), ':')"> <xsl:text>1</xsl:text> </xsl:when>
                    <xsl:otherwise> <xsl:text>0</xsl:text> </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="version2-upstreamwithepoch">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space($version2), ':')"> <xsl:text>1</xsl:text> </xsl:when>
                    <xsl:otherwise> <xsl:text>0</xsl:text> </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version1-cutout-revision">
                 <xsl:choose>
                    <xsl:when test="contains(normalize-space($version1), '-')"> <xsl:value-of select="substring-before($version1, '-')" /> </xsl:when>
                    <xsl:when test="contains(normalize-space($version1), '~')"> <xsl:value-of select="substring-before($version1, '~')" /> </xsl:when>
                    <xsl:otherwise> <xsl:value-of select="$version1"/>  </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="version2-cutout-revison">
                <xsl:choose>
                    <xsl:when test="contains(normalize-space($version2), '-')"> <xsl:value-of select="substring-before($version2, '-')" /> </xsl:when>
                    <xsl:when test="contains(normalize-space($version2), '~')"> <xsl:value-of select="substring-before($version2, '~')" /> </xsl:when>
                    <xsl:otherwise> <xsl:value-of select="$version2"/>  </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version1dots">
                <xsl:value-of select="translate($version1-cutout-revision, ':', '.')" />
            </xsl:variable>
            <xsl:variable name="version2dots">
                <xsl:value-of select="translate($version2-cutout-revison, ':', '.')" />
            </xsl:variable>

            <xsl:variable name="version1major">
                <xsl:choose>
                    <xsl:when test="string-length(substring-before($version1dots, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-before($version1dots, '.'))) = 'NaN'">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-before($version1dots, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version1tmp">
                <xsl:choose>
                    <xsl:when test="not(contains($version1major, '---'))">
                        <xsl:choose>                                                                                                                 
                            <xsl:when test="string-length(substring-before($version1dots, '.')) &lt; 1">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($version1dots, '.')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>---</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version1minor">
               <xsl:choose>
                    <xsl:when test="string-length(substring-before($version1tmp, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-before($version1tmp, '.'))) = 'NaN'">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-before($version1tmp, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version1release">
                <xsl:choose>
                    <xsl:when test="string-length(substring-after($version1tmp, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-after($version1tmp, '.'))) = 'NaN'">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-after($version1tmp, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version2major">
                <xsl:choose>
                    <xsl:when test="string-length(substring-before($version2dots, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>                                                                                                     
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-before($version2dots, '.'))) = 'NaN'">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-before($version2dots, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version2tmp">
                <xsl:choose>
                    <xsl:when test="not(contains($version2major, '---'))">
                        <xsl:choose>
                            <xsl:when test="string-length(substring-before($version2dots, '.')) &lt; 1">
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($version2dots, '.')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>---</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version2minor">
               <xsl:choose>
                    <xsl:when test="string-length(substring-before($version2tmp, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-before($version2tmp, '.'))) = 'NaN'">                                            
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-before($version2tmp, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="version2release">
                <xsl:choose>
                    <xsl:when test="string-length(substring-after($version2tmp, '.')) &lt; 1">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string(number(substring-after($version2tmp, '.'))) = 'NaN'">                                             
                                <xsl:text>---</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="string(number(substring-after($version2tmp, '.')))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

	            <xsl:variable name="compResult">
                <xsl:choose>
                    <xsl:when test="contains($version1, '---') or contains($version2, '---')">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($version1major, '---') or contains($version2major, '---')">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($version1minor, '---') or contains($version2minor, '---')">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($version1release, '---') or contains($version2release, '---')">
                        <xsl:text>---</xsl:text>
                    </xsl:when>
                    <xsl:when test="$version1-upstreamwithepoch = '1' and $version2-upstreamwithepoch = '0'">
                        <xsl:text>&gt;</xsl:text>
                    </xsl:when>
                    <xsl:when test="$version1-upstreamwithepoch = '0' and $version2-upstreamwithepoch = '1'">
                        <xsl:text>&lt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="normalize-space($version1major) != normalize-space($version2major)">
                                <xsl:choose>
                                    <xsl:when test="$version1major &lt; $version2major">
                                        <xsl:text>&lt;</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>&gt;</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$version1minor != $version2minor">
                                        <xsl:choose>
                                            <xsl:when test="$version1minor &lt; $version2minor">
                                                <xsl:text>&lt;</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>&gt;</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
				        <xsl:choose>
                                            <xsl:when test="$version1release != $version2release">
                                                <xsl:choose>
                                                    <xsl:when test="$version1release &lt; $version2release">
                                                       <xsl:text>&lt;</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="$version1release &gt; $version2release">
                                                       <xsl:text>&gt;</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>=</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="colorStyle">
                <xsl:choose>
                    <xsl:when test="contains($compResult, '&gt;')">
                        <xsl:text>higher</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($compResult, '&lt;')">
                        <xsl:text>lower</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($compResult, '=')">
                        <xsl:text>equal</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>not-recognized</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

           <tr>
               <td><xsl:value-of select="$nameB" /></td>
               <td class="{$colorStyle}"><xsl:value-of select="$version1" /> </td>
               <td class="{$colorStyle}"><xsl:value-of select="$compResult"/></td>
               <td class="{$colorStyle}"><xsl:value-of select="$version2" /> </td>
           </tr>
       </xsl:otherwise>
       </xsl:choose>
          <xsl:call-template name="recurse">
            <xsl:with-param name="nodesA" select="$nodesA[position()>1]" />
            <xsl:with-param name="nodesB" select="$nodesB[position()>1]" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="compare-names">
    <!-- Output -1, 0, or 1 as name of node A sorts before, equal to,
         or after name of node B. -->
    <xsl:param name="a" />
    <xsl:param name="b" />
    <xsl:choose>
      <xsl:when test="$a/@name = $b/@name"> 0 </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$a|$b">
          <xsl:sort select="name" />
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="name(.) = name($a)"> -1 </xsl:when>
              <xsl:otherwise> 1 </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
