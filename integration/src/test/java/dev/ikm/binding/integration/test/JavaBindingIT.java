package dev.ikm.binding.integration.test;

import dev.ikm.tinkar.forge.Forge;
import dev.ikm.tinkar.forge.TinkarForge;
import org.junit.jupiter.api.*;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.UUID;

import static dev.ikm.binding.integration.test.TestHelper.TEMPLATES_DIRECTORY;
import static dev.ikm.binding.integration.test.TestHelper.createFilePathInTarget;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class JavaBindingIT {

    private TestHelper testHelper;

    @BeforeAll
    public void beforeAll() {
        testHelper = new TestHelper();
    }

    @AfterAll
    public void afterAll() {
        testHelper.stop();
    }

    @Test
    public void givenStarterData_whenJavaBindingTemplateIsExecuted_thenJavaBindingFileIsGenerated() {
        long startTime = System.nanoTime();

        try (FileWriter fw = new FileWriter(createFilePathInTarget.apply("/test/ForgeTestTerm.java"))) {
            Forge simpleForge = new TinkarForge();
            simpleForge.config(TEMPLATES_DIRECTORY.toPath())
                    .conceptData(testHelper.getConcepts().stream(), testHelper.progressUpdate("concept"))
                    .patternData(testHelper.getPatterns().stream(), testHelper.progressUpdate("pattern"))
                    .variable("package", "dev.ikm.tinkar.forge.test")
                    .variable("author", "Forge Test Author")
                    .variable("className", "ForgeTestTerm")
                    .variable("namespace", UUID.randomUUID().toString())
                    .variable("defaultSTAMPCalc", testHelper.getSTAMP_CALCULATOR())
                    .variable("defaultLanguageCalc", testHelper.getLANGUAGE_CALCULATOR())
                    .template("java-binding-1.0.0-SNAPSHOT.ftl", new BufferedWriter(fw))
                    .execute();
        } catch (IOException e) {
            e.printStackTrace();
        }

        testHelper.logElapsedTime(startTime, System.nanoTime());
    }
}
