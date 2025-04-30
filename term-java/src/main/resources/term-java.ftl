<#-- Directive to replace special characters with uppercase word representations, surrounded by underscores. -->
<#function replaceSpecialCharacters text>
    <#local result = "">
    <#if text??>
        <#local text = text?replace("(SOLOR)", "")?remove_ending(" ")>
        <#list text?split("") as char>
            <#switch char>
                <#case "!"><#local result = result + "_EXCLAMATION_"><#break>
                <#case "@"><#local result = result + "_AT_"><#break>
                <#case "#"><#local result = result + "_POUND_"><#break>
                <#case "$"><#local result = result + "_DOLLAR_"><#break>
                <#case "%"><#local result = result + "_PERCENT_"><#break>
                <#case "^"><#local result = result + "_CARET_"><#break>
                <#case "&"><#local result = result + "_AMPERSAND_"><#break>
                <#case "*"><#local result = result + "_ASTERISK_"><#break>
                <#case "("><#local result = result + "_OPENPARENTHESIS_"><#break>
                <#case ")"><#local result = result + "_CLOSEPARENTHESIS_"><#break>
                <#case "-"><#local result = result + "_DASH_"><#break>
                <#case "_"><#local result = result + "_UNDERSCORE_"><#break>
                <#case "="><#local result = result + "_EQUALS_"><#break>
                <#case "+"><#local result = result + "_PLUS_"><#break>
                <#case "["><#local result = result + "_OPENBRACKET_"><#break>
                <#case "]"><#local result = result + "_CLOSEBRACKET_"><#break>
                <#case "{"><#local result = result + "_OPENBRACE_"><#break>
                <#case "}"><#local result = result + "_CLOSEBRACE_"><#break>
                <#case "\\"><#local result = result + "_BACKSLASH_"><#break>
                <#case "|"><#local result = result + "_PIPE_"><#break>
                <#case ";"><#local result = result + "_SEMICOLON_"><#break>
                <#case ":"><#local result = result + "_COLON_"><#break>
                <#case "'"><#local result = result + "_SINGLEQUOTE_"><#break>
                <#case "\""><#local result = result + "_DOUBLEQUOTE_"><#break>
                <#case ","><#local result = result + "_COMMA_"><#break>
                <#case "."><#local result = result + "_PERIOD_"><#break>
                <#case "/"><#local result = result + "_FORWARDSLASH_"><#break>
                <#case "<"><#local result = result + "_LESSTHAN_"><#break>
                <#case ">"><#local result = result + "_GREATERTHAN_"><#break>
                <#case "?"><#local result = result + "_QUESTIONMARK_"><#break>
                <#default><#local result = result + char>
            </#switch>
        </#list>
    <#else>
        <#local result = text>
    </#if>
    <#return result?replace(" ", "_")?upper_case?replace("__", "_")>
</#function>
<#function formatPublicId publicId>
    <#local result = "">
    <#if publicId??>
        <#list publicId.asUuidArray() as uuid>
            <#local result = result + "UUID.fromString(\"${uuid}\"), ">
        </#list>
    </#if>
    <#return result?remove_ending(", ")>
</#function>
package ${package};

import dev.ikm.tinkar.common.id.PublicIds;
import dev.ikm.tinkar.terms.EntityProxy.Concept;
import dev.ikm.tinkar.terms.EntityProxy.Pattern;

import java.util.UUID;

/**
 * Tinkar Term Binding class to enable programmatic access to tinkar data elements known to be stored in an Komet database.
 * @author  ${author}
 */
public class ${className} {

    /**
     * Namespace used in the UUID creation process for tinkar components (e.g., Concept, Pattern, Semantic, and STAMP)
     */
    public static final UUID NAMESPACE = UUID.fromString("${namespace}");
    <#list patterns as pattern>

    <#assign patternText = textOf(pattern, defaultLanguageCalc)>
    <#assign patternPublicId = pattern.publicId>
    <#assign latestVersion = latestVersionOf(pattern, defaultSTAMPCalc)>
    /**
     * Java binding for the pattern described as ${patternText} and identified by the following as UUID(s):
     * <ul>
     <#list patternPublicId.asUuidList() as uuid>
     * <li>${uuid}
     </#list>
     * </ul>
     <#if latestVersion.isPresent() == true>
     <#assign latestPatternVersion = latestVersion.get()>
     <#assign fieldDefinitions = latestPatternVersion.fieldDefinitions()>
     <#if fieldDefinitions?size gt 0>
     * <p>
     * Pattern contains the following fields
     * <ul>
     <#list fieldDefinitions as fieldDefinition>
     <#assign dataType = entityGet(fieldDefinition.dataTypeNid)>
     <#assign meaning = entityGet(fieldDefinition.meaningNid)>
     * <li>Field ${fieldDefinition.indexInPattern} is a ${textOf(dataType, defaultLanguageCalc)} that represents ${textOf(meaning, defaultLanguageCalc)}.
     </#list>
     * </ul>
     </#if>
     </#if>
     */
    public static final Pattern ${replaceSpecialCharacters(patternText)} = Pattern.make("${patternText}", ${formatPublicId(patternPublicId)});
    </#list>
    <#list concepts as concept>

    <#assign conceptText = textOf(concept, defaultLanguageCalc)>
    <#assign conceptPublicId = concept.publicId>
    /**
     * Java binding for the concept described as ${conceptText} and identified by the following UUID(s):
     * <ul>
     <#list conceptPublicId.asUuidList() as uuid>
     * <li>${uuid}
     </#list>
     * </ul>
     */
    public static final Concept ${replaceSpecialCharacters(conceptText)} = Concept.make("${conceptText}", ${formatPublicId(conceptPublicId)});
    </#list>
}