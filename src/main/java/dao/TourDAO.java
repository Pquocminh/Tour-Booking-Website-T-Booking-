package dao;

import db.DBContext;
import model.Tour;
import model.Category;
import model.Destination;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TourDAO {
    public List<Tour> getAvailableTours() {
        List<Tour> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        
        String sql = "SELECT t.tour_id, t.tour_name, t.departure_location, t.description, "
                   + "t.duration_days, t.base_price, t.status, t.created_at, t.created_by, "
                   + "c.category_id, c.category_name, c.description AS cat_desc, "
                   + "d.destination_id, d.destination_name, d.province, d.region, "
                   + "d.description AS dest_desc, d.image_url AS dest_image, "
                   + "ti.image_url AS thumbnail_url "
                   + "FROM Tour t "
                   + "LEFT JOIN Category c ON t.category_id = c.category_id "
                   + "LEFT JOIN Destination d ON t.destination_id = d.destination_id "
                   + "LEFT JOIN TourImage ti ON t.tour_id = ti.tour_id AND ti.is_thumbnail = 1 "
                   + "WHERE t.status = 'Active'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
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
                
                list.add(tour);
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
