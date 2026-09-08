package com.bank.tests;

import com.bank.framework.base.BaseTest;
import com.bank.framework.config.ConfigReader;
import com.bank.framework.pages.HomePage;
import com.bank.framework.pages.LoginPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTests extends BaseTest {

    @Test(description = "TC_LOGIN_001 Valid login redirects to Manager Home")
    public void validLogin() {
        LoginPage login = new LoginPage(driver);
        login.login(ConfigReader.get("username"), ConfigReader.get("password"));
        Assert.assertTrue(new HomePage(driver).isManagerHomeDisplayed(), "Manager home was not displayed");
    }

    @Test(description = "TC_LOGIN_002 Invalid credentials shows error")
    public void invalidLogin() {
        LoginPage login = new LoginPage(driver);
        login.login("badUser", "badPass");
        String alert = login.getAlertTextAndAccept();
        Assert.assertTrue(alert.toLowerCase().contains("user or password is not valid")
                || alert.toLowerCase().contains("not valid"), "Unexpected alert: " + alert);
    }

    @Test(description = "TC_LOGIN_003 Blank fields trigger validation")
    public void blankLogin() {
        LoginPage login = new LoginPage(driver);
        login.login("", "");
        String alert = login.getAlertTextAndAccept();
        Assert.assertFalse(alert.isBlank(), "Expected a validation alert");
    }
}
