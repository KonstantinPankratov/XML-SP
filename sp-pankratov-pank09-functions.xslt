<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:wthr-fn="urn:pank09:weather-functions" exclude-result-prefixes="xs wthr-fn" version="2.0">

    <xsl:function name="wthr-fn:formatDate" as="xs:string">
        <xsl:param name="date" as="xs:date"/>
        <xsl:param name="showYear" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$showYear"><xsl:value-of select="format-date($date, '[MNn] [D], [Y]')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="format-date($date, '[MNn] [D]')"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>