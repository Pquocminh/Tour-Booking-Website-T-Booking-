package service;

import dao.TourDAO;
import model.Tour;
import java.util.List;

public class TourService {
    private final TourDAO tourDAO = new TourDAO();

    public List<Tour> getAvailableTours() {
        return tourDAO.getAvailableTours();
    }

    public Tour getTourDetails(int tourId) {
        return tourDAO.getTourDetails(tourId);
    }
}
