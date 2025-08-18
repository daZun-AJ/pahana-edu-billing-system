package com.pahanaedu.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectionTest {

	public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/pahanaedu";
        String dbUser = "root";
        String dbPassword = "2002";

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println("Connecting to database...");
            Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            System.out.println("✅ Database connected successfully!");
            connection.close();
        } 
        catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL JDBC Driver not found. Add mysql-connector-java.jar to your classpath.");
            e.printStackTrace();
        } 
        catch (SQLException e) {
            System.out.println("❌ Connection failed!");
            e.printStackTrace();
        }
    }
	
}
