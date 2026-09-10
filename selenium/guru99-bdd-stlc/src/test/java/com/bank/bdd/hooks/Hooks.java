package com.bank.bdd.hooks;

import java.nio.file.Files;
import java.nio.file.Path;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import com.bank.bdd.base.Config;
import com.bank.bdd.base.DriverFactory;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

public class Hooks {
    @Before
    public void start() {
        DriverFactory.start();
        DriverFactory.get().get(Config.get("baseUrl"));
    }

    @After
    public void stop(Scenario scenario) {
        if (scenario.isFailed() && DriverFactory.get() != null) {
            try {
                byte[] shot = ((TakesScreenshot) DriverFactory.get()).getScreenshotAs(OutputType.BYTES);
                scenario.attach(shot, "image/png", scenario.getName());
                Path dir = Path.of("evidence", "screenshots");
                Files.createDirectories(dir);
                Files.write(dir.resolve(scenario.getName().replaceAll("\\W+", "_") + ".png"), shot);
            } catch (Exception ignored) {
                // evidence is best-effort
            }
        }
        DriverFactory.stop();
    }
}
