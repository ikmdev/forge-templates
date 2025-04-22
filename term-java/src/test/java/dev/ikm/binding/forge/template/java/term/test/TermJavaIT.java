package dev.ikm.binding.forge.template.java.term.test;

import dev.ikm.binding.forge.template.toolkit.TestUtility;
import dev.ikm.tinkar.forge.Forge;
import dev.ikm.tinkar.forge.TinkarForge;
import org.junit.jupiter.api.*;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.UUID;

import static dev.ikm.binding.forge.template.toolkit.TestUtility.TEMPLATE_DIRECTORY;
import static dev.ikm.binding.forge.template.toolkit.TestUtility.createFilePathInTarget;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TermJavaIT {

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
    public void givenStarterData_whenJavaBindingTemplateIsExecuted_thenJavaBindingFileIsGenerated() {
        long startTime = System.nanoTime();

        try (FileWriter fw = new FileWriter(createFilePathInTarget.apply("/test/ForgeTestTerm.java"))) {
            Forge simpleForge = new TinkarForge();
            simpleForge.config(TEMPLATE_DIRECTORY.toPath())
                    .conceptData(testUtility.getConcepts().stream(), testUtility.progressUpdate("concept"))
                    .patternData(testUtility.getPatterns().stream(), testUtility.progressUpdate("pattern"))
                    .variable("package", "dev.ikm.tinkar.forge.test")
                    .variable("author", "Forge Test Author")
                    .variable("className", "ForgeTestTerm")
                    .variable("namespace", UUID.randomUUID().toString())
                    .variable("defaultSTAMPCalc", testUtility.getSTAMP_CALCULATOR())
                    .variable("defaultLanguageCalc", testUtility.getLANGUAGE_CALCULATOR())
                    .template("term-java.ftl", new BufferedWriter(fw))
                    .execute();
        } catch (IOException e) {
            e.printStackTrace();
        }

        testUtility.logElapsedTime(startTime, System.nanoTime());
    }
}
