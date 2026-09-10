package za.qhomane.appium.base;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

/** Bundled mobile field-service app. Same screens the 15 cases drive. */
public final class LocalFieldApp {
    public static final int PORT = 18081;
    private static HttpServer server;
    private static String depot = "JHB-North";
    private static boolean jobStarted;
    private static boolean jobDone;
    private static String lastNote = "";
    private static int idleTicks;

    private LocalFieldApp() {}

    public static synchronized void start() throws IOException {
        if (server != null) {
            return;
        }
        reset();
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", PORT), 0);
        server.createContext("/", LocalFieldApp::login);
        server.createContext("/login", LocalFieldApp::doLogin);
        server.createContext("/home", LocalFieldApp::home);
        server.createContext("/jobs", LocalFieldApp::jobs);
        server.createContext("/job", LocalFieldApp::job);
        server.createContext("/start", LocalFieldApp::startJob);
        server.createContext("/complete", LocalFieldApp::completeJob);
        server.createContext("/note", LocalFieldApp::note);
        server.createContext("/saveNote", LocalFieldApp::saveNote);
        server.createContext("/search", LocalFieldApp::search);
        server.createContext("/priority", LocalFieldApp::priority);
        server.createContext("/offline", LocalFieldApp::offline);
        server.createContext("/settings", LocalFieldApp::settings);
        server.createContext("/saveDepot", LocalFieldApp::saveDepot);
        server.createContext("/timeout", LocalFieldApp::timeout);
        server.createContext("/logout", LocalFieldApp::logout);
        server.setExecutor(null);
        server.start();
    }

    public static synchronized void stop() {
        if (server != null) {
            server.stop(0);
            server = null;
        }
    }

    public static void reset() {
        depot = "JHB-North";
        jobStarted = false;
        jobDone = false;
        lastNote = "";
        idleTicks = 0;
    }

    public static String url() {
        return "http://127.0.0.1:" + PORT + "/";
    }

    private static void login(HttpExchange ex) throws IOException {
        html(ex, page("Meridian Field", """
                <h1 data-test="app-title">Meridian Field</h1>
                <p data-test="splash">Field service</p>
                <form action="/login" method="post">
                <input data-test="agent-id" name="agent" placeholder="Agent ID"/>
                <input data-test="password" name="password" type="password"/>
                <button data-test="login" name="login">Sign in</button>
                </form>
                """));
    }

    private static void doLogin(HttpExchange ex) throws IOException {
        Map<String, String> f = form(ex);
        if ("agent.jhb".equals(f.get("agent")) && "Field@123".equals(f.get("password"))) {
            redirect(ex, "/home");
            return;
        }
        html(ex, page("Meridian Field", """
                <p data-test="login-error">Invalid agent or password</p>
                <a data-test="back-login" href="/">Back</a>
                """));
    }

    private static void home(HttpExchange ex) throws IOException {
        html(ex, page("Home", """
                <h1 data-test="home-title">Home</h1>
                <p data-test="depot-chip">Depot %s</p>
                <a data-test="nav-jobs" href="/jobs">Jobs</a>
                <a data-test="nav-search" href="/search">Search</a>
                <a data-test="nav-priority" href="/priority">Priority</a>
                <a data-test="nav-offline" href="/offline">Offline</a>
                <a data-test="nav-settings" href="/settings">Settings</a>
                <a data-test="nav-timeout" href="/timeout">Idle check</a>
                <a data-test="logout" href="/logout">Log out</a>
                """.formatted(depot)));
    }

    private static void jobs(HttpExchange ex) throws IOException {
        html(ex, page("Jobs", """
                <h1 data-test="jobs-title">Open jobs</h1>
                <ul data-test="job-list">
                <li><a data-test="job-1001" href="/job?id=1001">1001 Meter swap — HIGH</a></li>
                <li><a data-test="job-1002" href="/job?id=1002">1002 Inspection — MED</a></li>
                <li><a data-test="job-1003" href="/job?id=1003">1003 Disconnect — LOW</a></li>
                </ul>
                <a href="/home">Home</a>
                """));
    }

    private static void job(HttpExchange ex) throws IOException {
        String status = jobDone ? "COMPLETED" : jobStarted ? "IN_PROGRESS" : "ASSIGNED";
        html(ex, page("Job", """
                <h1 data-test="job-id">Job 1001</h1>
                <p data-test="job-status">%s</p>
                <p data-test="job-priority">HIGH</p>
                <p data-test="last-note">%s</p>
                <a data-test="start-job" href="/start">Start job</a>
                <a data-test="complete-job" href="/complete">Complete job</a>
                <a data-test="add-note" href="/note">Add note</a>
                <a href="/jobs">Jobs</a>
                """.formatted(status, lastNote.isBlank() ? "No note" : lastNote)));
    }

    private static void startJob(HttpExchange ex) throws IOException {
        jobStarted = true;
        redirect(ex, "/job?id=1001");
    }

    private static void completeJob(HttpExchange ex) throws IOException {
        if (jobStarted) {
            jobDone = true;
        }
        redirect(ex, "/job?id=1001");
    }

    private static void note(HttpExchange ex) throws IOException {
        html(ex, page("Note", """
                <form action="/saveNote" method="post">
                <textarea data-test="note-text" name="note"></textarea>
                <button data-test="save-note">Save note</button>
                </form>
                """));
    }

    private static void saveNote(HttpExchange ex) throws IOException {
        lastNote = form(ex).getOrDefault("note", "");
        redirect(ex, "/job?id=1001");
    }

    private static void search(HttpExchange ex) throws IOException {
        String q = query(ex).getOrDefault("q", "");
        String result = q.isBlank() ? "" : q.contains("1001") || q.toLowerCase().contains("meter")
                ? "<p data-test=\"search-hit\">1001 Meter swap</p>"
                : "<p data-test=\"search-empty\">No jobs</p>";
        html(ex, page("Search", """
                <form action="/search" method="get">
                <input data-test="search-box" name="q" value="%s"/>
                <button data-test="search-go">Search</button>
                </form>
                %s
                <a href="/home">Home</a>
                """.formatted(q, result)));
    }

    private static void priority(HttpExchange ex) throws IOException {
        html(ex, page("Priority", """
                <h1 data-test="priority-title">High priority</h1>
                <ul data-test="priority-list">
                <li data-test="prio-1001">1001 Meter swap — HIGH</li>
                </ul>
                <a href="/home">Home</a>
                """));
    }

    private static void offline(HttpExchange ex) throws IOException {
        html(ex, page("Offline", """
                <div data-test="offline-banner">Offline queue: 2 jobs pending sync</div>
                <a href="/home">Home</a>
                """));
    }

    private static void settings(HttpExchange ex) throws IOException {
        html(ex, page("Settings", """
                <p data-test="current-depot">%s</p>
                <form action="/saveDepot" method="post">
                <select data-test="depot-select" name="depot">
                <option>JHB-North</option>
                <option>CPT-West</option>
                <option>DBN-Central</option>
                </select>
                <button data-test="save-depot">Save depot</button>
                </form>
                """.formatted(depot)));
    }

    private static void saveDepot(HttpExchange ex) throws IOException {
        depot = form(ex).getOrDefault("depot", depot);
        redirect(ex, "/home");
    }

    private static void timeout(HttpExchange ex) throws IOException {
        idleTicks++;
        if (idleTicks >= 2) {
            html(ex, page("Session", """
                    <p data-test="session-expired">Session expired</p>
                    <a data-test="back-login" href="/">Sign in</a>
                    """));
            return;
        }
        html(ex, page("Idle", """
                <p data-test="session-active">Session active</p>
                <a data-test="idle-again" href="/timeout">Check again</a>
                """));
    }

    private static void logout(HttpExchange ex) throws IOException {
        reset();
        redirect(ex, "/");
    }

    private static String page(String title, String body) {
        return """
                <html><head><meta name="viewport" content="width=device-width, initial-scale=1"/>
                <title>%s</title>
                <style>body{font-family:sans-serif;padding:16px}a,button,input,select,textarea{display:block;margin:8px 0;width:100%%}</style>
                </head><body>%s</body></html>
                """.formatted(title, body);
    }

    private static Map<String, String> form(HttpExchange ex) throws IOException {
        String body = new String(ex.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
        return parse(body);
    }

    private static Map<String, String> query(HttpExchange ex) {
        String raw = ex.getRequestURI().getRawQuery();
        return parse(raw == null ? "" : raw);
    }

    private static Map<String, String> parse(String raw) {
        Map<String, String> map = new HashMap<>();
        if (raw.isBlank()) {
            return map;
        }
        for (String pair : raw.split("&")) {
            String[] kv = pair.split("=", 2);
            map.put(URLDecoder.decode(kv[0], StandardCharsets.UTF_8),
                    kv.length > 1 ? URLDecoder.decode(kv[1], StandardCharsets.UTF_8) : "");
        }
        return map;
    }

    private static void html(HttpExchange ex, String body) throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", "text/html; charset=utf-8");
        ex.sendResponseHeaders(200, bytes.length);
        try (OutputStream os = ex.getResponseBody()) {
            os.write(bytes);
        }
    }

    private static void redirect(HttpExchange ex, String loc) throws IOException {
        ex.getResponseHeaders().set("Location", loc);
        ex.sendResponseHeaders(302, -1);
        ex.close();
    }
}
