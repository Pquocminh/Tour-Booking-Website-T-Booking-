package dao;

import db.DBContext;
import model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBContext {

    public boolean insertBooking(Booking booking) {
        String insertBookingSql = "INSERT INTO Booking (customer_id, schedule_id, voucher_id, booking_date, number_of_people, contact_name, contact_phone, total_price, deposit_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateScheduleSql = "UPDATE TourSchedule SET available_slots = available_slots - ? WHERE schedule_id = ? AND available_slots >= ?";

        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false); // Start transaction

            // 1. Update AvailableSlots first
            try (PreparedStatement psUpdate = connection.prepareStatement(updateScheduleSql)) {
                psUpdate.setInt(1, booking.getNumberOfPeople());
                psUpdate.setInt(2, booking.getScheduleId());
                psUpdate.setInt(3, booking.getNumberOfPeople());
                int rowsUpdated = psUpdate.executeUpdate();
                
                if (rowsUpdated == 0) {
                    // Not enough slots
                    connection.rollback();
                    return false;
                }
            }

            // 2. Insert Booking
            try (PreparedStatement psInsert = connection.prepareStatement(insertBookingSql)) {
                psInsert.setInt(1, booking.getCustomerId());
                psInsert.setInt(2, booking.getScheduleId());
                if (booking.getVoucherId() != null) {
                    psInsert.setInt(3, booking.getVoucherId());
                } else {
                    psInsert.setNull(3, java.sql.Types.INTEGER);
                }
                psInsert.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
                psInsert.setInt(5, booking.getNumberOfPeople());
                psInsert.setString(6, booking.getContactName());
                psInsert.setString(7, booking.getContactPhone());
                psInsert.setDouble(8, booking.getTotalPrice());
                psInsert.setDouble(9, booking.getDepositAmount());
                psInsert.setString(10, booking.getStatus());
                
                int rowsInserted = psInsert.executeUpdate();
                if (rowsInserted > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, t.tour_name, ts.departure_date, a.username AS customer_username, a.email AS customer_email " +
                     "FROM Booking b " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "LEFT JOIN Account a ON b.customer_id = a.account_id " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setScheduleId(rs.getInt("schedule_id"));
                if (rs.getObject("voucher_id") != null) {
                    b.setVoucherId(rs.getInt("voucher_id"));
                }
                b.setBookingDate(rs.getTimestamp("booking_date"));
                b.setNumberOfPeople(rs.getInt("number_of_people"));
                b.setContactName(rs.getString("contact_name"));
                b.setContactPhone(rs.getString("contact_phone"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setDepositAmount(rs.getDouble("deposit_amount"));
                b.setStatus(rs.getString("status"));
                
                b.setTourName(rs.getString("tour_name"));
                b.setDepartureDate(rs.getDate("departure_date"));
                b.setCustomerUsername(rs.getString("customer_username"));
                b.setCustomerEmail(rs.getString("customer_email"));
                
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Booking WHERE booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerId(rs.getInt("customer_id"));
                    b.setScheduleId(rs.getInt("schedule_id"));
                    if (rs.getObject("voucher_id") != null) {
                        b.setVoucherId(rs.getInt("voucher_id"));
                    }
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setNumberOfPeople(rs.getInt("number_of_people"));
                    b.setContactName(rs.getString("contact_name"));
                    b.setContactPhone(rs.getString("contact_phone"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDepositAmount(rs.getDouble("deposit_amount"));
                    b.setStatus(rs.getString("status"));
                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelBooking(int bookingId) {
        Booking booking = getBookingById(bookingId);
        if (booking == null) {
            return false;
        }
        if ("Cancelled".equalsIgnoreCase(booking.getStatus())) {
            return true; // Already cancelled
        }

        String updateBookingSql = "UPDATE Booking SET status = 'Cancelled' WHERE booking_id = ?";
        String updateScheduleSql = "UPDATE TourSchedule SET available_slots = available_slots + ? WHERE schedule_id = ?";

        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false); // Start transaction

            // 1. Update Booking status to Cancelled
            try (PreparedStatement psUpdateBooking = connection.prepareStatement(updateBookingSql)) {
                psUpdateBooking.setInt(1, bookingId);
                int rowsUpdated = psUpdateBooking.executeUpdate();
                if (rowsUpdated == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // 2. Add slots back to TourSchedule
            try (PreparedStatement psUpdateSchedule = connection.prepareStatement(updateScheduleSql)) {
                psUpdateSchedule.setInt(1, booking.getNumberOfPeople());
                psUpdateSchedule.setInt(2, booking.getScheduleId());
                int rowsUpdated = psUpdateSchedule.executeUpdate();
                if (rowsUpdated > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
}
