package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class WithdrawalPage {
    private final WebDriver driver;
    private final By accountNo = By.name("accountno");
    private final By amount = By.name("ammount");
    private final By desc = By.name("desc");
    private final By submit = By.name("AccSubmit");

    public WithdrawalPage(WebDriver driver) {
        this.driver = driver;
    }

    public void withdraw(String acc, String amt, String description) {
        driver.findElement(accountNo).sendKeys(acc);
        driver.findElement(amount).sendKeys(amt);
        driver.findElement(desc).sendKeys(description);
        driver.findElement(submit).click();
    }
}
