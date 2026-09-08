package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class HomePage {
    private final WebDriver driver;
    private final By managerIdLabel = By.xpath("//td[contains(text(),'Manger Id') or contains(text(),'Manager Id')]");
    private final By logoutLink = By.linkText("Log out");
    private final By newCustomer = By.linkText("New Customer");
    private final By newAccount = By.linkText("New Account");
    private final By deposit = By.linkText("Deposit");
    private final By withdrawal = By.linkText("Withdrawal");
    private final By fundTransfer = By.linkText("Fund Transfer");
    private final By miniStatement = By.linkText("Mini Statement");

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public boolean isManagerHomeDisplayed() {
        return driver.getTitle().contains("Guru99 Bank Manager HomePage")
                || driver.findElements(managerIdLabel).size() > 0;
    }

    public void openNewCustomer() {
        driver.findElement(newCustomer).click();
    }

    public void openNewAccount() {
        driver.findElement(newAccount).click();
    }

    public void openDeposit() {
        driver.findElement(deposit).click();
    }

    public void openWithdrawal() {
        driver.findElement(withdrawal).click();
    }

    public void openFundTransfer() {
        driver.findElement(fundTransfer).click();
    }

    public void openMiniStatement() {
        driver.findElement(miniStatement).click();
    }

    public void logout() {
        driver.findElement(logoutLink).click();
    }
}
