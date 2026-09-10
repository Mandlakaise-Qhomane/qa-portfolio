package com.bank.bdd.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class NewCustomerPage {
    private final WebDriver driver;
    private final By name = By.name("name");
    private final By nameMsg = By.id("message");
    private final By male = By.cssSelector("input[name='rad1'][value='m']");
    private final By dob = By.name("dob");
    private final By addr = By.name("addr");
    private final By city = By.name("city");
    private final By state = By.name("state");
    private final By pin = By.name("pinno");
    private final By phone = By.name("telephoneno");
    private final By email = By.name("emailid");
    private final By password = By.name("password");
    private final By submit = By.name("sub");
    private final By customerId = By.xpath("//td[text()='Customer ID']/following-sibling::td");

    public NewCustomerPage(WebDriver driver) {
        this.driver = driver;
    }

    public void typeName(String value) {
        driver.findElement(name).clear();
        driver.findElement(name).sendKeys(value);
        driver.findElement(addr).click();
    }

    public String nameMessage() {
        return driver.findElement(nameMsg).getText();
    }

    public void submitValid(String uniqueEmail) {
        driver.findElement(name).sendKeys("Rethabile Test");
        driver.findElement(male).click();
        driver.findElement(dob).sendKeys("01011990");
        driver.findElement(addr).sendKeys("12 Commissioner Street");
        driver.findElement(city).sendKeys("Johannesburg");
        driver.findElement(state).sendKeys("Gauteng");
        driver.findElement(pin).sendKeys("200001");
        driver.findElement(phone).sendKeys("0820000000");
        driver.findElement(email).sendKeys(uniqueEmail);
        driver.findElement(password).sendKeys("Pass1234");
        driver.findElement(submit).click();
    }

    public String customerId() {
        return driver.findElement(customerId).getText();
    }
}
