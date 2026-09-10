package com.bank.bdd.runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
        features = "src/test/resources/features",
        glue = {"com.bank.bdd.steps", "com.bank.bdd.hooks"},
        plugin = {
                "pretty",
                "summary",
                "html:target/cucumber-report.html",
                "json:target/cucumber.json"
        },
        monochrome = true,
        tags = "not @wip"
)
public class CucumberTestRunner extends AbstractTestNGCucumberTests {
}
