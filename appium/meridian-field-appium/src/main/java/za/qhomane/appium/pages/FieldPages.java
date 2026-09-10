package za.qhomane.appium.pages;

import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import za.qhomane.appium.base.Config;

public class FieldPages {
    private final WebDriver driver;
    private final WebDriverWait wait;

    public FieldPages(WebDriver driver) {
        this.driver = driver;
        int seconds = 10;
        try {
            seconds = Config.getInt("explicitWait");
        } catch (Exception ignored) {
            // keep default
        }
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(seconds));
    }

    private By t(String name) {
        return By.cssSelector("[data-test='" + name + "']");
    }

    private WebElement visible(String testId) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(t(testId)));
    }

    public boolean shown(String testId) {
        try {
            visible(testId);
            return true;
        } catch (Exception e) {
            return !driver.findElements(t(testId)).isEmpty();
        }
    }

    public String text(String testId) {
        return visible(testId).getText();
    }

    public void tap(String testId) {
        wait.until(ExpectedConditions.elementToBeClickable(t(testId))).click();
    }

    public void type(String testId, String value) {
        WebElement el = visible(testId);
        el.clear();
        if (value != null && !value.isEmpty()) {
            el.sendKeys(value);
        }
    }

    public void select(String testId, String value) {
        new Select(visible(testId)).selectByVisibleText(value);
    }
}
