package za.qhomane.appium.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = "src/test/resources/features",
        glue = {"za.qhomane.appium.steps", "za.qhomane.appium.hooks"},
        plugin = {"pretty", "summary", "html:target/cucumber-report.html"},
        monochrome = true,
        tags = "not @wip"
)
public class CucumberTestRunner extends AbstractTestNGCucumberTests {
}
