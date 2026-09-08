package com.bank.tests;

import com.bank.framework.base.BaseTest;
import com.bank.framework.config.ConfigReader;
import com.bank.framework.pages.HomePage;
import com.bank.framework.pages.LoginPage;
import com.bank.framework.pages.NewAccountPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AccountTests extends BaseTest {

    public static String lastAccountId;

    @Test(description = "TC_ACCT_001 Open savings account", dependsOnMethods = {}, priority = 1)
    public void openSavingsAccount() {
        new LoginPage(driver).login(ConfigReader.get("username"), ConfigReader.get("password"));
        String customerId = CustomerTests.lastCustomerId;
        Assert.assertNotNull(customerId, "Run CustomerTests.createCustomer first or hard-code a known ID");

        new HomePage(driver).openNewAccount();
        NewAccountPage page = new NewAccountPage(driver);
        page.openSavings(customerId, "5000");
        lastAccountId = page.captureAccountId();
        Assert.assertFalse(lastAccountId.isBlank());
    }
}
