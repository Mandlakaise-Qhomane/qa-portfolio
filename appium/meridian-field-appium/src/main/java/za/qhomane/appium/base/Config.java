package za.qhomane.appium.base;

import java.io.InputStream;
import java.util.Properties;

public final class Config {
    private static final Properties P = new Properties();

    static {
        try (InputStream in = Config.class.getClassLoader().getResourceAsStream("config.properties")) {
            P.load(in);
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private Config() {}

    public static String get(String key) {
        String env = System.getenv(key.toUpperCase());
        return env != null && !env.isBlank() ? env : P.getProperty(key);
    }

    public static int getInt(String key) {
        return Integer.parseInt(get(key));
    }

    public static boolean getBool(String key) {
        return Boolean.parseBoolean(get(key));
    }
}
