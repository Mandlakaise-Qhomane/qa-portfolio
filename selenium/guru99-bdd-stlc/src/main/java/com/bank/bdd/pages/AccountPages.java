package com.bank.bdd.pages;

import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.NoAlertPresentException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.Select;

public class AccountPages {
    private final WebDriver driver;

    public AccountPages(WebDriver driver) {
        this.driver = driver;
    }

    public void openSavings(String customerId, String deposit) {
        driver.findElement(By.name("cusid")).sendKeys(customerId);
        new Select(driver.findElement(By.name("selaccount"))).selectByVisibleText("Savings");
        driver.findElement(By.name("inideposit")).sendKeys(deposit);
        driver.findElement(By.name("button2")).click();
    }

    public String accountId() {
        return driver.findElement(By.xpath("//td[text()='Account ID']/following-sibling::td")).getText();
    }

    public void deposit(String accountId, String amount, String desc) {
        driver.findElement(By.name("accountno")).sendKeys(accountId);
        driver.findElement(By.name("ammount")).sendKeys(amount);
        driver.findElement(By.name("desc")).sendKeys(desc);
        driver.findElement(By.name("AccSubmit")).click();
    }

    public void withdraw(String accountId, String amount, String desc) {
        driver.findElement(By.name("accountno")).sendKeys(accountId);
        driver.findElement(By.name("ammount")).sendKeys(amount);
        driver.findElement(By.name("desc")).sendKeys(desc);
        driver.findElement(By.name("AccSubmit")).click();
    }

    public boolean confirmationShown() {
        return driver.getPageSource().toLowerCase().contains("transaction details")
                || driver.getPageSource().toLowerCase().contains("successful");
    }

    public String acceptAlertIfPresent() {
        try {
            Alert alert = driver.switchTo().alert();
            String text = alert.getText();
            alert.accept();
            return text;
        } catch (NoAlertPresentException e) {
            return null;
        }
    }
}
