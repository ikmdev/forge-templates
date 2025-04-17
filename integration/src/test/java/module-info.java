module dev.ikm.binding.integration.test {
    requires dev.ikm.tinkar.forge;
    requires org.junit.jupiter.api;
    requires dev.ikm.tinkar.coordinate;
    requires dev.ikm.tinkar.entity;
    requires org.slf4j;
    requires dev.ikm.jpms.eclipse.collections;
    requires dev.ikm.jpms.eclipse.collections.api;

    uses dev.ikm.tinkar.forge.ForgeMethodWrapper;
    exports dev.ikm.binding.integration.test;
}