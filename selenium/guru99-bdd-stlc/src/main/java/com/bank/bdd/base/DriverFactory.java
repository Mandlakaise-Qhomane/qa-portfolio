package com.bank.bdd.base;

import java.time.Duration;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public final class DriverFactory {
    private static final ThreadLocal<WebDriver> DL = new ThreadLocal<>();

    private DriverFactory() {}

    public static WebDriver start() {
        ChromeOptions options = new ChromeOptions();
        if (Config.getBool("headless")) {
            options.addArguments("--headless=new");
        }
        options.addArguments("--window-size=1440,900", "--no-sandbox", "--disable-dev-shm-usage");
        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(Config.getInt("implicitWait")));
        DL.set(driver);
        return driver;
    }

    public static WebDriver get() {
        return DL.get();
    }

    public static void stop() {
        WebDriver d = DL.get();
        if (d != null) {
            d.quit();
            DL.remove();
        }
    }
}
