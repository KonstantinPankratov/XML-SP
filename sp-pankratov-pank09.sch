<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:ns uri="urn:pank09:weather-forecast" prefix="wthr"/>
    
    <sch:pattern>
        <sch:title>Temperature check</sch:title>
        
        <sch:rule context="wthr:temp">
            <sch:assert test="number(wthr:min) &lt; number(wthr:max)">
                The minimum temperature (<sch:value-of select="wthr:min"/>) must not be higher than the maximum temperature (<sch:value-of select="wthr:max"/>).
                (Location: <sch:value-of select="../../../../@id"/> Date: <sch:value-of select="../../wthr:date"/> Time: <sch:value-of select="../wthr:from"/> - <sch:value-of select="../wthr:to"/>)
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Date and time consistency check</sch:title>
        
        <!--<sch:rule context="wthr:date">
            <sch:assert test="text() &gt; current-date()">
                The date must be a future date.
                (Location: <sch:value-of select="../../../@id"/> Date: <sch:value-of select="text()"/>)
            </sch:assert>
        </sch:rule>-->
        
        <sch:rule context="wthr:forecasts/wthr:forecast[position() > 1]">
            <sch:assert test="wthr:date &gt; preceding-sibling::wthr:forecast[1]/wthr:date">
                Each following date must be larger than the previous date.
                (Location: <sch:value-of select="../../@id"/> Date: <sch:value-of select="wthr:date"/>)
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="wthr:forecast/wthr:time[position() > 1]">
            <sch:assert test="wthr:from &gt; preceding-sibling::wthr:time[1]/wthr:from and wthr:from &gt;= preceding-sibling::wthr:time[1]/wthr:to">
                The start time (<sch:value-of select="wthr:from"/>) must be greater than or equal to the previous start (<sch:value-of select="preceding-sibling::wthr:time[1]/wthr:from"/>) and end (<sch:value-of select="preceding-sibling::wthr:time[1]/wthr:to"/>) time.
                (Location: <sch:value-of select="../../../@id"/> Date: <sch:value-of select="../wthr:date"/>)
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>