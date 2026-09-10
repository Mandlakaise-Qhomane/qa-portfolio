package za.qhomane.appium.hooks;

import java.nio.file.Files;
import java.nio.file.Path;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import za.qhomane.appium.base.Config;
import za.qhomane.appium.base.DriverFactory;
import za.qhomane.appium.base.LocalFieldApp;
import io.cucumber.java.After;
import io.cucumber.java.AfterAll;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;

public class Hooks {
    @BeforeAll
    public static void startApp() throws Exception {
        LocalFieldApp.start();
    }

    @AfterAll
    public static void stopApp() {
        LocalFieldApp.stop();
    }

    @Before
    public void open() {
        LocalFieldApp.reset();
        DriverFactory.start();
        DriverFactory.get().get(Config.get("baseUrl"));
    }

    @After
    public void close(Scenario scenario) {
        if (scenario.isFailed() && DriverFactory.get() instanceof TakesScreenshot shot) {
            try {
                byte[] png = shot.getScreenshotAs(OutputType.BYTES);
                scenario.attach(png, "image/png", scenario.getName());
                Path dir = Path.of("evidence", "screenshots");
                Files.createDirectories(dir);
                Files.write(dir.resolve(scenario.getName().replaceAll("\\W+", "_") + ".png"), png);
            } catch (Exception ignored) {
                // best-effort evidence
            }
        }
        DriverFactory.stop();
    }
}
