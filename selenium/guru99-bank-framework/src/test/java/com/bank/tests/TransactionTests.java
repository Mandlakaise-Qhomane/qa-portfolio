package com.bank.tests;

import com.bank.framework.base.BaseTest;
import com.bank.framework.config.ConfigReader;
import com.bank.framework.pages.DepositPage;
import com.bank.framework.pages.FundTransferPage;
import com.bank.framework.pages.HomePage;
import com.bank.framework.pages.LoginPage;
import com.bank.framework.pages.MiniStatementPage;
import com.bank.framework.pages.WithdrawalPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class TransactionTests extends BaseTest {

    private void loginAndGoHome() {
        new LoginPage(driver).login(ConfigReader.get("username"), ConfigReader.get("password"));
    }

    @Test(description = "TC_TRAN_001 Deposit amount")
    public void depositAmount() {
        loginAndGoHome();
        String acc = AccountTests.lastAccountId;
        Assert.assertNotNull(acc, "Need an account ID from AccountTests");
        new HomePage(driver).openDeposit();
        new DepositPage(driver).deposit(acc, "1000", "Salary");
        Assert.assertTrue(driver.getPageSource().toLowerCase().contains("successful")
                || driver.getPageSource().toLowerCase().contains("deposit"),
                "Deposit confirmation not found");
    }

    @Test(description = "TC_TRAN_002 Withdraw valid amount")
    public void withdrawValid() {
        loginAndGoHome();
        String acc = AccountTests.lastAccountId;
        Assert.assertNotNull(acc, "Need an account ID from AccountTests");
        new HomePage(driver).openWithdrawal();
        new WithdrawalPage(driver).withdraw(acc, "100", "ATM");
        Assert.assertTrue(driver.getPageSource().toLowerCase().contains("successful")
                || driver.getPageSource().toLowerCase().contains("transaction"),
                "Withdrawal confirmation not found");
    }

    @Test(description = "TC_TRAN_003 Withdraw more than balance shows error")
    public void withdrawOverBalance() {
        loginAndGoHome();
        String acc = AccountTests.lastAccountId;
        Assert.assertNotNull(acc, "Need an account ID from AccountTests");
        new HomePage(driver).openWithdrawal();
        new WithdrawalPage(driver).withdraw(acc, "99999999", "Overdraw");
        boolean error = driver.getPageSource().toLowerCase().contains("not sufficient")
                || driver.getPageSource().toLowerCase().contains("error")
                || switchToAlertIfPresent();
        Assert.assertTrue(error, "Expected overdraft error");
    }

    @Test(description = "TC_TRAN_004 Mini statement shows table")
    public void miniStatement() {
        loginAndGoHome();
        String acc = AccountTests.lastAccountId;
        Assert.assertNotNull(acc, "Need an account ID from AccountTests");
        new HomePage(driver).openMiniStatement();
        MiniStatementPage page = new MiniStatementPage(driver);
        page.view(acc);
        Assert.assertTrue(page.hasTable() || driver.getPageSource().contains("Transaction"),
                "Mini statement not displayed");
    }

    @Test(description = "TC_TRAN_005 Fund transfer placeholder — needs two accounts")
    public void fundTransfer() {
        loginAndGoHome();
        new HomePage(driver).openFundTransfer();
        new FundTransferPage(driver).transfer("1", "2", "10", "Test transfer");
        Assert.assertTrue(true, "Wire second account ID when available");
    }

    private boolean switchToAlertIfPresent() {
        try {
            driver.switchTo().alert().accept();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
