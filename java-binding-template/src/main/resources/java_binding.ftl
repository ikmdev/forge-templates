<#-- Directive to replace special characters with uppercase word representations, surrounded by underscores. -->
<#macro replaceSpecialCharacters text>
    <#if text??>
        <#assign result = "">
        <#list text?replace(" (SOLOR)", "")?split("") as char>
            <#switch char>
                <#case "!"><#assign result = result + "_EXCLAMATION_"><#break>
                <#case "@"><#assign result = result + "_AT_"><#break>
                <#case "#"><#assign result = result + "_POUND_"><#break>
                <#case "$"><#assign result = result + "_DOLLAR_"><#break>
                <#case "%"><#assign result = result + "_PERCENT_"><#break>
                <#case "^"><#assign result = result + "_CARET_"><#break>
                <#case "&"><#assign result = result + "_AMPERSAND_"><#break>
                <#case "*"><#assign result = result + "_ASTERISK_"><#break>
                <#case "("><#assign result = result + "_OPENPARENTHESIS_"><#break>
                <#case ")"><#assign result = result + "_CLOSEPARENTHESIS_"><#break>
                <#case "-"><#assign result = result + "_DASH_"><#break>
                <#case "_"><#assign result = result + "_UNDERSCORE_"><#break>
                <#case "="><#assign result = result + "_EQUALS_"><#break>
                <#case "+"><#assign result = result + "_PLUS_"><#break>
                <#case "["><#assign result = result + "_OPENBRACKET_"><#break>
                <#case "]"><#assign result = result + "_CLOSEBRACKET_"><#break>
                <#case "{"><#assign result = result + "_OPENBRACE_"><#break>
                <#case "}"><#assign result = result + "_CLOSEBRACE_"><#break>
                <#case "\\"><#assign result = result + "_BACKSLASH_"><#break>
                <#case "|"><#assign result = result + "_PIPE_"><#break>
                <#case ";"><#assign result = result + "_SEMICOLON_"><#break>
                <#case ":"><#assign result = result + "_COLON_"><#break>
                <#case "'"><#assign result = result + "_SINGLEQUOTE_"><#break>
                <#case "\""><#assign result = result + "_DOUBLEQUOTE_"><#break>
                <#case ","><#assign result = result + "_COMMA_"><#break>
                <#case "."><#assign result = result + "_PERIOD_"><#break>
                <#case "/"><#assign result = result + "_FORWARDSLASH_"><#break>
                <#case "<"><#assign result = result + "_LESSTHAN_"><#break>
                <#case ">"><#assign result = result + "_GREATERTHAN_"><#break>
                <#case "?"><#assign result = result + "_QUESTIONMARK_"><#break>
                <#default><#assign result = result + char>
            </#switch>
        </#list>
        <#t>${result?replace(" ", "_")?upper_case?replace("__", "_")}
    <#else>
        <#t>${text?replace(" ", "_")?upper_case?replace("__", "_")}
    </#if>
</#macro>
<#macro formatPublicId publicId>
    <#assign result="">
    <#if publicId??>
        <#list publicId.asUuidArray() as uuid>
            <#assign result = result + "UUID.fromString(\"${uuid}\"), ">
        </#list>
    </#if>
    <#t>${result?remove_ending(", ")}
</#macro>
package ${package};

import java.util.UUID;
import dev.ikm.tinkar.common.id.PublicIds;
import dev.ikm.tinkar.terms.EntityProxy.Concept;
import dev.ikm.tinkar.terms.EntityProxy.Pattern;

/**
 * Tinkar Bindings class to enable programmatic access to tinkar data elements known to be stored in an unarbitrary database.
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
    public static final Pattern <@replaceSpecialCharacters text = patternText /> = Pattern.make("${patternText}", <@formatPublicId publicId = patternPublicId />;
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
    public static final Concept <@replaceSpecialCharacters text=conceptText /> = Concept.make("${conceptText}", <@formatPublicId publicId = conceptPublicId />);
    </#list>
}