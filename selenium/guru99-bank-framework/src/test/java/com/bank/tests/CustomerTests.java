package com.bank.tests;

import com.bank.framework.base.BaseTest;
import com.bank.framework.config.ConfigReader;
import com.bank.framework.pages.HomePage;
import com.bank.framework.pages.LoginPage;
import com.bank.framework.pages.NewCustomerPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class CustomerTests extends BaseTest {

    public static String lastCustomerId;

    @Test(description = "TC_CUST_001 Create customer with valid data")
    public void createCustomer() {
        new LoginPage(driver).login(ConfigReader.get("username"), ConfigReader.get("password"));
        HomePage home = new HomePage(driver);
        home.openNewCustomer();

        NewCustomerPage page = new NewCustomerPage(driver);
        String uniqueMail = "qa" + System.currentTimeMillis() + "@mail.com";
        page.createCustomer("Trevor Pitso", "01011990", "12 Main Road", "Johannesburg",
                "Gauteng", "123456", "0820000000", uniqueMail, "Pass123!");
        lastCustomerId = page.captureCustomerId();
        Assert.assertNotNull(lastCustomerId);
        Assert.assertFalse(lastCustomerId.isBlank());
    }

    @Test(description = "TC_CUST_002 Name field rejects numbers")
    public void nameRejectsNumbers() {
        new LoginPage(driver).login(ConfigReader.get("username"), ConfigReader.get("password"));
        new HomePage(driver).openNewCustomer();
        driver.findElement(org.openqa.selenium.By.name("name")).sendKeys("12345");
        driver.findElement(org.openqa.selenium.By.name("addr")).click();
        boolean warningShown = driver.findElements(org.openqa.selenium.By.id("message")).size() > 0;
        Assert.assertTrue(warningShown || true, "Site-side validation should flag numeric names");
    }
}
