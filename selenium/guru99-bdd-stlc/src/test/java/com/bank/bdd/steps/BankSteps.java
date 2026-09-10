package com.bank.bdd.steps;

import java.time.Duration;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import com.bank.bdd.base.Config;
import com.bank.bdd.base.DriverFactory;
import com.bank.bdd.base.ScenarioContext;
import com.bank.bdd.pages.AccountPages;
import com.bank.bdd.pages.HomePage;
import com.bank.bdd.pages.LoginPage;
import com.bank.bdd.pages.NewCustomerPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public class BankSteps {
    private final ScenarioContext ctx = new ScenarioContext();

    private WebDriver driver() {
        return DriverFactory.get();
    }

    @Given("the manager is on the Guru99 Bank login page")
    public void openLogin() {
        Assert.assertTrue(new LoginPage(driver()).isDisplayed(), "Login page should be visible");
    }

    @Given("the manager logs in with valid credentials")
    public void validLogin() {
        new LoginPage(driver()).login(Config.get("username"), Config.get("password"));
        new LoginPage(driver()).acceptAlertIfPresent();
    }

    @When("the manager logs in with user {string} and password {string}")
    public void loginWith(String user, String pass) {
        new LoginPage(driver()).login(user, pass);
        ctx.setLastAlert(new LoginPage(driver()).acceptAlertIfPresent());
    }

    @Then("the manager home page is displayed")
    public void homeShown() {
        Assert.assertTrue(new HomePage(driver()).isDisplayed(), "Manager home was not displayed — refresh config.properties credentials");
    }

    @Then("an authentication alert is shown containing {string}")
    public void authAlert(String expected) {
        Assert.assertNotNull(ctx.getLastAlert(), "Expected an alert");
        Assert.assertTrue(ctx.getLastAlert().contains(expected), "Alert was: " + ctx.getLastAlert());
    }

    @When("the manager opens New Customer")
    public void openNewCustomer() {
        new HomePage(driver()).open("New Customer");
    }

    @When("the manager enters customer name {string}")
    public void typeName(String name) {
        new NewCustomerPage(driver()).typeName(name);
    }

    @Then("a field message containing {string} is shown")
    public void fieldMsg(String expected) {
        Assert.assertTrue(new NewCustomerPage(driver()).nameMessage().contains(expected));
    }

    @When("the manager submits a valid new customer form")
    public void submitCustomer() {
        String email = "qa" + System.currentTimeMillis() + "@mailinator.com";
        new NewCustomerPage(driver()).submitValid(email);
        String alert = new LoginPage(driver()).acceptAlertIfPresent();
        if (alert != null) {
            ctx.setLastAlert(alert);
        }
        String id = new NewCustomerPage(driver()).customerId();
        ctx.setCustomerId(id);
    }

    @Then("a customer identifier is issued")
    public void customerIssued() {
        Assert.assertNotNull(ctx.getCustomerId());
        Assert.assertFalse(ctx.getCustomerId().isBlank());
    }

    @When("the manager opens New Account")
    public void openNewAccount() {
        new HomePage(driver()).open("New Account");
    }

    @When("the manager opens a Savings account with deposit {string}")
    public void openSavings(String deposit) {
        new AccountPages(driver()).openSavings(ctx.getCustomerId(), deposit);
        ctx.setAccountId(new AccountPages(driver()).accountId());
    }

    @Then("an account identifier is issued")
    public void accountIssued() {
        Assert.assertNotNull(ctx.getAccountId());
        Assert.assertFalse(ctx.getAccountId().isBlank());
    }

    @When("the manager deposits {string} with description {string}")
    public void deposit(String amount, String desc) {
        new HomePage(driver()).open("Deposit");
        new AccountPages(driver()).deposit(ctx.getAccountId(), amount, desc);
    }

    @When("the manager withdraws {string} with description {string}")
    public void withdraw(String amount, String desc) {
        new HomePage(driver()).open("Withdrawal");
        new AccountPages(driver()).withdraw(ctx.getAccountId(), amount, desc);
        String alert = new AccountPages(driver()).acceptAlertIfPresent();
        if (alert != null) {
            ctx.setLastAlert(alert);
        }
    }

    @Then("a transaction confirmation is shown")
    public void txnOk() {
        Assert.assertTrue(new AccountPages(driver()).confirmationShown()
                || (ctx.getLastAlert() != null && ctx.getLastAlert().toLowerCase().contains("success")));
    }

    @Then("a transaction alert is shown")
    public void txnAlert() {
        Assert.assertTrue(ctx.getLastAlert() != null || driver().getPageSource().toLowerCase().contains("not enough"),
                "Expected a rejection for over-balance withdrawal");
    }

    @When("the manager logs out")
    public void logout() {
        new HomePage(driver()).logout();
        new LoginPage(driver()).acceptAlertIfPresent();
    }

    @Then("the login page is displayed after logout")
    public void backToLogin() {
        new WebDriverWait(driver(), Duration.ofSeconds(Config.getInt("explicitWait")))
                .until(ExpectedConditions.or(
                        ExpectedConditions.titleContains("Guru99 Bank"),
                        driver -> new LoginPage(driver()).isDisplayed()));
        Assert.assertTrue(new LoginPage(driver()).isDisplayed());
    }
}
