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
        String insertBookingSql = "INSERT INTO Booking (customer_id, schedule_id, booking_date, number_of_people, contact_name, contact_phone, total_price, deposit_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateScheduleSql = "UPDATE TourSchedule SET available_slots = available_slots - ? WHERE schedule_id = ? AND available_slots >= ?";
        String insertBookingVoucherSql = "INSERT INTO BookingVoucher (booking_id, voucher_id) VALUES (?, ?)";

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
            try (PreparedStatement psInsert = connection.prepareStatement(insertBookingSql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, booking.getCustomerId());
                psInsert.setInt(2, booking.getScheduleId());
                psInsert.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));
                psInsert.setInt(4, booking.getNumberOfPeople());
                psInsert.setString(5, booking.getContactName());
                psInsert.setString(6, booking.getContactPhone());
                psInsert.setDouble(7, booking.getTotalPrice());
                psInsert.setDouble(8, booking.getDepositAmount());
                psInsert.setString(9, booking.getStatus());
                
                int rowsInserted = psInsert.executeUpdate();
                if (rowsInserted > 0) {
                    try (ResultSet generatedKeys = psInsert.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            booking.setBookingId(generatedKeys.getInt(1));
                        }
                    }
                    
                    // 3. Insert BookingVoucher link if voucher is applied
                    if (booking.getVoucherId() != null) {
                        try (PreparedStatement psVoucher = connection.prepareStatement(insertBookingVoucherSql)) {
                            psVoucher.setInt(1, booking.getBookingId());
                            psVoucher.setInt(2, booking.getVoucherId());
                            psVoucher.executeUpdate();
                        }
                        
                        // Reduce voucher quantity by 1
                        String reduceVoucherSql = "UPDATE Voucher SET quantity = quantity - 1 WHERE voucher_id = ?";
                        try (PreparedStatement psReduce = connection.prepareStatement(reduceVoucherSql)) {
                            psReduce.setInt(1, booking.getVoucherId());
                            psReduce.executeUpdate();
                        }
                    }
                    
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
        String sql = "SELECT b.*, bv.voucher_id, t.tour_name, ts.departure_date, c.username AS customer_username, c.email AS customer_email " +
                     "FROM Booking b " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "LEFT JOIN Customer c ON b.customer_id = c.customer_id " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
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
        String sql = "SELECT b.*, bv.voucher_id FROM Booking b LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id WHERE b.booking_id = ?";
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

            // Refund voucher quantity if exists
            int oldVoucherId = -1;
            String selectOldVoucherSql = "SELECT voucher_id FROM BookingVoucher WHERE booking_id = ?";
            try (PreparedStatement psSelect = connection.prepareStatement(selectOldVoucherSql)) {
                psSelect.setInt(1, bookingId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        oldVoucherId = rs.getInt("voucher_id");
                    }
                }
            }
            
            if (oldVoucherId != -1) {
                String refundVoucherSql = "UPDATE Voucher SET quantity = quantity + 1 WHERE voucher_id = ?";
                try (PreparedStatement psRefund = connection.prepareStatement(refundVoucherSql)) {
                    psRefund.setInt(1, oldVoucherId);
                    psRefund.executeUpdate();
                }
            }

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

    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, bv.voucher_id, t.tour_name, ts.departure_date " +
                     "FROM Booking b " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
                     "WHERE b.customer_id = ? " +
                     "ORDER BY b.booking_date DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
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
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingDetailById(int bookingId) {
        String sql = "SELECT b.*, t.tour_name, t.description AS tour_description, t.duration_days, t.departure_location, ts.departure_date, ts.return_date, v.voucher_code, v.discount_percent " +
                     "FROM Booking b " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
                     "LEFT JOIN Voucher v ON bv.voucher_id = v.voucher_id " +
                     "WHERE b.booking_id = ?";
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
                    
                    b.setTourName(rs.getString("tour_name"));
                    b.setTourDescription(rs.getString("tour_description"));
                    b.setDurationDays(rs.getInt("duration_days"));
                    b.setDepartureLocation(rs.getString("departure_location"));
                    b.setDepartureDate(rs.getDate("departure_date"));
                    b.setReturnDate(rs.getDate("return_date"));
                    b.setVoucherCode(rs.getString("voucher_code"));
                    b.setDiscountPercent(rs.getDouble("discount_percent"));
                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Booking getBookingDetails(int bookingId) {
        String sql = "SELECT b.*, bv.voucher_id, t.tour_name, ts.departure_date " +
                     "FROM Booking b " +
                     "JOIN TourSchedule ts ON b.schedule_id = ts.schedule_id " +
                     "JOIN Tour t ON ts.tour_id = t.tour_id " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
                     "WHERE b.booking_id = ?";
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
                            
                            b.setTourName(rs.getString("tour_name"));
                            b.setDepartureDate(rs.getDate("departure_date"));
                            return b;
                        }
                    }
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (java.sql.SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    public boolean applyVoucherToBooking(int bookingId, int voucherId, double newTotalPrice, double newDepositAmount) {
        String updateBookingSql = "UPDATE Booking SET total_price = ?, deposit_amount = ? WHERE booking_id = ?";
        String deleteOldVoucherSql = "DELETE FROM BookingVoucher WHERE booking_id = ?";
        String insertNewVoucherSql = "INSERT INTO BookingVoucher (booking_id, voucher_id) VALUES (?, ?)";
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Get old voucher if exists to refund quantity
            int oldVoucherId = -1;
            String selectOldVoucherSql = "SELECT voucher_id FROM BookingVoucher WHERE booking_id = ?";
            try (PreparedStatement psSelect = conn.prepareStatement(selectOldVoucherSql)) {
                psSelect.setInt(1, bookingId);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        oldVoucherId = rs.getInt("voucher_id");
                    }
                }
            }
            
            if (oldVoucherId != -1) {
                String refundVoucherSql = "UPDATE Voucher SET quantity = quantity + 1 WHERE voucher_id = ?";
                try (PreparedStatement psRefund = conn.prepareStatement(refundVoucherSql)) {
                    psRefund.setInt(1, oldVoucherId);
                    psRefund.executeUpdate();
                }
            }

            // Reduce new voucher quantity by 1
            String reduceVoucherSql = "UPDATE Voucher SET quantity = quantity - 1 WHERE voucher_id = ?";
            try (PreparedStatement psReduce = conn.prepareStatement(reduceVoucherSql)) {
                psReduce.setInt(1, voucherId);
                psReduce.executeUpdate();
            }

            // 1. Update Booking
            try (PreparedStatement psUpdate = conn.prepareStatement(updateBookingSql)) {
                psUpdate.setDouble(1, newTotalPrice);
                psUpdate.setDouble(2, newDepositAmount);
                psUpdate.setInt(3, bookingId);
                psUpdate.executeUpdate();
            }
            
            // 2. Delete old voucher association if exists
            try (PreparedStatement psDelete = conn.prepareStatement(deleteOldVoucherSql)) {
                psDelete.setInt(1, bookingId);
                psDelete.executeUpdate();
            }
            
            // 3. Insert new voucher association
            try (PreparedStatement psInsert = conn.prepareStatement(insertNewVoucherSql)) {
                psInsert.setInt(1, bookingId);
                psInsert.setInt(2, voucherId);
                psInsert.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
}

