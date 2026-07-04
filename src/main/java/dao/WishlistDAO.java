package dao;

import db.DBContext;
import model.Tour;
import model.Category;
import model.Destination;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    private static final String WISHLIST_TOUR_SELECT_QUERY = 
        "SELECT t.tour_id, t.tour_name, t.departure_location, t.description, "
        + "t.duration_days, t.base_price, t.status, t.created_at, t.created_by, "
        + "t.category_id, t.destination_id, "
        + "c.category_id, c.category_name, c.description AS cat_desc, "
        + "d.destination_id, d.destination_name, d.province, d.region, "
        + "d.description AS dest_desc, d.image_url AS dest_image, "
        + "(SELECT TOP 1 image_url FROM TourImage WHERE tour_id = t.tour_id AND is_thumbnail = 1) AS thumbnail_url "
        + "FROM Wishlist w "
        + "INNER JOIN Tour t ON w.tour_id = t.tour_id "
        + "LEFT JOIN Category c ON t.category_id = c.category_id "
        + "LEFT JOIN Destination d ON t.destination_id = d.destination_id "
        + "WHERE w.customer_id = ? AND t.status = 'Active' "
        + "ORDER BY w.added_at DESC";

    public List<Tour> getWishlistToursByCustomerId(int customerId) {
        List<Tour> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }

        try (PreparedStatement ps = conn.prepareStatement(WISHLIST_TOUR_SELECT_QUERY)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = mapTourFromResultSet(rs);
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

    public boolean isInWishlist(int customerId, int tourId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "SELECT 1 FROM Wishlist WHERE customer_id = ? AND tour_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean addTourToWishlist(int customerId, int tourId) {
        if (isInWishlist(customerId, tourId)) {
            return true; // Already wishlisted
        }
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "INSERT INTO Wishlist (customer_id, tour_id, added_at) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, tourId);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean removeTourFromWishlist(int customerId, int tourId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "DELETE FROM Wishlist WHERE customer_id = ? AND tour_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, tourId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean removeMultipleToursFromWishlist(int customerId, List<Integer> tourIds) {
        if (tourIds == null || tourIds.isEmpty()) {
            return false;
        }
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        StringBuilder sql = new StringBuilder("DELETE FROM Wishlist WHERE customer_id = ? AND tour_id IN (");
        for (int i = 0; i < tourIds.size(); i++) {
            sql.append("?");
            if (i < tourIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(")");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, customerId);
            for (int i = 0; i < tourIds.size(); i++) {
                ps.setInt(i + 2, tourIds.get(i));
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    private Tour mapTourFromResultSet(ResultSet rs) throws SQLException {
        Tour tour = new Tour();
        tour.setTourId(rs.getInt("tour_id"));
        tour.setCategoryId(rs.getInt("category_id"));
        tour.setCreatedBy(rs.getInt("created_by"));
        tour.setDestinationId(rs.getInt("destination_id"));
        tour.setTourName(rs.getString("tour_name"));
        tour.setDepartureLocation(rs.getString("departure_location"));
        tour.setDescription(rs.getString("description"));
        tour.setDurationDays(rs.getInt("duration_days"));
        tour.setBasePrice(rs.getDouble("base_price"));
        tour.setStatus(rs.getString("status"));
        tour.setCreatedAt(rs.getTimestamp("created_at"));

        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("cat_desc"));
        tour.setCategory(category);
        
        Destination destination = new Destination();
        destination.setDestinationId(rs.getInt("destination_id"));
        destination.setDestinationName(rs.getString("destination_name"));
        destination.setProvince(rs.getString("province"));
        destination.setRegion(rs.getString("region"));
        destination.setDescription(rs.getString("dest_desc"));
        destination.setImageUrl(rs.getString("dest_image"));
        tour.setDestination(destination);
        
        tour.setThumbnailUrl(rs.getString("thumbnail_url"));
        return tour;
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
