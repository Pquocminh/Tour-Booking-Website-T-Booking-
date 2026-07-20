package dao;

import db.DBContext;
import model.Destination;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DestinationDAO {

    public List<Destination> getAllDestinations() {
        List<Destination> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        String sql = "SELECT destination_id, destination_name, province, region, description, image_url FROM Destination ORDER BY destination_id ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Destination dest = new Destination();
                dest.setDestinationId(rs.getInt("destination_id"));
                dest.setDestinationName(rs.getString("destination_name"));
                dest.setProvince(rs.getString("province"));
                dest.setRegion(rs.getString("region"));
                dest.setDescription(rs.getString("description"));
                dest.setImageUrl(rs.getString("image_url"));
                list.add(dest);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public List<Destination> searchDestinations(String keyword) {
        List<Destination> list = new ArrayList<>();
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return list;
        }
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllDestinations();
        }
        String sql = "SELECT destination_id, destination_name, province, region, description, image_url FROM Destination " +
                     "WHERE destination_name LIKE ? OR province LIKE ? OR region LIKE ? OR description LIKE ? ORDER BY destination_id ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Destination dest = new Destination();
                    dest.setDestinationId(rs.getInt("destination_id"));
                    dest.setDestinationName(rs.getString("destination_name"));
                    dest.setProvince(rs.getString("province"));
                    dest.setRegion(rs.getString("region"));
                    dest.setDescription(rs.getString("description"));
                    dest.setImageUrl(rs.getString("image_url"));
                    list.add(dest);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return list;
    }

    public Destination getDestinationById(int destinationId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return null;
        }
        String sql = "SELECT destination_id, destination_name, province, region, description, image_url FROM Destination WHERE destination_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, destinationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Destination dest = new Destination();
                    dest.setDestinationId(rs.getInt("destination_id"));
                    dest.setDestinationName(rs.getString("destination_name"));
                    dest.setProvince(rs.getString("province"));
                    dest.setRegion(rs.getString("region"));
                    dest.setDescription(rs.getString("description"));
                    dest.setImageUrl(rs.getString("image_url"));
                    return dest;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return null;
    }

    public boolean addDestination(Destination destination) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "INSERT INTO Destination (destination_name, province, region, description, image_url) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, destination.getDestinationName());
            ps.setString(2, destination.getProvince());
            ps.setString(3, destination.getRegion());
            ps.setString(4, destination.getDescription());
            ps.setString(5, destination.getImageUrl());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean updateDestination(Destination destination) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "UPDATE Destination SET destination_name = ?, province = ?, region = ?, description = ?, image_url = ? WHERE destination_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, destination.getDestinationName());
            ps.setString(2, destination.getProvince());
            ps.setString(3, destination.getRegion());
            ps.setString(4, destination.getDescription());
            ps.setString(5, destination.getImageUrl());
            ps.setInt(6, destination.getDestinationId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    public boolean isDestinationInUse(int destinationId) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Tour WHERE destination_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, destinationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
        return false;
    }

    public boolean deleteDestination(int destinationId) {
        if (isDestinationInUse(destinationId)) {
            return false;
        }
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            return false;
        }
        String sql = "DELETE FROM Destination WHERE destination_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, destinationId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    private void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
