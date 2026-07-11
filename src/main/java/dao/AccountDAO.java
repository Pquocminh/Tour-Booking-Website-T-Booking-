package dao;

import db.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
                    acc.setAddress(rs.getString("address"));
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
                    acc.setAddress(rs.getString("address"));
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

        String sql = "INSERT INTO Account (username, password_hash, email, full_name, phone, address, role, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getUsername());
            ps.setString(2, acc.getPasswordHash());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getFullName());
            ps.setString(5, acc.getPhone());
            ps.setString(6, acc.getAddress());
            ps.setString(7, acc.getRole());
            ps.setString(8, acc.getStatus());
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

    public boolean updateProfile(Account acc) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) return false;

        String sql = "UPDATE Account SET full_name = ?, phone = ?, email = ?, address = ? WHERE account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getFullName());
            ps.setString(2, acc.getPhone());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getAddress());
            ps.setInt(5, acc.getAccountId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null && !conn.isClosed()) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean updatePasswordById(int accountId, String newPasswordHash) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) return false;

        String sql = "UPDATE Account SET password_hash = ? WHERE account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null && !conn.isClosed()) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean checkEmailExistsForOtherAccount(String email, int accountId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) return true;

        String sql = "SELECT 1 FROM Account WHERE email = ? AND account_id != ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null && !conn.isClosed()) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return true;
    }

    public Account getAccountByUsernameOrEmail(String input) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Account WHERE username = ? OR email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
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

    public List<Account> getAllAccounts(String search, String role, String status) {
        List<Account> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Account WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR email LIKE ? OR full_name LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (role != null && !role.trim().isEmpty() && !"All".equalsIgnoreCase(role)) {
            sql.append(" AND role = ?");
            params.add(role.trim());
        }

        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status)) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY account_id ASC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Account acc = new Account();
                    acc.setAccountId(rs.getInt("account_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
                    acc.setRole(rs.getString("role"));
                    acc.setStatus(rs.getString("status"));
                    acc.setCreatedAt(rs.getTimestamp("created_at"));
                    acc.setLastLogin(rs.getTimestamp("last_login"));
                    list.add(acc);
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
        return list;
    }

    /**
     * Retrieves an account by its ID.
     * Sequence Diagram Steps:
     * 1.1.4.1. getConnection()
     * 1.1.4.2. prepareStatement(sql)
     * 1.1.4.3. executeQuery()
     *   1.1.4.3.1. Send SELECT Account by ID
     * 1.1.4.4. close()
     */
    public Account getAccountById(int accountId) {
        DBContext db = new DBContext();
        
        // 1.1.4.1. getConnection()
        Connection conn = db.getConnection();
        if (conn == null) {
            System.err.println("[AccountDAO] Error: Database connection is null.");
            return null;
        }

        // Database Query as specified: SELECT account_id, username, email, full_name, phone, address, role, status, created_at FROM Account WHERE account_id = ?;
        String sql = "SELECT account_id, username, email, full_name, phone, address, role, status, created_at FROM Account WHERE account_id = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 1.1.4.2. prepareStatement(sql)
            ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            
            // 1.1.4.3. executeQuery() -> 1.1.4.3.1. Send SELECT Account by ID
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setUsername(rs.getString("username"));
                acc.setEmail(rs.getString("email"));
                acc.setFullName(rs.getString("full_name"));
                acc.setPhone(rs.getString("phone"));
                acc.setAddress(rs.getString("address"));
                acc.setRole(rs.getString("role"));
                acc.setStatus(rs.getString("status"));
                acc.setCreatedAt(rs.getTimestamp("created_at"));
                return acc;
            }
        } catch (SQLException e) {
            System.err.println("[AccountDAO] SQLException occurred during getAccountById:");
            e.printStackTrace();
        } finally {
            // 1.1.4.4. close()
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("[AccountDAO] Error closing database resources:");
                e.printStackTrace();
            }
        }
        return null;
    }

    public boolean updateAccount(Account acc) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "UPDATE Account SET full_name = ?, phone = ?, email = ?, address = ?, role = ?, status = ? WHERE account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getFullName());
            ps.setString(2, acc.getPhone());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getAddress());
            ps.setString(5, acc.getRole());
            ps.setString(6, acc.getStatus());
            ps.setInt(7, acc.getAccountId());
            return ps.executeUpdate() > 0;
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

    /**
     * Deletes an account by its ID.
     * Sequence Diagram Steps:
     * 1.1.4.1. getConnection()
     * 1.1.4.2. prepareStatement(sql)
     * 1.1.4.3. executeUpdate()
     *   1.1.4.3.1. Send DELETE Account to database
     * 1.1.4.4. close()
     */
    public boolean deleteAccount(int accountId) {
        DBContext db = new DBContext();
        
        // 1.1.4.1. getConnection()
        Connection conn = db.getConnection();
        if (conn == null) {
            System.err.println("[AccountDAO] Error: Database connection is null.");
            return false;
        }

        // Database Query as specified: DELETE FROM Account WHERE account_id = ?;
        String sql = "DELETE FROM Account WHERE account_id = ?";
        PreparedStatement ps = null;
        
        try {
            // 1.1.4.2. prepareStatement(sql)
            ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            
            System.out.println("[AccountDAO] Executing SQL: " + sql + " with ID: " + accountId);
            
            // 1.1.4.3. executeUpdate() -> 1.1.4.3.1. Send DELETE Account
            int rowsDeleted = ps.executeUpdate();
            
            System.out.println("[AccountDAO] Rows deleted: " + rowsDeleted);
            return rowsDeleted > 0;
        } catch (SQLException e) {
            System.err.println("[AccountDAO] SQLException occurred during deleteAccount:");
            e.printStackTrace();
        } finally {
            // 1.1.4.4. close()
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
                System.out.println("[AccountDAO] Database connection and resources closed successfully.");
            } catch (SQLException e) {
                System.err.println("[AccountDAO] Error closing database resources:");
                e.printStackTrace();
            }
        }
        return false;
    }
}

