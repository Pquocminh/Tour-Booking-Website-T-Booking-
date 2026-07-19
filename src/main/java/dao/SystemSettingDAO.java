package dao;

import db.DBContext;
import model.SystemSetting;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SystemSettingDAO {

    public SystemSettingDAO() {
        try {
            initTable();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void initTable() throws SQLException {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            throw new SQLException("Could not connect to database! Connection is null.");
        }
        
        try {
            // Check if table exists using sys.tables
            String checkTableSql = "SELECT 1 FROM sys.tables WHERE name = 'SystemSetting'";
            boolean tableExists = false;
            try (PreparedStatement ps = conn.prepareStatement(checkTableSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tableExists = true;
                }
            }

            if (!tableExists) {
                // Create table
                String createTableSql = "CREATE TABLE SystemSetting (" +
                        "setting_id INT IDENTITY(1,1) PRIMARY KEY, " +
                        "setting_key VARCHAR(100) NOT NULL UNIQUE, " +
                        "setting_value NVARCHAR(MAX) NOT NULL, " +
                        "description NVARCHAR(500)" +
                        ")";
                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(createTableSql);
                }
            }

            // Seed default settings if they are missing (self-healing / robust)
            seedKeyIfMissing(conn, "booking_window_days", "3", "Minimum days before departure to allow a booking");
            seedKeyIfMissing(conn, "deposit_percent", "20", "Deposit percentage required for booking");
            seedKeyIfMissing(conn, "cancellation_window_days", "7", "Minimum days before departure to allow cancellation");

        } finally {
            closeConnection(conn);
        }
    }

    private void seedKeyIfMissing(Connection conn, String key, String value, String description) throws SQLException {
        String checkKeySql = "SELECT 1 FROM SystemSetting WHERE setting_key = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkKeySql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    String insertSql = "INSERT INTO SystemSetting (setting_key, setting_value, description) VALUES (?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setString(1, key);
                        psInsert.setString(2, value);
                        psInsert.setString(3, description);
                        psInsert.executeUpdate();
                    }
                }
            }
        }
    }

    public String getSettingValueByKey(String key) throws SQLException {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            throw new SQLException("Could not connect to database! Connection is null.");
        }
        String sql = "SELECT setting_value FROM SystemSetting WHERE setting_key = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("setting_value");
                }
            }
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public List<SystemSetting> getAllSettings() throws SQLException {
        List<SystemSetting> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            throw new SQLException("Could not connect to database! Connection is null.");
        }
        String sql = "SELECT setting_id, setting_key, setting_value, description FROM SystemSetting";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SystemSetting setting = new SystemSetting();
                setting.setSettingId(rs.getInt("setting_id"));
                setting.setSettingKey(rs.getString("setting_key"));
                setting.setSettingValue(rs.getString("setting_value"));
                setting.setDescription(rs.getString("description"));
                list.add(setting);
            }
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public boolean updateSetting(String key, String value) throws SQLException {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            throw new SQLException("Could not connect to database! Connection is null.");
        }
        // Use UPSERT syntax (SQL Server specific) to prevent issues with missing keys
        String sql = "IF EXISTS (SELECT 1 FROM SystemSetting WHERE setting_key = ?) " +
                     "UPDATE SystemSetting SET setting_value = ? WHERE setting_key = ? " +
                     "ELSE " +
                     "INSERT INTO SystemSetting (setting_key, setting_value) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.setString(3, key);
            ps.setString(4, key);
            ps.setString(5, value);
            int rows = ps.executeUpdate();
            return true;
        } finally {
            closeConnection(conn);
        }
    }

    private void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
