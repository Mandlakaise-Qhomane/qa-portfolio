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
        driver.findElement(By.linkText(linkText)).click();
    }

    public void logout() {
        driver.findElement(logout).click();
    }
}
