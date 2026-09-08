package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class MiniStatementPage {
    private final WebDriver driver;
    private final By accountNo = By.name("accountno");
    private final By submit = By.name("AccSubmit");
    private final By table = By.xpath("//table");

    public MiniStatementPage(WebDriver driver) {
        this.driver = driver;
    }

    public void view(String acc) {
        driver.findElement(accountNo).sendKeys(acc);
        driver.findElement(submit).click();
    }

    public boolean hasTable() {
        return driver.findElements(table).size() > 0;
    }
}
