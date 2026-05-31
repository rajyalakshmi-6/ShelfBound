package com.shelfbound.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class TestConnection {

    public static void main(String[] args) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/shelfbound",
                "root",
                "Raji6@mysql"
            );

            System.out.println("SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}