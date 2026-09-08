package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class FundTransferPage {
    private final WebDriver driver;
    private final By from = By.name("payersaccount");
    private final By to = By.name("payeeaccount");
    private final By amount = By.name("ammount");
    private final By desc = By.name("desc");
    private final By submit = By.name("AccSubmit");

    public FundTransferPage(WebDriver driver) {
        this.driver = driver;
    }

    public void transfer(String fromAcc, String toAcc, String amt, String description) {
        driver.findElement(from).sendKeys(fromAcc);
        driver.findElement(to).sendKeys(toAcc);
        driver.findElement(amount).sendKeys(amt);
        driver.findElement(desc).sendKeys(description);
        driver.findElement(submit).click();
    }
}
