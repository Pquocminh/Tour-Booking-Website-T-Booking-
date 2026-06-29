package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Tour;
import model.Review;
import dao.ReviewDAO;
import service.TourService;

@WebServlet(name = "TourDetailsController", urlPatterns = {"/tour-details"})
public class TourDetailsController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        try {
            int tourId = Integer.parseInt(idParam);
            Tour tour = tourService.getTourDetails(tourId);
            if (tour == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }
            
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getVisibleReviewsByTourId(tourId);
            request.setAttribute("reviews", reviews);

            request.setAttribute("tour", tour);
            request.getRequestDispatcher("/WEB-INF/views/guest/tour-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }
}
