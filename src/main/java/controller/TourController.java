package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Tour;
import service.TourService;

@WebServlet(name = "TourController", urlPatterns = {"/tours", "/tour-detail"})
public class TourController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/tour-detail".equals(path)) {
            // View Tour Detail
            viewTourDetail(request, response);
        } else if ("/tours".equals(path)) {
            // Check if search parameter is present
            String searchKeyword = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String destinationFilter = request.getParameter("destination");
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Search Tours
                searchTours(request, response, searchKeyword);
            } else if (categoryFilter != null && !categoryFilter.isEmpty()) {
                // Filter by Category
                filterByCategory(request, response, Integer.parseInt(categoryFilter));
            } else if (destinationFilter != null && !destinationFilter.isEmpty()) {
                // Filter by Destination
                filterByDestination(request, response, Integer.parseInt(destinationFilter));
            } else {
                // View Tour List
                viewTourList(request, response);
            }
        }
    }
    
    private void viewTourList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Tour> tours = tourService.getAvailableTours();
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void searchTours(HttpServletRequest request, HttpServletResponse response, String keyword)
            throws ServletException, IOException {
        List<Tour> tours = tourService.searchTours(keyword);
        request.setAttribute("tours", tours);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("isSearchResult", true);
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response, int categoryId)
            throws ServletException, IOException {
        List<Tour> tours = tourService.searchByCategory(categoryId);
        request.setAttribute("tours", tours);
        request.setAttribute("filterType", "category");
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void filterByDestination(HttpServletRequest request, HttpServletResponse response, int destinationId)
            throws ServletException, IOException {
        List<Tour> tours = tourService.searchByDestination(destinationId);
        request.setAttribute("tours", tours);
        request.setAttribute("filterType", "destination");
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void viewTourDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tourIdParam = request.getParameter("id");
        
        if (tourIdParam == null || tourIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }
        
        try {
            int tourId = Integer.parseInt(tourIdParam);
            Tour tour = tourService.getTourById(tourId);
            
            if (tour == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }
            
            request.setAttribute("tour", tour);
            request.getRequestDispatcher("/WEB-INF/views/guest/tour-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }
}
