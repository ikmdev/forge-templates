<#function replaceSpecialCharacters text>
    <#local result = "">
    <#if text??>
        <#local text = text?replace("(SOLOR)", "")?remove_ending(" ")>
        <#list text?split("") as char>
            <#switch char>
                <#case "!"><#local result = result + " Exclamation"><#break>
                <#case "@"><#local result = result + " At"><#break>
                <#case "#"><#local result = result + " Pound"><#break>
                <#case "$"><#local result = result + " Dollar"><#break>
                <#case "%"><#local result = result + " Percent"><#break>
                <#case "^"><#local result = result + " Caret"><#break>
                <#case "&"><#local result = result + " Aampersand"><#break>
                <#case "*"><#local result = result + " Asterisk"><#break>
                <#case "("><#local result = result + " OpenParenthesis"><#break>
                <#case ")"><#local result = result + " CloseParenthesis"><#break>
                <#case "-"><#local result = result + " Dash"><#break>
                <#case "_"><#local result = result + " Underscore"><#break>
                <#case "="><#local result = result + " Equals"><#break>
                <#case "+"><#local result = result + " Plus"><#break>
                <#case "["><#local result = result + " OpenBracket"><#break>
                <#case "]"><#local result = result + " CloseBracket"><#break>
                <#case "{"><#local result = result + " OpenBrace"><#break>
                <#case "}"><#local result = result + " CloseBrace"><#break>
                <#case "\\"><#local result = result + " Backslash"><#break>
                <#case "|"><#local result = result + " Pipe"><#break>
                <#case ";"><#local result = result + " Semicolon"><#break>
                <#case ":"><#local result = result + " Colon"><#break>
                <#case "'"><#local result = result + " SingleQuote"><#break>
                <#case "\""><#local result = result + " DoubleQuote"><#break>
                <#case ","><#local result = result + " Comma"><#break>
                <#case "."><#local result = result + " Period"><#break>
                <#case "/"><#local result = result + " ForwardSlash"><#break>
                <#case "<"><#local result = result + " LessThan"><#break>
                <#case ">"><#local result = result + " GreaterThan"><#break>
                <#case "?"><#local result = result + " QuestionMark"><#break>
                <#default><#local result = result + char>
            </#switch>
        </#list>
    <#else>
        <#local result = text>
    </#if>
    <#return result>
</#function>
<#function toCamelCase input>
    <#if input??>
		<#local cleanedInput = replaceSpecialCharacters(input)>
        <#local words = cleanedInput?lower_case?split(" ")>
        <#local result = words[0]>
        <#list words[1..] as word>
            <#local firstChar = word?substring(0, 1)?upper_case>
            <#local remainingWord = word?substring(1)>
            <#local result = result + firstChar + remainingWord>
        </#list>
        <#return result>
    <#else>
        <#return "">
    </#if>
</#function>
<#function toPascalCase input>
    <#if input??>
		<#local cleanedInput = replaceSpecialCharacters(input)>
        <#local words = cleanedInput?lower_case?split(" ")>
        <#local result = ""> <#-- Initialize as empty string -->
        <#list words as word>
			<#local firstChar = word?substring(0, 1)?upper_case>
			<#local restOfWord = word?substring(1)?lower_case>
			<#local result = result + firstChar + restOfWord>
        </#list>
        <#return result>
    <#else>
        <#return "">
    </#if>
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

import dev.ikm.tinkar.terms.EntityProxy.Pattern;

import java.util.UUID;

/**
 * A binding for Tinkar Patterns.
 */
public interface Binding {
	<#list patterns as pattern>
    <#assign patternName = textOf(pattern, defaultLanguageCalc)>
    <#assign latestVersion = latestVersionOf(pattern, defaultSTAMPCalc)>
        <#if latestVersion.isPresent()>
            <#assign patternVersion = latestVersion.get()>
            <#assign patternMeaning = patternVersion.semanticMeaning()>
			<#assign patternMeaningName = textOf(patternMeaning, defaultLanguageCalc)>

	interface ${toPascalCase(patternName)} {

		/**
		 * Get a lightweight representation of the ${patternName} pattern.
		 * <ul>
		 * <li> PublicId: ${pattern.publicId.idString()}
		 * </ul>
		 *
		 * @return EntityProxy Pattern
		 */
		static Pattern pattern() {
			return Pattern.make("${patternName}", ${formatPublicId(pattern.publicId)});
		}

		/**
		 * Get index for this pattern's PublicId value.
		 *
		 * @return EntityProxy Pattern
		 */
		static int publicIdFieldIndex() {
			return 0;
		}

		/**
		 * Get index for this pattern's version list.
		 *
		 * @return EntityProxy Pattern
		 */
		static int versionsFieldIndex() {
			return 1;
		}

		/**
		 * A version binding for the pattern ${patternName}
		 */
		interface Version {

            <#list patternVersion.fieldDefinitions() as fieldDefinition>
                <#assign fieldMeaning = entityGet(fieldDefinition.meaningNid)>
                <#assign fieldPurpose = entityGet(fieldDefinition.purposeNid)>
                <#assign fieldDataType = entityGet(fieldDefinition.dataTypeNid)>

			/**
			 * Get the index for the field definition ${textOf(fieldMeaning, defaultLanguageCalc)}.
			 * <ul>
			 * <li> Purpose: ${textOf(fieldPurpose, defaultLanguageCalc)}
			 * <li> Data Type: ${textOf(fieldDataType, defaultLanguageCalc)}
			 * <li> Index: ${fieldDefinition.indexInPattern}
			 * </ul>
			 *
			 * @return EntityProxy Pattern
			 */
			static int ${toCamelCase(textOf(fieldMeaning, defaultLanguageCalc))?replace("(solor)", "")}() {
				return ${fieldDefinition.indexInPattern};
			}
            </#list>
        </#if>
		}
	}
	</#list>
}