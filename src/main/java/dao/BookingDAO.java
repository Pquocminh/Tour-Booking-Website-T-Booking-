package dao;

import db.DBContext;
import model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
}
