<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:wthr="urn:pank09:weather-forecast"
    xmlns:wthr-fn="urn:pank09:weather-functions"
    exclude-result-prefixes="xs wthr wthr-fn" version="2.0">

    <xsl:output method="xml"/>
    
    <xsl:include href="sp-pankratov-pank09-functions.xslt"/>

    <xsl:variable name="site-name">Weather Forecast</xsl:variable>
    
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="a4" page-height="297mm" page-width="210mm"
                    margin="15mm">
                    <fo:region-body margin-top="15mm" margin-bottom="15mm"/>
                    <fo:region-before extent="10mm"/>
                    <fo:region-after extent="10mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="a4">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block>
                        <xsl:value-of select="$site-name"/>
                    </fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block>
                        <fo:page-number/>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body" font-family="Calibri">
                    <xsl:apply-templates/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="wthr:weather">
        <fo:block page-break-after="always">
            <fo:block font-size="8mm" font-weight="600">
                Summary
            </fo:block>
            <xsl:for-each-group select="wthr:location" group-by="wthr:country">
                <xsl:sort select="wthr:country"/>
                <fo:block text-align-last="justify" margin-top="4mm" margin-bottom="2mm" font-weight="700">
                    <fo:basic-link internal-destination="{generate-id()}">
                        <fo:inline keep-together.within-line="always">
                            <xsl:value-of select="wthr:city"/>, <xsl:value-of select="wthr:country"/>
                        </fo:inline>
                        <fo:leader leader-pattern="dots"/>
                        <fo:page-number-citation ref-id="{generate-id()}"/>
                    </fo:basic-link>
                </fo:block>
                <xsl:for-each select="wthr:forecasts/wthr:forecast">
                    <fo:block text-align-last="justify" margin-left="4mm" margin-bottom="2mm">
                        <fo:basic-link internal-destination="{generate-id()}">
                            <xsl:value-of select="wthr-fn:formatDate(wthr:date, true())"/>
                            <fo:leader leader-pattern="dots"/>
                            <fo:page-number-citation ref-id="{generate-id()}"/>
                        </fo:basic-link>
                    </fo:block>
                </xsl:for-each>
            </xsl:for-each-group>
        </fo:block>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="wthr:location">
        <fo:block id="{generate-id()}" page-break-after="always">
            <fo:block font-size="8mm" margin-bottom="4mm">
                <xsl:value-of select="wthr:city"/>, <xsl:value-of select="wthr:country"/>
            </fo:block>
            <xsl:apply-templates select="wthr:forecasts/wthr:forecast"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="wthr:forecast">
        <fo:block id="{generate-id()}">
            <fo:block font-weight="600" margin-bottom="2mm" background-color="black" color="white" padding="2mm" text-align="center">
                <xsl:value-of select="wthr-fn:formatDate(wthr:date, false())"/>
            </fo:block>
            <xsl:apply-templates select="wthr:time"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="wthr:time">
        <xsl:param name="border-style">1pt solid black</xsl:param>
        <xsl:param name="time-type">
            <xsl:choose>
                <xsl:when test="position() = 1">day</xsl:when>
                <xsl:otherwise>night</xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        
        <fo:table border="{$border-style}" border-collapse="collapse" margin-bottom="4mm">
            <fo:table-header>
                <fo:table-row>
                    <fo:table-cell padding="2mm" text-transform="capitalize" display-align="center">
                        <fo:block font-weight="600">
                            <xsl:value-of select="$time-type"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" display-align="center">
                        <fo:block font-size="3mm" display-align="center">
                            <xsl:value-of select="wthr:condition"/>
                        </fo:block>
                        <fo:block>
                            <fo:external-graphic src="{wthr:icon}" width="10mm" height="10mm" content-height="scale-to-fit"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Clouds</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:clouds"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Precipitation</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:precipitation/wthr:quantity"/>mm (<xsl:value-of select="wthr:precipitation/wthr:probability * 100"/>%)</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Wind</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:wind/wthr:speed"/>m/s (<xsl:value-of select="wthr:wind/wthr:direction"/>)</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Pressure</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:pressure"/> mmHg</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Humidity</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:humidity"/>%</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Visibility</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:visibility div 1000"/> km</fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>UV index</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:uvIndex"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                        <fo:block>Air condition</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                        <fo:block><xsl:value-of select="wthr:airCondition"/></fo:block>
                    </fo:table-cell>
                </fo:table-row>
                
                <xsl:choose>
                    <xsl:when test="$time-type = 'day'">
                        <fo:table-row>
                            <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                                <fo:block>Sunrise</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                                <fo:block><xsl:value-of select="../wthr:sun/wthr:rise"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                                <fo:block>Sunset</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                                <fo:block><xsl:value-of select="../wthr:sun/wthr:set"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:table-row>
                            <fo:table-cell padding="1mm 2mm" border="{$border-style}">
                                <fo:block>Moon</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm 2mm" text-align="right" border="{$border-style}">
                                <fo:block><xsl:value-of select="../wthr:moon"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:table-body>
        </fo:table>
    </xsl:template>

</xsl:stylesheet>
