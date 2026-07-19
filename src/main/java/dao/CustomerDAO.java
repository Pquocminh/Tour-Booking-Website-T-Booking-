package dao;

import db.DBContext;
import model.Customer;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public Customer checkLogin(String loginInput, String passwordHash) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Customer WHERE (username = ? OR email = ?) AND password_hash = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginInput);
            ps.setString(2, loginInput);
            ps.setString(3, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer acc = new Customer();
                    acc.setAccountId(rs.getInt("customer_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
                    
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

    public Customer getAccountByEmail(String email) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Customer WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer acc = new Customer();
                    acc.setAccountId(rs.getInt("customer_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
                    
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

        String sql = "SELECT 1 FROM Customer WHERE username = ?";
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

    public boolean insertAccount(Customer acc) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "INSERT INTO Customer (username, password_hash, email, full_name, phone, address, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getUsername());
            ps.setString(2, acc.getPasswordHash());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getFullName());
            ps.setString(5, acc.getPhone());
            ps.setString(6, acc.getAddress());
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

        String sql = "UPDATE Customer SET password_hash = ? WHERE email = ?";
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

    public boolean updateProfile(Customer acc) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) return false;

        String sql = "UPDATE Customer SET full_name = ?, phone = ?, email = ?, address = ? WHERE customer_id = ?";
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

        String sql = "UPDATE Customer SET password_hash = ? WHERE customer_id = ?";
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

        String sql = "SELECT 1 FROM Customer WHERE email = ? AND customer_id != ?";
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

    public Customer getAccountByUsernameOrEmail(String input) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }

        String sql = "SELECT * FROM Customer WHERE username = ? OR email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer acc = new Customer();
                    acc.setAccountId(rs.getInt("customer_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
                    
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

    public List<Customer> getAllAccounts(String search, String status) {
        List<Customer> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM Customer WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR email LIKE ? OR full_name LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }



        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status)) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY customer_id ASC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer acc = new Customer();
                    acc.setAccountId(rs.getInt("customer_id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPasswordHash(rs.getString("password_hash"));
                    acc.setEmail(rs.getString("email"));
                    acc.setFullName(rs.getString("full_name"));
                    acc.setPhone(rs.getString("phone"));
                    acc.setAddress(rs.getString("address"));
                    
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
    public Customer getAccountById(int accountId) {
        DBContext db = new DBContext();
        
        // 1.1.4.1. getConnection()
        Connection conn = db.getConnection();
        if (conn == null) {
            System.err.println("[AccountDAO] Error: Database connection is null.");
            return null;
        }

        // Database Query as specified: SELECT customer_id, username, email, full_name, phone, address, status, created_at FROM Customer WHERE customer_id = ?;
        String sql = "SELECT customer_id, username, email, full_name, phone, address, status, created_at FROM Customer WHERE customer_id = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 1.1.4.2. prepareStatement(sql)
            ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            
            // 1.1.4.3. executeQuery() -> 1.1.4.3.1. Send SELECT Account by ID
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Customer acc = new Customer();
                acc.setAccountId(rs.getInt("customer_id"));
                acc.setUsername(rs.getString("username"));
                acc.setEmail(rs.getString("email"));
                acc.setFullName(rs.getString("full_name"));
                acc.setPhone(rs.getString("phone"));
                acc.setAddress(rs.getString("address"));
                
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

    /**
     * Updates an account's details.
     * Sequence Diagram Steps:
     * 1.1.4.1. getConnection()
     * 1.1.4.2. prepareStatement(sql)
     * 1.1.4.3. executeUpdate()
     *   1.1.4.3.1. Send UPDATE Customer to database
     * 1.1.4.4. close()
     */
    public boolean updateAccount(Customer acc) {
        DBContext db = new DBContext();
        
        // 1.1.4.1. getConnection()
        Connection conn = db.getConnection();
        if (conn == null) {
            System.err.println("[AccountDAO] Error: Database connection is null.");
            return false;
        }

        // Database Query as specified: UPDATE Customer SET full_name = ?, phone = ?, email = ?, address = ?, status = ? WHERE customer_id = ?;
        String sql = "UPDATE Customer SET full_name = ?, phone = ?, email = ?, address = ?, status = ? WHERE customer_id = ?";
        PreparedStatement ps = null;
        
        try {
            // 1.1.4.2. prepareStatement(sql)
            ps = conn.prepareStatement(sql);
            ps.setString(1, acc.getFullName());
            ps.setString(2, acc.getPhone());
            ps.setString(3, acc.getEmail());
            ps.setString(4, acc.getAddress());
            ps.setString(5, acc.getStatus());
            ps.setInt(6, acc.getAccountId());
            
            System.out.println("[AccountDAO] Executing SQL: " + sql + " for ID: " + acc.getAccountId());
            
            // 1.1.4.3. executeUpdate() -> 1.1.4.3.1. Send UPDATE Customer
            int rowsUpdated = ps.executeUpdate();
            
            System.out.println("[AccountDAO] Rows updated: " + rowsUpdated);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.err.println("[AccountDAO] SQLException occurred during updateAccount:");
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

        // Database Query as specified: DELETE FROM Customer WHERE customer_id = ?;
        String sql = "DELETE FROM Customer WHERE customer_id = ?";
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

