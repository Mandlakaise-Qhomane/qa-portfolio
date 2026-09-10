package com.bank.bdd.base;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

/**
 * Deterministic stand-in for Guru99 Bank V4 so recruiters can run mvn test
 * without a live demo ID. Same field names as the public demo.
 */
public final class LocalBankServer {
    public static final int PORT = 18080;
    private static HttpServer server;
    private static final String USER = "mngr123456";
    private static final String PASS = "Pass@123";
    private static final AtomicInteger CUST = new AtomicInteger(10000);
    private static final AtomicInteger ACCT = new AtomicInteger(20000);
    private static final Map<String, Integer> BALANCE = new ConcurrentHashMap<>();
    private static final Map<String, String> ACCT_OWNER = new ConcurrentHashMap<>();

    private LocalBankServer() {}

    public static synchronized void start() throws IOException {
        if (server != null) {
            return;
        }
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", PORT), 0);
        server.createContext("/", LocalBankServer::loginPage);
        server.createContext("/login", LocalBankServer::login);
        server.createContext("/home", LocalBankServer::home);
        server.createContext("/newCustomer", LocalBankServer::newCustomer);
        server.createContext("/saveCustomer", LocalBankServer::saveCustomer);
        server.createContext("/newAccount", LocalBankServer::newAccount);
        server.createContext("/saveAccount", LocalBankServer::saveAccount);
        server.createContext("/deposit", LocalBankServer::depositPage);
        server.createContext("/saveDeposit", LocalBankServer::saveDeposit);
        server.createContext("/withdrawal", LocalBankServer::withdrawPage);
        server.createContext("/saveWithdraw", LocalBankServer::saveWithdraw);
        server.createContext("/logout", LocalBankServer::logout);
        server.setExecutor(null);
        server.start();
    }

    public static synchronized void stop() {
        if (server != null) {
            server.stop(0);
            server = null;
        }
    }

    public static String baseUrl() {
        return "http://127.0.0.1:" + PORT + "/";
    }

    public static String user() {
        return USER;
    }

    public static String pass() {
        return PASS;
    }

    private static void loginPage(HttpExchange ex) throws IOException {
        html(ex, 200, """
                <html><head><title>Guru99 Bank Home Page</title></head><body>
                <form action="/login" method="post">
                UserID <input name="uid" type="text"/>
                Password <input name="password" type="password"/>
                <input name="btnLogin" type="submit" value="LOGIN"/>
                </form></body></html>
                """);
    }

    private static void login(HttpExchange ex) throws IOException {
        Map<String, String> f = form(ex);
        String u = f.getOrDefault("uid", "");
        String p = f.getOrDefault("password", "");
        if (USER.equals(u) && PASS.equals(p)) {
            redirect(ex, "/home");
            return;
        }
        html(ex, 200, alertThen("/", "User or Password is not valid"));
    }

    private static void home(HttpExchange ex) throws IOException {
        html(ex, 200, """
                <html><head><title>Guru99 Bank Manager HomePage</title></head><body>
                <td>Manger Id : mngr123456</td>
                <a href="/newCustomer">New Customer</a>
                <a href="/newAccount">New Account</a>
                <a href="/deposit">Deposit</a>
                <a href="/withdrawal">Withdrawal</a>
                <a href="/logout">Log out</a>
                </body></html>
                """);
    }

    private static void newCustomer(HttpExchange ex) throws IOException {
        html(ex, 200, """
                <html><head><title>Guru99 Bank New Customer</title>
                <script>
                function checkName(){
                  var v=document.getElementsByName('name')[0].value;
                  document.getElementById('message').innerText=/\\d/.test(v)?'Numbers are not allowed':'';
                }
                </script></head><body>
                <form action="/saveCustomer" method="post">
                Name <input name="name" onkeyup="checkName()"/>
                <label id="message"></label>
                <input name="rad1" type="radio" value="m"/>
                <input name="dob"/>
                <input name="addr"/>
                <input name="city"/>
                <input name="state"/>
                <input name="pinno"/>
                <input name="telephoneno"/>
                <input name="emailid"/>
                <input name="password"/>
                <input name="sub" type="submit"/>
                </form></body></html>
                """);
    }

    private static void saveCustomer(HttpExchange ex) throws IOException {
        String id = String.valueOf(CUST.incrementAndGet());
        html(ex, 200, """
                <html><head><title>Guru99 Bank Customer Registered</title></head><body>
                <table>
                <tr><td>Customer ID</td><td>%s</td></tr>
                </table>
                <a href="/home">Home</a>
                </body></html>
                """.formatted(id));
    }

    private static void newAccount(HttpExchange ex) throws IOException {
        html(ex, 200, """
                <html><head><title>Guru99 Bank New Account</title></head><body>
                <form action="/saveAccount" method="post">
                <input name="cusid"/>
                <select name="selaccount"><option>Savings</option><option>Current</option></select>
                <input name="inideposit"/>
                <input name="button2" type="submit"/>
                </form></body></html>
                """);
    }

    private static void saveAccount(HttpExchange ex) throws IOException {
        Map<String, String> f = form(ex);
        String id = String.valueOf(ACCT.incrementAndGet());
        int dep = parseInt(f.get("inideposit"));
        BALANCE.put(id, dep);
        ACCT_OWNER.put(id, f.getOrDefault("cusid", ""));
        html(ex, 200, """
                <html><head><title>Guru99 Bank Account Created</title></head><body>
                <table><tr><td>Account ID</td><td>%s</td></tr></table>
                <p>Transaction details of Account created</p>
                <a href="/home">Home</a>
                </body></html>
                """.formatted(id));
    }

    private static void depositPage(HttpExchange ex) throws IOException {
        moneyForm(ex, "/saveDeposit", "Deposit");
    }

    private static void saveDeposit(HttpExchange ex) throws IOException {
        Map<String, String> f = form(ex);
        String acc = f.getOrDefault("accountno", "");
        int amt = parseInt(f.get("ammount"));
        BALANCE.merge(acc, amt, Integer::sum);
        html(ex, 200, okTxn("Deposit Successful"));
    }

    private static void withdrawPage(HttpExchange ex) throws IOException {
        moneyForm(ex, "/saveWithdraw", "Withdrawal");
    }

    private static void saveWithdraw(HttpExchange ex) throws IOException {
        Map<String, String> f = form(ex);
        String acc = f.getOrDefault("accountno", "");
        int amt = parseInt(f.get("ammount"));
        int bal = BALANCE.getOrDefault(acc, 0);
        if (amt > bal) {
            html(ex, 200, alertThen("/home", "Transaction Failed. Account Balance Low!!!"));
            return;
        }
        BALANCE.put(acc, bal - amt);
        html(ex, 200, okTxn("Transaction details of Withdrawal"));
    }

    private static void logout(HttpExchange ex) throws IOException {
        html(ex, 200, alertThen("/", "You Have Succesfully Logged Out!!"));
    }

    private static void moneyForm(HttpExchange ex, String action, String title) throws IOException {
        html(ex, 200, """
                <html><head><title>Guru99 Bank %s</title></head><body>
                <form action="%s" method="post">
                <input name="accountno"/>
                <input name="ammount"/>
                <input name="desc"/>
                <input name="AccSubmit" type="submit"/>
                </form></body></html>
                """.formatted(title, action));
    }

    private static String okTxn(String heading) {
        return """
                <html><head><title>Guru99 Bank</title></head><body>
                <p>Transaction details</p>
                <h3>%s</h3>
                <p>successful</p>
                <a href="/home">Home</a>
                </body></html>
                """.formatted(heading);
    }

    private static String alertThen(String href, String msg) {
        return """
                <html><head><title>Guru99 Bank</title>
                <script>alert('%s');window.location='%s';</script>
                </head><body></body></html>
                """.formatted(msg.replace("'", "\\'"), href);
    }

    private static Map<String, String> form(HttpExchange ex) throws IOException {
        byte[] raw = ex.getRequestBody().readAllBytes();
        String body = new String(raw, StandardCharsets.UTF_8);
        Map<String, String> map = new HashMap<>();
        if (body.isBlank()) {
            return map;
        }
        for (String pair : body.split("&")) {
            String[] kv = pair.split("=", 2);
            String k = URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
            String v = kv.length > 1 ? URLDecoder.decode(kv[1], StandardCharsets.UTF_8) : "";
            map.put(k, v);
        }
        return map;
    }

    private static int parseInt(String s) {
        try {
            return Integer.parseInt(s == null || s.isBlank() ? "0" : s);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private static void html(HttpExchange ex, int code, String body) throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type", "text/html; charset=utf-8");
        ex.sendResponseHeaders(code, bytes.length);
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
