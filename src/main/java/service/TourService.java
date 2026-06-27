package service;

import dao.TourDAO;
import model.Tour;
import model.Category;
import model.Destination;
import model.TourSchedule;
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

    public List<Category> getAllCategories() {
        return tourDAO.getAllCategories();
    }

    public List<Destination> getAllDestinations() {
        return tourDAO.getAllDestinations();
    }

    public List<Tour> searchToursAdmin(String keyword, String status, Integer categoryId, Integer destinationId) {
        return tourDAO.searchToursAdmin(keyword, status, categoryId, destinationId);
    }

    public boolean addTour(Tour tour) {
        return tourDAO.addTour(tour);
    }

    public boolean updateTour(Tour tour) {
        return tourDAO.updateTour(tour);
    }

    public boolean updateTourStatus(int tourId, String status) {
        return tourDAO.updateTourStatus(tourId, status);
    }

    public boolean deleteTour(int tourId) {
        // Soft delete by setting status to Inactive
        return tourDAO.updateTourStatus(tourId, "Inactive");
    }

    public List<TourSchedule> getTourSchedulesAdmin(int tourId) {
        return tourDAO.getAllTourSchedulesByTourId(tourId);
    }

    public TourSchedule getTourScheduleById(int scheduleId) {
        return tourDAO.getTourScheduleById(scheduleId);
    }

    public boolean updateTourSchedule(TourSchedule schedule) {
        return tourDAO.updateTourSchedule(schedule);
    }

    public List<TourSchedule> getAllTourSchedules(Integer tourId) {
        return tourDAO.getAllTourSchedules(tourId);
    }

    public Tour getTourByIdAdmin(int tourId) {
        return tourDAO.getTourByIdAdmin(tourId);
    }
}
