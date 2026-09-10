package za.qhomane.appium.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class FieldPages {
    private final WebDriver driver;

    public FieldPages(WebDriver driver) {
        this.driver = driver;
    }

    private By t(String name) {
        return By.cssSelector("[data-test='" + name + "']");
    }

    public boolean shown(String testId) {
        return !driver.findElements(t(testId)).isEmpty();
    }

    public String text(String testId) {
        return driver.findElement(t(testId)).getText();
    }

    public void tap(String testId) {
        driver.findElement(t(testId)).click();
    }

    public void type(String testId, String value) {
        driver.findElement(t(testId)).clear();
        driver.findElement(t(testId)).sendKeys(value);
    }

    public void select(String testId, String value) {
        driver.findElement(t(testId)).sendKeys(value);
    }
}
