package com.shelfbound.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // =========================
    // DEFAULT LOCAL CONFIGURATION
    // =========================
    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/shelfbound"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&characterEncoding=UTF-8";

    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "Raji6@mysql";

    // =========================
    // LOAD JDBC DRIVER
    // =========================
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✔ MySQL JDBC Driver Loaded Successfully");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL JDBC Driver Loading Failed");
            e.printStackTrace();
        }
    }

    public static String getUrl() {
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            return envUrl.trim();
        }
        String mysqlUrl = System.getenv("MYSQL_URL");
        if (mysqlUrl != null && !mysqlUrl.trim().isEmpty()) {
            if (!mysqlUrl.startsWith("jdbc:")) {
                return "jdbc:" + mysqlUrl.trim();
            }
            return mysqlUrl.trim();
        }
        return DEFAULT_URL;
    }

    public static String getUser() {
        String envUser = System.getenv("DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) {
            return envUser.trim();
        }
        String mysqlUser = System.getenv("MYSQLUSER");
        if (mysqlUser != null && !mysqlUser.trim().isEmpty()) {
            return mysqlUser.trim();
        }
        return DEFAULT_USER;
    }

    public static String getPassword() {
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass != null) {
            return envPass;
        }
        String mysqlPass = System.getenv("MYSQLPASSWORD");
        if (mysqlPass != null) {
            return mysqlPass;
        }
        return DEFAULT_PASSWORD;
    }

    // =========================
    // GET DATABASE CONNECTION
    // =========================
    public static Connection getConnection() {
        try {
            String url = getUrl();
            String user = getUser();
            String password = getPassword();

            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✔ Database Connection Successful");
            return conn;
        } catch (SQLException e) {
            System.out.println("❌ Database Connection Failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}