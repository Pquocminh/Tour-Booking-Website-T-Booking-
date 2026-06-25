package service;

import dao.TourDAO;
import model.Tour;
import java.util.List;

public class TourService {
    private final TourDAO tourDAO = new TourDAO();

    public List<Tour> getAvailableTours() {
        return tourDAO.getAvailableTours();
    }
    
    public Tour getTourById(int tourId) {
        return tourDAO.getTourById(tourId);
    }
    
    public List<Tour> searchTours(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAvailableTours();
        }
        return tourDAO.searchTours(keyword.trim());
    }
    
    public List<Tour> searchByCategory(int categoryId) {
        return tourDAO.searchToursByCategory(categoryId);
    }
    
    public List<Tour> searchByDestination(int destinationId) {
        return tourDAO.searchToursByDestination(destinationId);
    }

    public Tour getTourDetails(int tourId) {
        return tourDAO.getTourDetails(tourId);
    }
}
