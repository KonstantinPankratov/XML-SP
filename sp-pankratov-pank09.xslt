<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wthr="urn:pank09:weather-forecast"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="html" version="5"/>
    
    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>Weather Forecast</title>
                <link rel="stylesheet" href="sp-pankratov-pank09.css" type="text/css"/>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="wthr:weather">
        <h1>Weather forecast</h1>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="wthr:location">
        <section class="location">
            <div class="header">
                <h2><xsl:value-of select="wthr:city"/>, <xsl:value-of select="wthr:country"/></h2>
                <xsl:apply-templates select="wthr:coordinates"/>
            </div>
            <div class="body">
                <div class="forecasts">
                    <xsl:apply-templates select="wthr:forecasts/wthr:forecast"/>
                </div>
            </div>
        </section>
    </xsl:template>
    
    <xsl:template match="wthr:coordinates">
        <span class="badge">
            <xsl:value-of select="wthr:lat"/>, <xsl:value-of select="wthr:lon"/>
        </span>
    </xsl:template>
    
    <xsl:template match="wthr:forecast">
        <div class="forecast">
            <span class="date">
                <xsl:value-of select="format-date(wthr:date,'[MNn] [D]')"/>
            </span>
            <div class="time-wrapper">
                <xsl:apply-templates select="wthr:time"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="wthr:time">
        <div class="time">
            <xsl:call-template name="image"/>
            <xsl:apply-templates select="wthr:condition"/>
            <xsl:apply-templates select="wthr:temp"/>
            <xsl:call-template name="forecast-details"/>
        </div>
    </xsl:template>
    
    <xsl:template match="wthr:condition">
        <span class="condition">
            <xsl:value-of select="wthr:condition"/>
        </span>
    </xsl:template>
    
    <xsl:template match="wthr:temp">
        <div class="temp">
            <span class="min">
                <xsl:value-of select="wthr:min"/>° /
            </span>
            <span class="max">
                <xsl:value-of select="wthr:max"/>°
            </span>
        </div>
    </xsl:template>
    
    <xsl:template name="image">
        <img width="80" height="80">
            <xsl:attribute name="src">
                <xsl:value-of select="wthr:icon"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="wthr:condition"/>
            </xsl:attribute>
        </img>
    </xsl:template>
    
    <xsl:template name="forecast-details">
        <ul>
            <li>Clouds: <span><xsl:value-of select="wthr:clouds"/>%</span></li>
            <li>Precipitation: <span><xsl:value-of select="wthr:precipitation/wthr:quantity"/>mm (<xsl:value-of select="wthr:precipitation/wthr:probability * 100"/>%)</span></li>
            <li>Wind: <span><xsl:value-of select="wthr:wind/wthr:speed"/>m/s (<xsl:value-of select="wthr:wind/wthr:direction"/>)</span></li>
            <li>Pressure: <span><xsl:value-of select="wthr:pressure"/> mmHg</span></li>
            <li>Humidity: <span><xsl:value-of select="wthr:humidity"/>%</span></li>
            <li>Visibility: <span><xsl:value-of select="wthr:visibility div 1000"/> km</span></li>
            <li>UV index: <span><xsl:value-of select="wthr:uvIndex"/></span></li>
            <li>Air condition: <span><xsl:value-of select="wthr:airCondition"/></span></li>
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <li>Sunrise: <span><xsl:value-of select="../wthr:sun/wthr:rise"/></span></li>
                    <li>Sunset: <span><xsl:value-of select="../wthr:sun/wthr:set"/></span></li>
                </xsl:when>
                <xsl:otherwise>
                    <li>Moon: <span><xsl:value-of select="../wthr:moon"/></span></li>
                </xsl:otherwise>
            </xsl:choose>
        </ul>
    </xsl:template>
    
</xsl:stylesheet>