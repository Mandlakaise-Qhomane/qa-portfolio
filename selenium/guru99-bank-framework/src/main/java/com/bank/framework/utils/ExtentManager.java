package com.bank.framework.utils;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;

public final class ExtentManager {
    private static ExtentReports extent;
    private static final ThreadLocal<ExtentTest> TEST = new ThreadLocal<>();

    private ExtentManager() {}

    public static synchronized ExtentReports getInstance() {
        if (extent == null) {
            new FileGuard().mkdirs();
            ExtentSparkReporter spark = new ExtentSparkReporter("reports/extent-report.html");
            spark.config().setTheme(Theme.DARK);
            spark.config().setDocumentTitle("Guru99 Bank Automation");
            spark.config().setReportName("Selenium-Java Bank Framework");
            extent = new ExtentReports();
            extent.attachReporter(spark);
            extent.setSystemInfo("Site", "Guru99 Bank Demo V4");
            extent.setSystemInfo("Framework", "Selenium 4 + TestNG");
        }
        return extent;
    }

    public static void setTest(ExtentTest test) {
        TEST.set(test);
    }

    public static ExtentTest getTest() {
        return TEST.get();
    }

    public static void flush() {
        if (extent != null) {
            extent.flush();
        }
    }

    private static final class FileGuard {
        void mkdirs() {
            new java.io.File("reports").mkdirs();
        }
    }
}
