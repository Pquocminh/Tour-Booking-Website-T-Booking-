package db;


import java.sql.Connection;
import java.sql.DriverManager;



public class DBContext {

    private Connection conn;

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(
                "jdbc:sqlserver://localhost:1433;databaseName=BookingTourWebsite;encrypt=false",
                "sa",
                "123"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection(
                    "jdbc:sqlserver://localhost:1433;databaseName=BookingTourWebsite;encrypt=false",
                    "sa",
                    "123"
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
