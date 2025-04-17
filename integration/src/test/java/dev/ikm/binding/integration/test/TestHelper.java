package dev.ikm.binding.integration.test;

import dev.ikm.tinkar.common.service.CachingService;
import dev.ikm.tinkar.common.service.PrimitiveData;
import dev.ikm.tinkar.coordinate.Coordinates;
import dev.ikm.tinkar.coordinate.language.calculator.LanguageCalculator;
import dev.ikm.tinkar.coordinate.language.calculator.LanguageCalculatorWithCache;
import dev.ikm.tinkar.coordinate.navigation.NavigationCoordinateRecord;
import dev.ikm.tinkar.coordinate.navigation.calculator.NavigationCalculator;
import dev.ikm.tinkar.coordinate.navigation.calculator.NavigationCalculatorWithCache;
import dev.ikm.tinkar.coordinate.stamp.StampCoordinateRecord;
import dev.ikm.tinkar.coordinate.stamp.calculator.StampCalculator;
import dev.ikm.tinkar.entity.*;
import dev.ikm.tinkar.entity.load.LoadEntitiesFromProtobufFile;
import org.eclipse.collections.impl.factory.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Consumer;
import java.util.function.Function;

public class TestHelper {

    private final Logger LOG = LoggerFactory.getLogger(TestHelper.class);

    public static final Function<String, File> createFilePathInTarget = (pathName) -> new File("%s/target/%s".formatted(System.getProperty("user.dir"), pathName));
    public static final File PB_STARTER_DATA = createFilePathInTarget.apply("data/tinkar-example-data-1.1.0+1.1.1-reasoned-pb.zip");
    public static final File TEMPLATES_DIRECTORY = createFilePathInTarget.apply("templates");

    private StampCalculator STAMP_CALCULATOR;
    private LanguageCalculator LANGUAGE_CALCULATOR;
    private NavigationCalculator NAVIGATION_CALCULATOR;

    private final List<ConceptEntity<? extends ConceptEntityVersion>> concepts = new ArrayList<>();
    private final List<SemanticEntity<? extends SemanticEntityVersion>> semantics = new ArrayList<>();
    private final List<PatternEntity<? extends PatternEntityVersion>> patterns = new ArrayList<>();
    private final List<StampEntity<? extends StampEntityVersion>> stamps = new ArrayList<>();

    private final AtomicInteger conceptCount = new AtomicInteger(0);
    private final AtomicInteger semanticCount = new AtomicInteger(0);
    private final AtomicInteger patternCount = new AtomicInteger(0);
    private final AtomicInteger stampCount = new AtomicInteger(0);

    public TestHelper() {
        try {
            Files.createDirectories(createFilePathInTarget.apply("/test").toPath());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        CachingService.clearAll();
        PrimitiveData.selectControllerByName("Load Ephemeral Store");
        PrimitiveData.start();
        LoadEntitiesFromProtobufFile loadEntitiesFromProtobufFile = new LoadEntitiesFromProtobufFile(PB_STARTER_DATA);
        loadEntitiesFromProtobufFile.compute();

        var languageList = Lists.mutable.of(Coordinates.Language.UsEnglishFullyQualifiedName()).toImmutableList();
        StampCoordinateRecord stampCoordinateRecord = Coordinates.Stamp.DevelopmentLatest();
        NavigationCoordinateRecord navigationCoordinateRecord = Coordinates.Navigation.stated().toNavigationCoordinateRecord();

        STAMP_CALCULATOR = stampCoordinateRecord.stampCalculator();
        LANGUAGE_CALCULATOR = LanguageCalculatorWithCache.getCalculator(stampCoordinateRecord, languageList);
        NAVIGATION_CALCULATOR = NavigationCalculatorWithCache.getCalculator(stampCoordinateRecord, languageList, navigationCoordinateRecord);

        PrimitiveData.get().forEachConceptNid(conceptNid -> {
            Entity<? extends EntityVersion> entity = Entity.getFast(conceptNid);
            concepts.add((ConceptEntity<? extends ConceptEntityVersion>) entity);
            conceptCount.incrementAndGet();
        });

        PrimitiveData.get().forEachSemanticNid(semanticNid -> {
            Entity<? extends EntityVersion> entity = Entity.getFast(semanticNid);
            semantics.add((SemanticEntity<? extends SemanticEntityVersion>) entity);
            semanticCount.incrementAndGet();
        });

        PrimitiveData.get().forEachPatternNid(patternNid -> {
            Entity<? extends EntityVersion> entity = Entity.getFast(patternNid);
            patterns.add((PatternEntity<? extends PatternEntityVersion>) entity);
            patternCount.incrementAndGet();
        });

        PrimitiveData.get().forEachStampNid(stampNid -> {
            Entity<? extends EntityVersion> entity = Entity.getFast(stampNid);
            stamps.add((StampEntity<? extends StampEntityVersion>) entity);
            stampCount.incrementAndGet();
        });
    }

    public Consumer<Integer> progressUpdate(String componentType) {
        return index -> {
            if (index % 100_000 == 0) {
                LOG.info("{}% {}s completed", ((double) index / semanticCount.get()) * 100, componentType);
            } else if (index == semanticCount.get()) {
                LOG.info("{}s completed", componentType);
            }
        };
    }

    public void logElapsedTime(long startTime, long endTime) {
        double elapsedTime = (double) (endTime - startTime) / 1000_000_000;
        LOG.info("Elapsed Time (s): {}", elapsedTime);
    }

    public void stop() {
        PrimitiveData.stop();
    }

    public StampCalculator getSTAMP_CALCULATOR() {
        return STAMP_CALCULATOR;
    }

    public LanguageCalculator getLANGUAGE_CALCULATOR() {
        return LANGUAGE_CALCULATOR;
    }

    public List<ConceptEntity<? extends ConceptEntityVersion>> getConcepts() {
        return concepts;
    }

    public List<SemanticEntity<? extends SemanticEntityVersion>> getSemantics() {
        return semantics;
    }

    public List<PatternEntity<? extends PatternEntityVersion>> getPatterns() {
        return patterns;
    }

    public List<StampEntity<? extends StampEntityVersion>> getStamps() {
        return stamps;
    }

    public NavigationCalculator getNAVIGATION_CALCULATOR() {
        return NAVIGATION_CALCULATOR;
    }
}
