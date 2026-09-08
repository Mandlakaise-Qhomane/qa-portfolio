package com.bank.framework.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class ConfigReader {
    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = ConfigReader.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in == null) {
                throw new IllegalStateException("config.properties not found on classpath");
            }
            PROPS.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private ConfigReader() {}

    public static String get(String key) {
        return PROPS.getProperty(key);
    }

    public static int getInt(String key) {
        return Integer.parseInt(PROPS.getProperty(key));
    }

    public static boolean getBoolean(String key) {
        return Boolean.parseBoolean(PROPS.getProperty(key));
    }
}
