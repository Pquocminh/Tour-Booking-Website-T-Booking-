package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import db.DBContext;
import model.Voucher;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT voucher_id, voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status " +
                     "FROM Voucher ORDER BY voucher_id DESC";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Voucher(
                        rs.getInt("voucher_id"),
                        rs.getString("voucher_code"),
                        rs.getDouble("discount_percent"),
                        rs.getDouble("minimum_order_value"),
                        rs.getDouble("max_discount_amount"),
                        rs.getInt("quantity"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT voucher_id, voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status " +
                     "FROM Voucher WHERE voucher_id = ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Voucher(
                            rs.getInt("voucher_id"),
                            rs.getString("voucher_code"),
                            rs.getDouble("discount_percent"),
                            rs.getDouble("minimum_order_value"),
                            rs.getDouble("max_discount_amount"),
                            rs.getInt("quantity"),
                            rs.getDate("start_date"),
                            rs.getDate("end_date"),
                            rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addVoucher(Voucher voucher) {
        String sql = "INSERT INTO Voucher (voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucher.getVoucherCode());
            ps.setDouble(2, voucher.getDiscountPercent());
            ps.setDouble(3, voucher.getMinimumOrderValue());
            ps.setDouble(4, voucher.getMaxDiscountAmount());
            ps.setInt(5, voucher.getQuantity());
            ps.setDate(6, voucher.getStartDate());
            ps.setDate(7, voucher.getEndDate());
            ps.setString(8, voucher.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVoucher(Voucher voucher) {
        String sql = "UPDATE Voucher SET voucher_code=?, discount_percent=?, minimum_order_value=?, max_discount_amount=?, quantity=?, start_date=?, end_date=?, status=? " +
                     "WHERE voucher_id=?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucher.getVoucherCode());
            ps.setDouble(2, voucher.getDiscountPercent());
            ps.setDouble(3, voucher.getMinimumOrderValue());
            ps.setDouble(4, voucher.getMaxDiscountAmount());
            ps.setInt(5, voucher.getQuantity());
            ps.setDate(6, voucher.getStartDate());
            ps.setDate(7, voucher.getEndDate());
            ps.setString(8, voucher.getStatus());
            ps.setInt(9, voucher.getVoucherId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM Voucher WHERE voucher_id = ?";
        DBContext db = new DBContext();
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
