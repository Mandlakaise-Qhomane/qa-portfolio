package za.qhomane.appium.steps;

import org.testng.Assert;
import za.qhomane.appium.base.Config;
import za.qhomane.appium.base.DriverFactory;
import za.qhomane.appium.pages.FieldPages;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public class FieldSteps {
    private FieldPages ui() {
        return new FieldPages(DriverFactory.get());
    }

    @Given("the field app is launched")
    public void launched() {
        Assert.assertTrue(ui().shown("app-title"));
    }

    @Given("the agent is signed in")
    public void signedIn() {
        ui().type("agent-id", Config.get("agentId"));
        ui().type("password", Config.get("password"));
        ui().tap("login");
        Assert.assertTrue(ui().shown("home-title"));
    }

    @When("the agent signs in with valid credentials")
    public void validLogin() {
        signedIn();
    }

    @When("the agent signs in with agent {string} and password {string}")
    public void loginAs(String agent, String pass) {
        ui().type("agent-id", agent);
        ui().type("password", pass);
        ui().tap("login");
    }

    @Then("the home screen is shown")
    public void homeShown() {
        Assert.assertTrue(ui().shown("home-title"));
    }

    @Then("a login error is shown")
    public void loginError() {
        Assert.assertTrue(ui().text("login-error").toLowerCase().contains("invalid"));
    }

    @When("the agent logs out")
    public void logout() {
        ui().tap("logout");
    }

    @Then("the sign-in screen is shown")
    public void signInShown() {
        Assert.assertTrue(ui().shown("login") || ui().shown("app-title"));
    }

    @When("the agent opens the job list")
    public void openJobs() {
        ui().tap("nav-jobs");
    }

    @Then("three open jobs are listed")
    public void threeJobs() {
        Assert.assertTrue(ui().shown("job-1001"));
        Assert.assertTrue(ui().shown("job-1002"));
        Assert.assertTrue(ui().shown("job-1003"));
    }

    @When("the agent opens job {string}")
    public void openJob(String id) {
        if (!ui().shown("job-" + id)) {
            ui().tap("nav-jobs");
        }
        ui().tap("job-" + id);
    }

    @Then("job detail shows status {string}")
    public void status(String expected) {
        Assert.assertEquals(ui().text("job-status"), expected);
    }

    @When("the agent starts the job")
    public void startJob() {
        ui().tap("start-job");
    }

    @When("the agent completes the job")
    public void completeJob() {
        ui().tap("complete-job");
    }

    @When("the agent adds the note {string}")
    public void addNote(String note) {
        ui().tap("add-note");
        ui().type("note-text", note);
        ui().tap("save-note");
    }

    @Then("the job note is {string}")
    public void noteIs(String note) {
        Assert.assertEquals(ui().text("last-note"), note);
    }

    @When("the agent searches for {string}")
    public void search(String q) {
        ui().tap("nav-search");
        ui().type("search-box", q);
        ui().tap("search-go");
    }

    @Then("the search result contains {string}")
    public void searchHit(String expected) {
        Assert.assertTrue(ui().text("search-hit").contains(expected));
    }

    @When("the agent opens the priority queue")
    public void priority() {
        ui().tap("nav-priority");
    }

    @Then("only high-priority jobs are listed")
    public void onlyHigh() {
        Assert.assertTrue(ui().shown("prio-1001"));
        Assert.assertTrue(ui().text("priority-title").toLowerCase().contains("high"));
    }

    @When("the agent opens the offline queue")
    public void offline() {
        ui().tap("nav-offline");
    }

    @Then("the offline banner is shown")
    public void offlineBanner() {
        Assert.assertTrue(ui().text("offline-banner").toLowerCase().contains("offline"));
    }

    @When("the agent changes depot to {string}")
    public void changeDepot(String depot) {
        ui().tap("nav-settings");
        ui().select("depot-select", depot);
        ui().tap("save-depot");
    }

    @Then("the home depot chip is {string}")
    public void depotChip(String depot) {
        Assert.assertTrue(ui().text("depot-chip").contains(depot));
    }

    @When("the agent triggers an idle timeout")
    public void idle() {
        ui().tap("nav-timeout");
        ui().tap("idle-again");
    }

    @Then("the session-expired screen is shown")
    public void expired() {
        Assert.assertTrue(ui().shown("session-expired"));
    }
}
