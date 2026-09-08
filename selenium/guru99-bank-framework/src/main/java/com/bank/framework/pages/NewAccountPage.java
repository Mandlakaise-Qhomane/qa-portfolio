package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.Select;

public class NewAccountPage {
    private final WebDriver driver;
    private final By customerId = By.name("cusid");
    private final By accountType = By.name("selaccount");
    private final By initialDeposit = By.name("inideposit");
    private final By submit = By.name("button2");
    private final By accountId = By.xpath("//td[text()='Account ID']/following-sibling::td");

    public NewAccountPage(WebDriver driver) {
        this.driver = driver;
    }

    public void openSavings(String custId, String deposit) {
        driver.findElement(customerId).sendKeys(custId);
        new Select(driver.findElement(accountType)).selectByVisibleText("Savings");
        driver.findElement(initialDeposit).sendKeys(deposit);
        driver.findElement(submit).click();
    }

    public String captureAccountId() {
        return driver.findElement(accountId).getText();
    }
}
