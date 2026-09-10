package com.bank.bdd.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class HomePage {
    private final WebDriver driver;
    private final By managerId = By.xpath("//td[contains(text(),'Manger Id') or contains(text(),'Manager Id')]");
    private final By logout = By.linkText("Log out");

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public boolean isDisplayed() {
        return driver.getTitle().contains("Manager HomePage")
                || !driver.findElements(managerId).isEmpty();
    }

    public void open(String linkText) {
        if (driver.findElements(By.linkText(linkText)).isEmpty()) {
            if (!driver.findElements(By.linkText("Home")).isEmpty()) {
                driver.findElement(By.linkText("Home")).click();
            } else {
                driver.get(driver.getCurrentUrl().replaceAll("(?<!/)/(?!/).*$", "/") + "home");
            }
        }
        driver.findElement(By.linkText(linkText)).click();
    }

    public void logout() {
        if (driver.findElements(logout).isEmpty() && !driver.findElements(By.linkText("Home")).isEmpty()) {
            driver.findElement(By.linkText("Home")).click();
        }
        driver.findElement(logout).click();
    }
}
