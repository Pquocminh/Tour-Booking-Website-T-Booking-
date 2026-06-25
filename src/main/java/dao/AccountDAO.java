package dao;

import db.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {
    public Account checkLogin(String loginInput, String passwordHash) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Account WHERE (username = ? OR email = ?) AND password_hash = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginInput);
            ps.setString(2, loginInput);
            ps.setString(3, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    acc.setCreatedAt(rs.getTimestamp("created_at"));
                    acc.setLastLogin(rs.getTimestamp("last_login"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public Account getAccountByEmail(String email) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Account WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    acc.setCreatedAt(rs.getTimestamp("created_at"));
                    acc.setLastLogin(rs.getTimestamp("last_login"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public boolean checkUsernameExists(String username) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "SELECT 1 FROM Account WHERE username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean insertAccount(Account acc) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "INSERT INTO Account (username, password_hash, email, full_name, phone, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getUsername());
            ps.setString(2, acc.getPasswordHash());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getFullName());
            ps.setString(5, acc.getPhone());
            ps.setString(6, acc.getRole());
            ps.setString(7, acc.getStatus());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean updatePassword(String email, String newPasswordHash) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "UPDATE Account SET password_hash = ? WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
