package com.bank.bdd.pages;

import java.time.Duration;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class LoginPage {
    private final WebDriver driver;
    private final By userId = By.name("uid");
    private final By password = By.name("password");
    private final By loginBtn = By.name("btnLogin");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String user, String pass) {
        driver.findElement(userId).clear();
        driver.findElement(userId).sendKeys(user == null ? "" : user);
        driver.findElement(password).clear();
        driver.findElement(password).sendKeys(pass == null ? "" : pass);
        driver.findElement(loginBtn).click();
    }

    public boolean isDisplayed() {
        return !driver.findElements(loginBtn).isEmpty();
    }

    public String acceptAlertIfPresent() {
        try {
            Alert alert = new WebDriverWait(driver, Duration.ofSeconds(3))
                    .until(ExpectedConditions.alertIsPresent());
            String text = alert.getText();
            alert.accept();
            return text;
        } catch (TimeoutException e) {
            return null;
        }
    }
}
