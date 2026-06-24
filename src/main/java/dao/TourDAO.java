package dao;

import db.DBContext;
import model.Tour;
import model.Category;
import model.Destination;
import model.Itinerary;
import model.TourSchedule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class TourDAO {
    
    private static final String TOUR_SELECT_QUERY = 
        "SELECT t.tour_id, t.tour_name, t.departure_location, t.description, "
        + "t.duration_days, t.base_price, t.status, t.created_at, t.created_by, "
        + "t.category_id, t.destination_id, "
        + "c.category_id, c.category_name, c.description AS cat_desc, "
        + "d.destination_id, d.destination_name, d.province, d.region, "
        + "d.description AS dest_desc, d.image_url AS dest_image, "
        + "ti.image_url AS thumbnail_url "
        + "FROM Tour t "
        + "LEFT JOIN Category c ON t.category_id = c.category_id "
        + "LEFT JOIN Destination d ON t.destination_id = d.destination_id "
        + "LEFT JOIN TourImage ti ON t.tour_id = ti.tour_id AND ti.is_thumbnail = 1 ";
    
    public List<Tour> getAvailableTours() {
        String sql = TOUR_SELECT_QUERY + "WHERE t.status = 'Active'";
        return executeTourQuery(sql, null);
    }
    
    public Tour getTourById(int tourId) {
        String sql = TOUR_SELECT_QUERY + "WHERE t.tour_id = ? AND t.status = 'Active'";
        List<Tour> tours = executeTourQuery(sql, new Object[]{tourId});
        return tours.isEmpty() ? null : tours.get(0);
    }
    
    public List<Tour> searchTours(String keyword) {
        String sql = TOUR_SELECT_QUERY + 
            "WHERE t.status = 'Active' AND " +
            "(t.tour_name LIKE ? OR t.description LIKE ? OR d.destination_name LIKE ? OR c.category_name LIKE ?)";
        String searchKeyword = "%" + keyword + "%";
        return executeTourQuery(sql, new Object[]{searchKeyword, searchKeyword, searchKeyword, searchKeyword});
    }
    
    public List<Tour> searchToursByCategory(int categoryId) {
        String sql = TOUR_SELECT_QUERY + "WHERE t.status = 'Active' AND t.category_id = ?";
        return executeTourQuery(sql, new Object[]{categoryId});
    }
    
    public List<Tour> searchToursByDestination(int destinationId) {
        String sql = TOUR_SELECT_QUERY + "WHERE t.status = 'Active' AND t.destination_id = ?";
        return executeTourQuery(sql, new Object[]{destinationId});
    }
    
    private List<Tour> executeTourQuery(String sql, Object[] params) {
        List<Tour> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    ps.setObject(i + 1, params[i]);
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tour tour = mapTourFromResultSet(rs);
                    list.add(tour);
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
        

    public Tour getTourById(int tourId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
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
                   + "WHERE t.tour_id = ? AND t.status = 'Active'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
        return null;
    }

    public List<String> getTourImages(int tourId) {
        List<String> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT image_url FROM TourImage WHERE tour_id = ? ORDER BY is_thumbnail DESC, uploaded_at ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("image_url"));
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

    public List<Itinerary> getTourItineraries(int tourId) {
        List<Itinerary> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT * FROM Itinerary WHERE tour_id = ? ORDER BY day_number ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Itinerary iti = new Itinerary();
                    iti.setItineraryId(rs.getInt("itinerary_id"));
                    iti.setTourId(rs.getInt("tour_id"));
                    iti.setDayNumber(rs.getInt("day_number"));
                    iti.setTitle(rs.getString("title"));
                    iti.setDescription(rs.getString("description"));
                    list.add(iti);
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

    public List<TourSchedule> getTourSchedules(int tourId) {
        List<TourSchedule> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT * FROM TourSchedule WHERE tour_id = ? AND status = 'Open' AND departure_date >= CAST(GETDATE() AS DATE) ORDER BY departure_date ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourSchedule sched = new TourSchedule();
                    sched.setScheduleId(rs.getInt("schedule_id"));
                    sched.setTourId(rs.getInt("tour_id"));
                    sched.setDepartureDate(rs.getDate("departure_date"));
                    sched.setReturnDate(rs.getDate("return_date"));
                    sched.setPrice(rs.getDouble("price"));
                    sched.setAvailableSlots(rs.getInt("available_slots"));
                    sched.setStatus(rs.getString("status"));
                    list.add(sched);
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

    public Tour getTourDetails(int tourId) {
        Tour tour = getTourById(tourId);
        if (tour != null) {
            tour.setImageUrls(getTourImages(tourId));
            tour.setItineraries(getTourItineraries(tourId));
            tour.setSchedules(getTourSchedules(tourId));
        }
        return tour;
    }
}
