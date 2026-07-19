package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Booking;

public class DashboardDAO extends DBContext {

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Customer";
        int count = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalTours() {
        String sql = "SELECT COUNT(*) FROM Tour";
        int count = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalBookings() {
        String sql = "SELECT COUNT(*) FROM Booking";
        int count = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public double getTotalRevenue() {
        // Assume revenue is from CONFIRMED or COMPLETED bookings
        String sql = "SELECT SUM(total_price) FROM Booking WHERE status IN ('Confirmed', 'Completed', 'Paid')";
        double total = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Booking> getRecentBookings(int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY booking_date DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id")); // Use exact column names from your DB schema if needed
                    // Wait, earlier I saw CustomerId, ScheduleId, VoucherId... Let's map what we need for the Dashboard.
                    b.setCustomerId(rs.getInt("customer_id"));
                    b.setScheduleId(rs.getInt("schedule_id"));
                    b.setVoucherId(rs.getObject("voucher_id") != null ? rs.getInt("voucher_id") : null);
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setNumberOfPeople(rs.getInt("number_of_people"));
                    b.setContactName(rs.getString("contact_name"));
                    b.setContactPhone(rs.getString("contact_phone"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDepositAmount(rs.getDouble("deposit_amount"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String[] getRevenueLast7Days() {
        String sql = "SELECT CAST(booking_date AS DATE) as bdate, SUM(total_price) as revenue " +
                     "FROM Booking WHERE booking_date >= DATEADD(day, -7, GETDATE()) " +
                     "GROUP BY CAST(booking_date AS DATE) ORDER BY bdate ASC";
        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first) { labels.append(","); data.append(","); }
                labels.append("'").append(rs.getDate("bdate").toString()).append("'");
                data.append(rs.getDouble("revenue"));
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        labels.append("]");
        data.append("]");
        return new String[]{labels.toString(), data.toString()};
    }

    public String getBookingStatusDistribution() {
        String sql = "SELECT status, COUNT(*) as cnt FROM Booking GROUP BY status";
        int completed = 0, pending = 0, canceled = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                if ("COMPLETED".equalsIgnoreCase(status) || "PAID".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status)) {
                    completed += count;
                } else if ("CANCELED".equalsIgnoreCase(status)) {
                    canceled += count;
                } else {
                    pending += count;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "[" + completed + ", " + pending + ", " + canceled + "]";
    }
}
