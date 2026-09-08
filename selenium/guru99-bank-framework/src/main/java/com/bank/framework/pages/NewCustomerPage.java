package com.bank.framework.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class NewCustomerPage {
    private final WebDriver driver;

    private final By name = By.name("name");
    private final By genderMale = By.xpath("//input[@name='rad1' and @value='m']");
    private final By dob = By.name("dob");
    private final By address = By.name("addr");
    private final By city = By.name("city");
    private final By state = By.name("state");
    private final By pin = By.name("pinno");
    private final By mobile = By.name("telephoneno");
    private final By email = By.name("emailid");
    private final By password = By.name("password");
    private final By submit = By.name("sub");
    private final By customerId = By.xpath("//td[text()='Customer ID']/following-sibling::td");

    public NewCustomerPage(WebDriver driver) {
        this.driver = driver;
    }

    public void createCustomer(String custName, String dateOfBirth, String addr, String cityName,
                               String stateName, String pinCode, String phone, String mail, String pwd) {
        driver.findElement(name).sendKeys(custName);
        driver.findElement(genderMale).click();
        driver.findElement(dob).sendKeys(dateOfBirth);
        driver.findElement(address).sendKeys(addr);
        driver.findElement(city).sendKeys(cityName);
        driver.findElement(state).sendKeys(stateName);
        driver.findElement(pin).sendKeys(pinCode);
        driver.findElement(mobile).sendKeys(phone);
        driver.findElement(email).sendKeys(mail);
        driver.findElement(password).sendKeys(pwd);
        driver.findElement(submit).click();
    }

    public String captureCustomerId() {
        return driver.findElement(customerId).getText();
    }
}
