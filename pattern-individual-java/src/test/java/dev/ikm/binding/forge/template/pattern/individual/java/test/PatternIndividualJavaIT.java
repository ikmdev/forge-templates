package dev.ikm.binding.forge.template.pattern.individual.java.test;

import dev.ikm.binding.forge.template.pattern.nested.java.test.template.toolkit.TestUtility;
import dev.ikm.tinkar.forge.Forge;
import dev.ikm.tinkar.forge.TinkarForge;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import static dev.ikm.binding.forge.template.pattern.nested.java.test.template.toolkit.TestUtility.TEMPLATE_DIRECTORY;
import static dev.ikm.binding.forge.template.pattern.nested.java.test.template.toolkit.TestUtility.createFilePathInTarget;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class PatternIndividualJavaIT {

    private final TestUtility testUtility =  new TestUtility();

    @BeforeAll
    public void beforeAll() {
        testUtility.start();
    }

    @AfterAll
    public void afterAll() {
        testUtility.stop();
    }

    @Test
    public void givenStarterData_whenPatternJavaTemplateIsExecuted_thenPatternBindingFilesAreGenerated() {
        long startTime = System.nanoTime();

        testUtility.getPatterns().forEach(patternEntity -> {
            String patternName = testUtility.getLANGUAGE_CALCULATOR().getDescriptionTextOrNid(patternEntity.nid());
            String patternMeaning = getMeaningName(patternEntity.nid());
            String className = toPascalCase(replaceSOLORText(patternMeaning));
            try (FileWriter fw = new FileWriter(createFilePathInTarget.apply("/test/" + className + ".java"))) {
                Forge simpleForge = new TinkarForge();
                simpleForge.config(TEMPLATE_DIRECTORY.toPath())
                        .variable("pattern", patternEntity)
                        .variable("className", className)
                        .variable("package", "dev.ikm.binding.forge.pattern.test")
                        .variable("defaultSTAMPCalc", testUtility.getSTAMP_CALCULATOR())
                        .variable("defaultLanguageCalc", testUtility.getLANGUAGE_CALCULATOR())
                        .template("pattern-individual-java.ftl", new BufferedWriter(fw))
                        .execute();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        testUtility.logElapsedTime(startTime, System.nanoTime());
    }

    public String replaceSOLORText (String patternName) {
        return patternName.replaceAll("\\(.*\\)", "");
    }

    public  String toPascalCase(String sentence) {
        if (sentence == null || sentence.isEmpty()) {
            return sentence;
        }

        String[] words = sentence.toLowerCase().split("\\s+");
        StringBuilder pascalCase = new StringBuilder();

        for (String word : words) {
            if (!word.isEmpty()) {
                pascalCase.append(Character.toUpperCase(word.charAt(0)));
                pascalCase.append(word.substring(1));
            }
        }

        return pascalCase.toString();
    }

    private String getMeaningName(int nid) {

        var optionalVersion = testUtility.getSTAMP_CALCULATOR().latestPatternEntityVersion(nid);
        if (optionalVersion.isPresent()) {
            return testUtility.getLANGUAGE_CALCULATOR().getDescriptionTextOrNid(optionalVersion.get().semanticMeaningNid());
        }
        return "";
    }
}
