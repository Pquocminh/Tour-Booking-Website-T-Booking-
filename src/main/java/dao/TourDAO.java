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
        + "(SELECT TOP 1 image_url FROM TourImage WHERE tour_id = t.tour_id AND is_thumbnail = 1) AS thumbnail_url "
        + "FROM Tour t "
        + "LEFT JOIN Category c ON t.category_id = c.category_id "
        + "LEFT JOIN Destination d ON t.destination_id = d.destination_id ";
    
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
        return tour;
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
                    sched.setTotalSlots(rs.getInt("total_slots"));
                    sched.setStatus(rs.getString("status"));
                    int staffId = rs.getInt("assigned_staff_id");
                    if (!rs.wasNull()) {
                        sched.setAssignedStaffId(staffId);
                    }
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

    public List<TourSchedule> getAllTourSchedulesByTourId(int tourId) {
        List<TourSchedule> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT * FROM TourSchedule WHERE tour_id = ? ORDER BY departure_date ASC";
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
                    sched.setTotalSlots(rs.getInt("total_slots"));
                    sched.setStatus(rs.getString("status"));
                    int staffId = rs.getInt("assigned_staff_id");
                    if (!rs.wasNull()) {
                        sched.setAssignedStaffId(staffId);
                    }
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

    public List<TourSchedule> getAllTourSchedules(Integer tourId) {
        List<TourSchedule> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        StringBuilder sql = new StringBuilder("SELECT ts.*, t.tour_name FROM TourSchedule ts JOIN Tour t ON ts.tour_id = t.tour_id");
        if (tourId != null && tourId > 0) {
            sql.append(" WHERE ts.tour_id = ?");
        }
        sql.append(" ORDER BY ts.departure_date DESC");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (tourId != null && tourId > 0) {
                ps.setInt(1, tourId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourSchedule sched = new TourSchedule();
                    sched.setScheduleId(rs.getInt("schedule_id"));
                    sched.setTourId(rs.getInt("tour_id"));
                    sched.setDepartureDate(rs.getDate("departure_date"));
                    sched.setReturnDate(rs.getDate("return_date"));
                    sched.setPrice(rs.getDouble("price"));
                    sched.setAvailableSlots(rs.getInt("available_slots"));
                    sched.setTotalSlots(rs.getInt("total_slots"));
                    sched.setStatus(rs.getString("status"));
                    int staffId = rs.getInt("assigned_staff_id");
                    if (!rs.wasNull()) {
                        sched.setAssignedStaffId(staffId);
                    }
                    sched.setTourName(rs.getString("tour_name"));
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

    public List<TourSchedule> getAllTourSchedulesByKeyword(String keyword) {
        List<TourSchedule> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        StringBuilder sql = new StringBuilder("SELECT ts.*, t.tour_name FROM TourSchedule ts JOIN Tour t ON ts.tour_id = t.tour_id");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" WHERE t.tour_name LIKE ?");
            try {
                Integer.parseInt(keyword.trim());
                sql.append(" OR ts.schedule_id = ? OR t.tour_id = ?");
            } catch (NumberFormatException e) {
                // Not an integer
            }
        }
        sql.append(" ORDER BY ts.departure_date DESC");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (hasKeyword) {
                String likeKeyword = "%" + keyword.trim() + "%";
                ps.setString(1, likeKeyword);
                try {
                    int id = Integer.parseInt(keyword.trim());
                    ps.setInt(2, id);
                    ps.setInt(3, id);
                } catch (NumberFormatException e) {
                    // Not an integer
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TourSchedule sched = new TourSchedule();
                    sched.setScheduleId(rs.getInt("schedule_id"));
                    sched.setTourId(rs.getInt("tour_id"));
                    sched.setDepartureDate(rs.getDate("departure_date"));
                    sched.setReturnDate(rs.getDate("return_date"));
                    sched.setPrice(rs.getDouble("price"));
                    sched.setAvailableSlots(rs.getInt("available_slots"));
                    sched.setTotalSlots(rs.getInt("total_slots"));
                    sched.setStatus(rs.getString("status"));
                    int staffId = rs.getInt("assigned_staff_id");
                    if (!rs.wasNull()) {
                        sched.setAssignedStaffId(staffId);
                    }
                    sched.setTourName(rs.getString("tour_name"));
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

    public TourSchedule getTourScheduleById(int scheduleId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }
        String sql = "SELECT * FROM TourSchedule WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TourSchedule sched = new TourSchedule();
                    sched.setScheduleId(rs.getInt("schedule_id"));
                    sched.setTourId(rs.getInt("tour_id"));
                    sched.setDepartureDate(rs.getDate("departure_date"));
                    sched.setReturnDate(rs.getDate("return_date"));
                    sched.setPrice(rs.getDouble("price"));
                    sched.setAvailableSlots(rs.getInt("available_slots"));
                    sched.setTotalSlots(rs.getInt("total_slots"));
                    sched.setStatus(rs.getString("status"));
                    int staffId = rs.getInt("assigned_staff_id");
                    if (!rs.wasNull()) {
                        sched.setAssignedStaffId(staffId);
                    }
                    return sched;
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

    public boolean updateTourSchedule(TourSchedule sched) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE TourSchedule SET tour_id = ?, departure_date = ?, return_date = ?, price = ?, total_slots = ?, available_slots = ?, status = ?, assigned_staff_id = ? WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sched.getTourId());
            ps.setDate(2, sched.getDepartureDate());
            ps.setDate(3, sched.getReturnDate());
            ps.setDouble(4, sched.getPrice());
            ps.setInt(5, sched.getTotalSlots());
            ps.setInt(6, sched.getAvailableSlots());
            ps.setString(7, sched.getStatus());
            if (sched.getAssignedStaffId() != null) {
                ps.setInt(8, sched.getAssignedStaffId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            ps.setInt(9, sched.getScheduleId());
            int rows = ps.executeUpdate();
            return rows > 0;
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

    public Tour getTourByIdAdmin(int tourId) {
        String sql = TOUR_SELECT_QUERY + "WHERE t.tour_id = ?";
        List<Tour> tours = executeTourQuery(sql, new Object[]{tourId});
        return tours.isEmpty() ? null : tours.get(0);
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

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT category_id, category_name, description FROM Category";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                cat.setDescription(rs.getString("description"));
                list.add(cat);
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

    public List<Destination> getAllDestinations() {
        return new DestinationDAO().getAllDestinations();
    }

    public List<Tour> searchToursAdmin(String keyword, String status, Integer categoryId, Integer destinationId) {
        StringBuilder sql = new StringBuilder(TOUR_SELECT_QUERY);
        sql.append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (t.tour_name LIKE ? OR t.description LIKE ? OR d.destination_name LIKE ? OR c.category_name LIKE ?) ");
            String searchKeyword = "%" + keyword.trim() + "%";
            params.add(searchKeyword);
            params.add(searchKeyword);
            params.add(searchKeyword);
            params.add(searchKeyword);
        }

        if (status != null && !status.isEmpty() && !"All".equalsIgnoreCase(status)) {
            sql.append(" AND t.status = ? ");
            params.add(status);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND t.category_id = ? ");
            params.add(categoryId);
        }

        if (destinationId != null && destinationId > 0) {
            sql.append(" AND t.destination_id = ? ");
            params.add(destinationId);
        }

        sql.append(" ORDER BY t.created_at DESC");

        return executeTourQuery(sql.toString(), params.toArray());
    }

    public boolean addTour(Tour tour) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "INSERT INTO Tour (category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            conn.setAutoCommit(false);
            int tourId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, tour.getCategoryId());
                ps.setInt(2, tour.getCreatedBy());
                ps.setInt(3, tour.getDestinationId());
                ps.setString(4, tour.getTourName());
                ps.setString(5, tour.getDepartureLocation());
                ps.setString(6, tour.getDescription());
                ps.setInt(7, tour.getDurationDays());
                ps.setDouble(8, tour.getBasePrice());
                ps.setString(9, tour.getStatus());
                
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
                
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        tourId = generatedKeys.getInt(1);
                    }
                }
            }
            
            if (tourId != -1 && tour.getThumbnailUrl() != null && !tour.getThumbnailUrl().trim().isEmpty()) {
                String imgSql = "INSERT INTO TourImage (tour_id, image_url, is_thumbnail) VALUES (?, ?, 1)";
                try (PreparedStatement psImg = conn.prepareStatement(imgSql)) {
                    psImg.setInt(1, tourId);
                    psImg.setString(2, tour.getThumbnailUrl().trim());
                    psImg.executeUpdate();
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
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateTour(Tour tour) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE Tour SET category_id = ?, destination_id = ?, tour_name = ?, departure_location = ?, description = ?, duration_days = ?, base_price = ?, status = ? WHERE tour_id = ?";
        try {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, tour.getCategoryId());
                ps.setInt(2, tour.getDestinationId());
                ps.setString(3, tour.getTourName());
                ps.setString(4, tour.getDepartureLocation());
                ps.setString(5, tour.getDescription());
                ps.setInt(6, tour.getDurationDays());
                ps.setDouble(7, tour.getBasePrice());
                ps.setString(8, tour.getStatus());
                ps.setInt(9, tour.getTourId());
                ps.executeUpdate();
            }
            
            if (tour.getThumbnailUrl() != null && !tour.getThumbnailUrl().trim().isEmpty()) {
                String checkSql = "SELECT image_id FROM TourImage WHERE tour_id = ? AND is_thumbnail = 1";
                int imgId = -1;
                try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                    psCheck.setInt(1, tour.getTourId());
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            imgId = rs.getInt("image_id");
                        }
                    }
                }
                
                if (imgId != -1) {
                    String updateImgSql = "UPDATE TourImage SET image_url = ? WHERE image_id = ?";
                    try (PreparedStatement psUpd = conn.prepareStatement(updateImgSql)) {
                        psUpd.setString(1, tour.getThumbnailUrl().trim());
                        psUpd.setInt(2, imgId);
                        psUpd.executeUpdate();
                    }
                } else {
                    String insertImgSql = "INSERT INTO TourImage (tour_id, image_url, is_thumbnail) VALUES (?, ?, 1)";
                    try (PreparedStatement psIns = conn.prepareStatement(insertImgSql)) {
                        psIns.setInt(1, tour.getTourId());
                        psIns.setString(2, tour.getThumbnailUrl().trim());
                        psIns.executeUpdate();
                    }
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
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateTourStatus(int tourId, String status) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE Tour SET status = ? WHERE tour_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tourId);
            int rows = ps.executeUpdate();
            return rows > 0;
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

    public boolean isScheduleDateExists(int tourId, java.sql.Date departureDate) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM TourSchedule WHERE tour_id = ? AND departure_date = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tourId);
            pstmt.setDate(2, departureDate);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addTourSchedule(TourSchedule sched) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "INSERT INTO TourSchedule (tour_id, departure_date, return_date, price, total_slots, available_slots, status, assigned_staff_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sched.getTourId());
            ps.setDate(2, sched.getDepartureDate());
            ps.setDate(3, sched.getReturnDate());
            ps.setDouble(4, sched.getPrice());
            ps.setInt(5, sched.getTotalSlots());
            ps.setInt(6, sched.getAvailableSlots());
            ps.setString(7, sched.getStatus());
            if (sched.getAssignedStaffId() != null) {
                ps.setInt(8, sched.getAssignedStaffId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            int rows = ps.executeUpdate();
            return rows > 0;
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

    public boolean deleteTourSchedule(int scheduleId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "DELETE FROM TourSchedule WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            int rows = ps.executeUpdate();
            return rows > 0;
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

    public List<model.Booking> getBookingsByScheduleId(int scheduleId) {
        List<model.Booking> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT * FROM Booking WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Booking b = new model.Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerId(rs.getInt("customer_id"));
                    b.setScheduleId(rs.getInt("schedule_id"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    b.setNumberOfPeople(rs.getInt("number_of_people"));
                    b.setContactName(rs.getString("contact_name"));
                    b.setContactPhone(rs.getString("contact_phone"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setStatus(rs.getString("status"));
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

    public boolean reserveSlots(model.Booking booking) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }

        PreparedStatement psSelect = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;

        try {
            conn.setAutoCommit(false);

            // 1. Lock and select the schedule to verify available slots
            String selectSql = "SELECT available_slots, total_slots, status, price FROM TourSchedule WITH (UPDLOCK) WHERE schedule_id = ?";
            psSelect = conn.prepareStatement(selectSql);
            psSelect.setInt(1, booking.getScheduleId());
            rs = psSelect.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                return false;
            }

            int availableSlots = rs.getInt("available_slots");
            String status = rs.getString("status");

            // Validate status and slots availability
            if (!"Open".equalsIgnoreCase(status) || availableSlots < booking.getNumberOfPeople()) {
                conn.rollback();
                return false;
            }

            // 2. Insert booking record
            String insertSql = "INSERT INTO Booking (customer_id, schedule_id, booking_date, number_of_people, contact_name, contact_phone, total_price, status) VALUES (?, ?, GETDATE(), ?, ?, ?, ?, ?)";
            psInsert = conn.prepareStatement(insertSql);
            psInsert.setInt(1, booking.getCustomerId());
            psInsert.setInt(2, booking.getScheduleId());
            psInsert.setInt(3, booking.getNumberOfPeople());
            psInsert.setString(4, booking.getContactName());
            psInsert.setString(5, booking.getContactPhone());
            psInsert.setDouble(6, booking.getTotalPrice());
            psInsert.setString(7, booking.getStatus());

            int bookingRows = psInsert.executeUpdate();
            if (bookingRows == 0) {
                conn.rollback();
                return false;
            }

            // 3. Update TourSchedule capacity
            int newAvailableSlots = availableSlots - booking.getNumberOfPeople();
            String newStatus = (newAvailableSlots == 0) ? "Full" : "Open";

            String updateSql = "UPDATE TourSchedule SET available_slots = ?, status = ? WHERE schedule_id = ?";
            psUpdate = conn.prepareStatement(updateSql);
            psUpdate.setInt(1, newAvailableSlots);
            psUpdate.setString(2, newStatus);
            psUpdate.setInt(3, booking.getScheduleId());

            int scheduleRows = psUpdate.executeUpdate();
            if (scheduleRows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (psSelect != null) psSelect.close(); } catch (SQLException e) {}
            try { if (psInsert != null) psInsert.close(); } catch (SQLException e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (SQLException e) {}
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean updateTourDuration(int tourId, int durationDays) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE Tour SET duration_days = ? WHERE tour_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, durationDays);
            ps.setInt(2, tourId);
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

    public boolean syncTourDurationFromSchedules(int tourId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "SELECT TOP 1 departure_date, return_date FROM TourSchedule WHERE tour_id = ? ORDER BY departure_date ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.sql.Date dep = rs.getDate("departure_date");
                    java.sql.Date ret = rs.getDate("return_date");
                    if (dep != null && ret != null) {
                        long diffMs = Math.abs(ret.getTime() - dep.getTime());
                        int days = (int) java.util.concurrent.TimeUnit.DAYS.convert(diffMs, java.util.concurrent.TimeUnit.MILLISECONDS) + 1;
                        return updateTourDuration(tourId, days);
                    }
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

    public boolean updateTourBasePrice(int tourId, double basePrice) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE Tour SET base_price = ? WHERE tour_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, basePrice);
            ps.setInt(2, tourId);
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

    public boolean syncTourBasePriceFromSchedules(int tourId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "SELECT MIN(price) AS min_price FROM TourSchedule WHERE tour_id = ? AND status != 'Cancelled'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tourId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double minPrice = rs.getDouble("min_price");
                    if (!rs.wasNull() && minPrice > 0) {
                        return updateTourBasePrice(tourId, minPrice);
                    }
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
}




