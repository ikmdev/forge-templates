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
    public static final Pattern ${patternText} = Pattern.make("${patternText}", ${formatPublicId(patternPublicId)});
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
    public static final Concept ${conceptText} = Concept.make("${conceptText}", ${formatPublicId(conceptPublicId)});
    </#list>
}