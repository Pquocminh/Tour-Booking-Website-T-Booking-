package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Tour;
import model.Category;
import model.Destination;
import model.Account;
import service.TourService;

@WebServlet(name = "AdminTourController", urlPatterns = {"/admin/tours"})
public class AdminTourController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equalsIgnoreCase(action)) {
            request.setAttribute("categories", tourService.getAllCategories());
            request.setAttribute("destinations", tourService.getAllDestinations());
            request.getRequestDispatcher("/WEB-INF/views/admin/edit-tour.jsp").forward(request, response);
            return;
        } else if ("edit".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    Tour tour = tourService.getTourByIdAdmin(id);
                    if (tour != null) {
                        request.setAttribute("tour", tour);
                        request.setAttribute("categories", tourService.getAllCategories());
                        request.setAttribute("destinations", tourService.getAllDestinations());
                        request.getRequestDispatcher("/WEB-INF/views/admin/edit-tour.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {}
            }
            response.sendRedirect(request.getContextPath() + "/admin/tours");
            return;
        } else if ("view".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    Tour tour = tourService.getTourDetails(id);
                    if (tour != null) {
                        request.setAttribute("tour", tour);
                        request.getRequestDispatcher("/WEB-INF/views/admin/admin-tour-detail.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {}
            }
            response.sendRedirect(request.getContextPath() + "/admin/tours");
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String categoryParam = request.getParameter("category");
        String destinationParam = request.getParameter("destination");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {}
        }

        Integer destinationId = null;
        if (destinationParam != null && !destinationParam.isEmpty()) {
            try {
                destinationId = Integer.parseInt(destinationParam);
            } catch (NumberFormatException e) {}
        }

        // Fetch searched / filtered tours
        List<Tour> tours = tourService.searchToursAdmin(search, status, categoryId, destinationId);
        
        // Fetch dropdown options
        List<Category> categories = tourService.getAllCategories();
        List<Destination> destinations = tourService.getAllDestinations();

        request.setAttribute("tours", tours);
        request.setAttribute("categories", categories);
        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedDestination", destinationId);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-tours.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Account currentUser = (Account) request.getSession().getAttribute("user");
        
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                tourService.deleteTour(id);
                request.getSession().setAttribute("successMessage", "Tour has been marked as Inactive (Soft Deleted).");
            } catch (Exception e) {}
            response.sendRedirect(request.getContextPath() + "/admin/tours");
            return;
        } else if ("create".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
            try {
                Tour tour = new Tour();
                if ("update".equalsIgnoreCase(action)) {
                    tour.setTourId(Integer.parseInt(request.getParameter("id")));
                }
                tour.setTourName(request.getParameter("tourName"));
                tour.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                tour.setDestinationId(Integer.parseInt(request.getParameter("destinationId")));
                tour.setDepartureLocation(request.getParameter("departureLocation"));
                tour.setDescription(request.getParameter("description"));
                tour.setDurationDays(Integer.parseInt(request.getParameter("durationDays")));
                tour.setBasePrice(Double.parseDouble(request.getParameter("basePrice")));
                tour.setStatus(request.getParameter("status"));
                tour.setThumbnailUrl(request.getParameter("thumbnailUrl"));
                
                if (currentUser != null) {
                    tour.setCreatedBy(currentUser.getAccountId());
                } else {
                    tour.setCreatedBy(1); // fallback
                }

                boolean success;
                if ("update".equalsIgnoreCase(action)) {
                    success = tourService.updateTour(tour);
                    request.getSession().setAttribute(success ? "successMessage" : "errorMessage", 
                        success ? "Tour updated successfully!" : "Failed to update tour.");
                } else {
                    success = tourService.addTour(tour);
                    request.getSession().setAttribute(success ? "successMessage" : "errorMessage", 
                        success ? "Tour created successfully!" : "Failed to create tour.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Invalid input data.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/tours");
    }
}
