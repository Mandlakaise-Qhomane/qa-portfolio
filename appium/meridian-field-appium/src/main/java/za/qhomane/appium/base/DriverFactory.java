package za.qhomane.appium.base;

import java.net.URI;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;

public final class DriverFactory {
    private static final ThreadLocal<WebDriver> DL = new ThreadLocal<>();

    private DriverFactory() {}

    public static WebDriver start() {
        String platform = Config.get("platform");
        WebDriver driver;
        if ("android".equalsIgnoreCase(platform)) {
            driver = androidDriver();
        } else {
            driver = localChrome();
        }
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
        DL.set(driver);
        return driver;
    }

    private static WebDriver localChrome() {
        ChromeOptions options = new ChromeOptions();
        Map<String, Object> mobile = new HashMap<>();
        mobile.put("deviceMetrics", Map.of("width", 412, "height", 915, "pixelRatio", 2.6));
        mobile.put("userAgent",
                "Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) "
                        + "Chrome/120.0.0.0 Mobile Safari/537.36");
        options.setExperimentalOption("mobileEmulation", mobile);
        if (Config.getBool("headless")) {
            options.addArguments("--headless=new");
        }
        options.addArguments(
                "--window-size=412,915",
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--disable-gpu",
                "--disable-notifications",
                "--remote-allow-origins=*");
        return new ChromeDriver(options);
    }

    private static WebDriver androidDriver() {
        UiAutomator2Options caps = new UiAutomator2Options()
                .setDeviceName(Config.get("deviceName"))
                .setAutomationName("UiAutomator2")
                .withBrowserName("Chrome")
                .amend("appium:newCommandTimeout", 120)
                .amend("appium:chromedriverAutodownload", true);
        String udid = Config.get("udid");
        if (udid != null && !udid.isBlank()) {
            caps.setUdid(udid);
        }
        try {
            return new AndroidDriver(URI.create(Config.get("appiumServer")).toURL(), caps);
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Could not start AndroidDriver. Start Appium on 4723 and an emulator first.", e);
        }
    }

    public static WebDriver get() {
        return DL.get();
    }

    public static RemoteWebDriver remote() {
        return (RemoteWebDriver) DL.get();
    }

    public static void stop() {
        WebDriver d = DL.get();
        if (d != null) {
            try {
                d.quit();
            } catch (Exception ignored) {
                // session already gone
            }
            DL.remove();
        }
    }
}
