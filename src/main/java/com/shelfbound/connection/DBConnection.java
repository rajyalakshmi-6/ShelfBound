package com.shelfbound.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // =========================
    // DATABASE CONFIGURATION
    // =========================
    private static final String URL =
            "jdbc:mysql://localhost:3306/shelfbound"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&characterEncoding=UTF-8";

    private static final String USER = "root";

    private static final String PASSWORD = "Raji6@mysql";

    // =========================
    // LOAD JDBC DRIVER
    // =========================
    static {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println(
                "✔ MySQL JDBC Driver Loaded Successfully"
            );

        } catch (ClassNotFoundException e) {

            System.out.println(
                "❌ MySQL JDBC Driver Loading Failed"
            );

            e.printStackTrace();
        }
    }

    // =========================
    // GET DATABASE CONNECTION
    // =========================
    public static Connection getConnection() {

        try {

            Connection conn =
                DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
                );

            System.out.println(
                "✔ Database Connection Successful"
            );

            return conn;

        } catch (SQLException e) {

            System.out.println(
                "❌ Database Connection Failed"
            );

            e.printStackTrace();

            return null;
        }
    }
}