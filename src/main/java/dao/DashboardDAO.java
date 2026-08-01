package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
        String sql = "SELECT TOP (?) b.*, bv.voucher_id, t.tour_name " +
                     "FROM Booking b " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "ORDER BY b.booking_id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
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
                    b.setTourName(rs.getString("tour_name"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String[] getWeeklyRevenueData() {
        String sql = "SELECT CAST(booking_date AS DATE) as bdate, ISNULL(SUM(total_price), 0)/1000000.0 as revenue " +
                     "FROM Booking " +
                     "WHERE status IN ('Confirmed', 'Completed', 'Paid') " +
                     "AND booking_date >= DATEADD(day, -6, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY CAST(booking_date AS DATE)";
                     
        java.util.Map<String, Double> revenueMap = new java.util.HashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                revenueMap.put(rs.getDate("bdate").toString(), rs.getDouble("revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM-dd");
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.DAY_OF_YEAR, -6);
        
        for (int i = 0; i < 7; i++) {
            if (i > 0) {
                labels.append(",");
                data.append(",");
            }
            java.sql.Date sqlDate = new java.sql.Date(cal.getTimeInMillis());
            labels.append("\"").append(sdf.format(sqlDate)).append("\"");
            Double rev = revenueMap.getOrDefault(sqlDate.toString(), 0.0);
            data.append(String.format(java.util.Locale.US, "%.2f", rev));
            cal.add(java.util.Calendar.DAY_OF_YEAR, 1);
        }
        
        labels.append("]");
        data.append("]");
        return new String[]{labels.toString(), data.toString()};
    }

    public String[] getMonthlyRevenueData() {
        java.util.Calendar now = java.util.Calendar.getInstance();
        return getMonthlyRevenueData(now.get(java.util.Calendar.MONTH) + 1, now.get(java.util.Calendar.YEAR));
    }

    public String[] getMonthlyRevenueData(int month, int year) {
        String sql = "SELECT CAST(booking_date AS DATE) as bdate, ISNULL(SUM(total_price), 0)/1000000.0 as revenue " +
                     "FROM Booking " +
                     "WHERE status IN ('Confirmed', 'Completed', 'Paid') " +
                     "AND MONTH(booking_date) = ? " +
                     "AND YEAR(booking_date) = ? " +
                     "GROUP BY CAST(booking_date AS DATE)";
                     
        java.util.Map<String, Double> revenueMap = new java.util.HashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenueMap.put(rs.getDate("bdate").toString(), rs.getDouble("revenue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM"); 
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.YEAR, year);
        cal.set(java.util.Calendar.MONTH, month - 1);
        cal.set(java.util.Calendar.DAY_OF_MONTH, 1); 
        int maxDays = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
        
        for (int i = 1; i <= maxDays; i++) {
            if (i > 1) {
                labels.append(",");
                data.append(",");
            }
            java.sql.Date sqlDate = new java.sql.Date(cal.getTimeInMillis());
            labels.append("\"").append(sdf.format(sqlDate)).append("\"");
            Double rev = revenueMap.getOrDefault(sqlDate.toString(), 0.0);
            data.append(String.format(java.util.Locale.US, "%.2f", rev));
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
        }
        
        labels.append("]");
        data.append("]");
        return new String[]{labels.toString(), data.toString()};
    }

    public String[] getYearlyRevenueData() {
        String sql = "SELECT MONTH(booking_date) as bmonth, ISNULL(SUM(total_price), 0)/1000000.0 as revenue " +
                     "FROM Booking " +
                     "WHERE status IN ('Confirmed', 'Completed', 'Paid') " +
                     "AND YEAR(booking_date) = YEAR(GETDATE()) " +
                     "GROUP BY MONTH(booking_date)";
                     
        java.util.Map<Integer, Double> revenueMap = new java.util.HashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                revenueMap.put(rs.getInt("bmonth"), rs.getDouble("revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        
        for (int i = 1; i <= 12; i++) {
            if (i > 1) {
                labels.append(",");
                data.append(",");
            }
            labels.append("\"").append(monthNames[i-1]).append("\"");
            Double rev = revenueMap.getOrDefault(i, 0.0);
            data.append(String.format(java.util.Locale.US, "%.2f", rev));
        }
        
        labels.append("]");
        data.append("]");
        return new String[]{labels.toString(), data.toString()};
    }

    public Map<String, Object> getBookingStatusDistributionDetails() {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM Booking GROUP BY status";
        int completed = 0, pending = 0, canceled = 0, total = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                total += count;
                String s = status != null ? status.trim().toUpperCase() : "";
                if ("COMPLETED".equals(s) || "PAID".equals(s) || "CONFIRMED".equals(s)) {
                    completed += count;
                } else if ("CANCELED".equals(s) || "CANCELLED".equals(s)) {
                    canceled += count;
                } else {
                    pending += count;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        int completionRate = total > 0 ? (int) Math.round((completed * 100.0) / total) : 0;
        map.put("distributionJson", "[" + completed + ", " + pending + ", " + canceled + "]");
        map.put("completionRate", completionRate);
        map.put("completed", completed);
        map.put("pending", pending);
        map.put("canceled", canceled);
        map.put("total", total);
        return map;
    }

    public String[] getTourAnalytics() {
        String sql = "SELECT TOP 5 " +
                     "    t.tour_name, " +
                     "    ISNULL(SUM(ts.available_slots), 0) as available_seats, " +
                     "    ISNULL(SUM(booked.booked_seats), 0) as booked_seats " +
                     "FROM Tour t " +
                     "JOIN TourSchedule ts ON t.tour_id = ts.tour_id " +
                     "LEFT JOIN ( " +
                     "    SELECT schedule_id, SUM(number_of_people) as booked_seats " +
                     "    FROM Booking " +
                     "    WHERE status IN ('Confirmed', 'Completed', 'Paid') " +
                     "    GROUP BY schedule_id " +
                     ") booked ON ts.schedule_id = booked.schedule_id " +
                     "GROUP BY t.tour_id, t.tour_name " +
                     "ORDER BY booked_seats DESC";
        StringBuilder labels = new StringBuilder("[");
        StringBuilder dataBooked = new StringBuilder("[");
        StringBuilder dataAvailable = new StringBuilder("[");
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first) { 
                    labels.append(","); 
                    dataBooked.append(","); 
                    dataAvailable.append(","); 
                }
                labels.append("\"").append(rs.getString("tour_name")).append("\"");
                dataBooked.append(rs.getInt("booked_seats"));
                dataAvailable.append(rs.getInt("available_seats"));
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        labels.append("]");
        dataBooked.append("]");
        dataAvailable.append("]");
        return new String[]{labels.toString(), dataBooked.toString(), dataAvailable.toString()};
    }
}

