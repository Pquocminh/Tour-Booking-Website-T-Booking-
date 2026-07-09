package dao;

import db.DBContext;
import model.Promotion;
import model.Tour;
import model.Category;
import model.Destination;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT promotion_id, promotion_name, discount_percent, start_date, end_date, status FROM Promotion ORDER BY start_date DESC, promotion_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromotionId(rs.getInt("promotion_id"));
                p.setPromotionName(rs.getString("promotion_name"));
                p.setDiscountPercent(rs.getInt("discount_percent"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public List<Promotion> getActivePromotions() {
        List<Promotion> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        // Get promotions that are Active, started already, and haven't ended yet
        String sql = "SELECT promotion_id, promotion_name, discount_percent, start_date, end_date, status " +
                     "FROM Promotion " +
                     "WHERE status = 'Active' " +
                     "AND CAST(GETDATE() AS DATE) >= start_date " +
                     "AND CAST(GETDATE() AS DATE) <= end_date " +
                     "ORDER BY discount_percent DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromotionId(rs.getInt("promotion_id"));
                p.setPromotionName(rs.getString("promotion_name"));
                p.setDiscountPercent(rs.getInt("discount_percent"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public Promotion getPromotionById(int promotionId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }
        String sql = "SELECT promotion_id, promotion_name, discount_percent, start_date, end_date, status FROM Promotion WHERE promotion_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Promotion p = new Promotion();
                    p.setPromotionId(rs.getInt("promotion_id"));
                    p.setPromotionName(rs.getString("promotion_name"));
                    p.setDiscountPercent(rs.getInt("discount_percent"));
                    p.setStartDate(rs.getDate("start_date"));
                    p.setEndDate(rs.getDate("end_date"));
                    p.setStatus(rs.getString("status"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public List<Tour> getToursByPromotionId(int promotionId) {
        List<Tour> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT t.tour_id, t.tour_name, t.base_price, t.duration_days, t.status, " +
                     "c.category_id, c.category_name, d.destination_id, d.destination_name " +
                     "FROM Tour t " +
                     "JOIN TourPromotion tp ON t.tour_id = tp.tour_id " +
                     "LEFT JOIN Category c ON t.category_id = c.category_id " +
                     "LEFT JOIN Destination d ON t.destination_id = d.destination_id " +
                     "WHERE tp.promotion_id = ? " +
                     "ORDER BY t.tour_id ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = new Tour();
                    tour.setTourId(rs.getInt("tour_id"));
                    tour.setTourName(rs.getString("tour_name"));
                    tour.setBasePrice(rs.getDouble("base_price"));
                    tour.setDurationDays(rs.getInt("duration_days"));
                    tour.setStatus(rs.getString("status"));

                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setCategoryName(rs.getString("category_name"));
                    tour.setCategory(cat);

                    Destination dest = new Destination();
                    dest.setDestinationId(rs.getInt("destination_id"));
                    dest.setDestinationName(rs.getString("destination_name"));
                    tour.setDestination(dest);

                    list.add(tour);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public boolean addPromotion(Promotion p, List<Integer> tourIds) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sqlPromo = "INSERT INTO Promotion (promotion_name, discount_percent, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
        String sqlMapping = "INSERT INTO TourPromotion (promotion_id, tour_id) VALUES (?, ?)";
        try {
            conn.setAutoCommit(false);
            int promotionId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sqlPromo, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, p.getPromotionName());
                ps.setInt(2, p.getDiscountPercent());
                ps.setDate(3, p.getStartDate());
                ps.setDate(4, p.getEndDate());
                ps.setString(5, p.getStatus());

                int affected = ps.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        promotionId = generatedKeys.getInt(1);
                    }
                }
            }

            if (promotionId != -1 && tourIds != null && !tourIds.isEmpty()) {
                try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                    for (int tourId : tourIds) {
                        psMap.setInt(1, promotionId);
                        psMap.setInt(2, tourId);
                        psMap.addBatch();
                    }
                    psMap.executeBatch();
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean deletePromotion(int promotionId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sqlMapping = "DELETE FROM TourPromotion WHERE promotion_id = ?";
        String sqlPromo = "DELETE FROM Promotion WHERE promotion_id = ?";
        try {
            conn.setAutoCommit(false);
            // Delete associations first
            try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                psMap.setInt(1, promotionId);
                psMap.executeUpdate();
            }
            // Delete promotion
            try (PreparedStatement psPromo = conn.prepareStatement(sqlPromo)) {
                psPromo.setInt(1, promotionId);
                psPromo.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean updatePromotion(Promotion p, List<Integer> tourIds) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sqlPromo = "UPDATE Promotion SET promotion_name = ?, discount_percent = ?, start_date = ?, end_date = ?, status = ? WHERE promotion_id = ?";
        String sqlDeleteMapping = "DELETE FROM TourPromotion WHERE promotion_id = ?";
        String sqlMapping = "INSERT INTO TourPromotion (promotion_id, tour_id) VALUES (?, ?)";
        try {
            conn.setAutoCommit(false);

            // 1. Update Promotion table
            try (PreparedStatement ps = conn.prepareStatement(sqlPromo)) {
                ps.setString(1, p.getPromotionName());
                ps.setInt(2, p.getDiscountPercent());
                ps.setDate(3, p.getStartDate());
                ps.setDate(4, p.getEndDate());
                ps.setString(5, p.getStatus());
                ps.setInt(6, p.getPromotionId());
                ps.executeUpdate();
            }

            // 2. Delete old mappings
            try (PreparedStatement psDel = conn.prepareStatement(sqlDeleteMapping)) {
                psDel.setInt(1, p.getPromotionId());
                psDel.executeUpdate();
            }

            // 3. Insert new mappings
            if (tourIds != null && !tourIds.isEmpty()) {
                try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                    for (int tourId : tourIds) {
                        psMap.setInt(1, p.getPromotionId());
                        psMap.setInt(2, tourId);
                        psMap.addBatch();
                    }
                    psMap.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    private void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
