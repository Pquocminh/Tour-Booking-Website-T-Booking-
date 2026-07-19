package dao;

import db.DBContext;
import model.Booking;
import model.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> getReviewsByCustomerId(int customerId) {
        List<Review> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        String sql = "SELECT r.*, b.booking_date, s.departure_date, t.tour_name " +
                     "FROM Review r " +
                     "JOIN Booking b ON r.booking_id = b.booking_id " +
                     "JOIN TourSchedule s ON b.schedule_id = s.schedule_id " +
                     "JOIN Tour t ON s.tour_id = t.tour_id " +
                     "WHERE r.customer_id = ? " +
                     "ORDER BY r.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setBookingDate(rs.getTimestamp("booking_date"));
                    r.setDepartureDate(rs.getDate("departure_date"));
                    r.setTourName(rs.getString("tour_name"));
                    list.add(r);
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

    public List<Booking> getUnreviewedBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        String sql = "SELECT b.*, bv.voucher_id, s.departure_date, t.tour_name " +
                     "FROM Booking b " +
                     "LEFT JOIN BookingVoucher bv ON b.booking_id = bv.booking_id " +
                     "JOIN TourSchedule s ON b.schedule_id = s.schedule_id " +
                     "JOIN Tour t ON s.tour_id = t.tour_id " +
                     "LEFT JOIN Review r ON b.booking_id = r.booking_id " +
                     "WHERE b.customer_id = ? AND r.review_id IS NULL AND b.status = 'Confirmed' " +
                     "ORDER BY b.booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerId(rs.getInt("customer_id"));
                    b.setScheduleId(rs.getInt("schedule_id"));
                    
                    Object voucherObj = rs.getObject("voucher_id");
                    b.setVoucherId(voucherObj != null ? (Integer) voucherObj : null);
                    
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setNumberOfPeople(rs.getInt("number_of_people"));
                    b.setContactName(rs.getString("contact_name"));
                    b.setContactPhone(rs.getString("contact_phone"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    
                    try {
                        b.setDepositAmount(rs.getDouble("deposit_amount"));
                    } catch (SQLException e) {
                        // ignore if column doesn't exist
                    }
                    
                    b.setStatus(rs.getString("status"));
                    b.setDepartureDate(rs.getDate("departure_date"));
                    b.setTourName(rs.getString("tour_name"));
                    list.add(b);
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

    public boolean addReview(Review review) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "INSERT INTO Review (booking_id, customer_id, rating, comment, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getBookingId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setString(5, review.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deleteReview(int reviewId, int customerId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "DELETE FROM Review WHERE review_id = ? AND customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean hasReviewed(int bookingId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM Review WHERE booking_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
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
        return false;
    }

    public List<Review> getAllReviewsAdmin() {
        List<Review> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        String sql = "SELECT r.*, c.full_name AS customer_name, t.tour_name, s.departure_date " +
                     "FROM Review r " +
                     "JOIN Customer c ON r.customer_id = c.customer_id " +
                     "JOIN Booking b ON r.booking_id = b.booking_id " +
                     "JOIN TourSchedule s ON b.schedule_id = s.schedule_id " +
                     "JOIN Tour t ON s.tour_id = t.tour_id " +
                     "ORDER BY r.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setStaffResponse(rs.getString("staff_response"));
                    r.setResponseDate(rs.getTimestamp("response_date"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setCustomerName(rs.getString("customer_name"));
                    r.setTourName(rs.getString("tour_name"));
                    r.setDepartureDate(rs.getDate("departure_date"));
                    list.add(r);
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

    public boolean updateReviewResponse(int reviewId, String response) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "UPDATE Review SET staff_response = ?, response_date = GETDATE() WHERE review_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, response);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateReviewStatus(int reviewId, String status) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        String sql = "UPDATE Review SET status = ? WHERE review_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Review> getVisibleReviewsByTourId(int tourId) {
        List<Review> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        String sql = "SELECT r.*, c.full_name AS customer_name, s.departure_date " +
                     "FROM Review r " +
                     "JOIN Customer c ON r.customer_id = c.customer_id " +
                     "JOIN Booking b ON r.booking_id = b.booking_id " +
                     "JOIN TourSchedule s ON b.schedule_id = s.schedule_id " +
                     "WHERE s.tour_id = ? AND r.status = 'Visible' " +
                     "ORDER BY r.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setStaffResponse(rs.getString("staff_response"));
                    r.setResponseDate(rs.getTimestamp("response_date"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setCustomerName(rs.getString("customer_name"));
                    r.setDepartureDate(rs.getDate("departure_date"));
                    list.add(r);
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
}

