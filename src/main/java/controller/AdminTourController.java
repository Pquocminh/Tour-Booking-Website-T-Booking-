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
        response.sendRedirect(request.getContextPath() + "/admin/tours");
    }
}
