package com.bank.framework.utils;

import com.aventstack.extentreports.Status;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class TestListener implements ITestListener {

    
    public void onTestStart(ITestResult result) {
        ExtentManager.setTest(ExtentManager.getInstance().createTest(result.getMethod().getMethodName()));
    }

    
    public void onTestSuccess(ITestResult result) {
        ExtentManager.getTest().log(Status.PASS, "Passed");
    }


    public void onTestFailure(ITestResult result) {
        String shot = ScreenshotUtil.capture(result.getMethod().getMethodName());
        ExtentManager.getTest().log(Status.FAIL, result.getThrowable());
        try {
            ExtentManager.getTest().addScreenCaptureFromPath(shot);
        } catch (Exception ignored) {
            ExtentManager.getTest().log(Status.WARNING, "Screenshot attach failed: " + shot);
        }
    }

    
    public void onTestSkipped(ITestResult result) {
        ExtentManager.getTest().log(Status.SKIP, "Skipped");
    }
}
