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
        
        <sch:rule context="wthr:date">
            <sch:assert test="text() &gt; current-date()">
                The date must be a future date.
                (Location: <sch:value-of select="../../../@id"/> Date: <sch:value-of select="text()"/>)
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="wthr:forecasts/wthr:forecast[position() > 1]">
            <sch:let name="currentDate" value="xs:date(wthr:date)"/>
            <sch:let name="previousDate" value="xs:date(preceding-sibling::wthr:forecast[1]/wthr:date)"/>
            <sch:let name="expectedDate" value="$previousDate + xs:dayTimeDuration('P1D')"/>
            <sch:assert test="not(exists($previousDate)) or $currentDate = $expectedDate" >
                Each date must be one day ahead than the previous date.
                (Location: <sch:value-of select="../../@id"/> Date: <sch:value-of select="wthr:date"/>)
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="wthr:forecast/wthr:time[position() > 1]">
            <sch:let name="currentFrom" value="xs:time(wthr:from)"/>
            <sch:let name="currentTo" value="xs:time(wthr:to)"/>
            <sch:let name="previousFrom" value="xs:time(preceding-sibling::wthr:time[1]/wthr:from)"/>
            <sch:let name="previousTo" value="xs:time(preceding-sibling::wthr:time[1]/wthr:to)"/>
            <sch:assert test="
                not(exists($previousFrom)) or not(exists($previousTo)) or
                $currentFrom = $previousTo">
                The start time (<sch:value-of select="$currentFrom"/>) must equal to the previous end time (<sch:value-of select="$previousTo"/>).
                (Location: <sch:value-of select="../../../@id"/> Date: <sch:value-of select="../wthr:date"/>)
            </sch:assert>
            
            <sch:assert test="not(exists($previousFrom)) or not(exists($previousTo)) or 
                $previousFrom &lt; $currentFrom">
                The start time (<sch:value-of select="$currentFrom"/>) must be greater than the previous start time (<sch:value-of select="$previousFrom"/>).
                (Location: <sch:value-of select="../../../@id"/> Date: <sch:value-of select="../wthr:date"/>)
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>