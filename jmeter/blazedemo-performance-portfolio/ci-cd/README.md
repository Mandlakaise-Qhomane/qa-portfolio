# CI/CD — Running These Tests Automatically

This folder explains how the performance tests in this project can be set up to run automatically, instead of only running them by hand on your own computer.

## What "CI/CD" Means Here (Simple Version)
Instead of opening JMeter yourself every time you want to run a test, you can set up a robot (GitHub Actions) that runs the tests for you automatically — for example, every time you update the project, or once a day on a schedule.

## Where the Automation File Lives
GitHub requires automation files to sit in a specific folder for them to actually run: `.github/workflows/`. So the real automation file is here:

```
.github/workflows/performance-tests.yaml
```

This file tells GitHub to:
1. Set up a computer with JMeter installed.
2. Run the test suite (`test-plans/BlazeDemo_Suite.jmx`).
3. Save the results as downloadable files, in a separate folder called `ci-report_output` — kept apart from the report you generate by hand, so the automated run never overwrites it.

## Why This Matters for a Portfolio
Being able to show that your tests can run automatically — not just manually — is something recruiters and hiring managers look for. It shows you understand how testing fits into a real software team's day-to-day workflow, not just how to click through JMeter.

## How to Run It Yourself Later
Once `.github/workflows/performance-tests.yaml` is in your GitHub repo, GitHub will run it automatically based on the triggers set inside that file (for example: every time code is pushed, or on a set schedule).
