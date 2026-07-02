package controller;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import model.Account;
import model.Booking;
import model.Category;
import model.Destination;
import model.Tour;
import dao.CategoryDAO;
import dao.TourDAO;

@WebServlet(name = "AdminTourController", urlPatterns = {"/admin/dashboard", "/admin/tours", "/admin/categories"})
public class AdminTourController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final TourDAO tourDAO = new TourDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/admin/dashboard".equals(path)) {
            handleDashboardGet(request, response);
        } else if ("/admin/tours".equals(path)) {
            handleToursGet(request, response);
        } else if ("/admin/categories".equals(path)) {
            handleCategoriesGet(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/admin/tours".equals(path)) {
            handleToursPost(request, response);
        } else if ("/admin/categories".equals(path)) {
            handleCategoriesPost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ================== DASHBOARD ==================
    private void handleDashboardGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int totalUsers = dashboardDAO.getTotalUsers();
        int totalTours = dashboardDAO.getTotalTours();
        int totalBookings = dashboardDAO.getTotalBookings();
        double totalRevenue = dashboardDAO.getTotalRevenue();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTours", totalTours);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", totalRevenue);

        List<Booking> recentBookings = dashboardDAO.getRecentBookings(5);
        request.setAttribute("recentBookings", recentBookings);

        String[] revenueData = dashboardDAO.getRevenueLast7Days();
        request.setAttribute("salesLabels", revenueData[0]);
        request.setAttribute("salesData", revenueData[1]);
        
        request.setAttribute("donutData", dashboardDAO.getBookingStatusDistribution());
        
        request.setAttribute("barData1", "[60, 45, 80, 50, 70]");
        request.setAttribute("barData2", "[40, 30, 50, 30, 50]");

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    // ================== TOURS ==================
    private void handleToursGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equalsIgnoreCase(action)) {
            request.setAttribute("categories", tourDAO.getAllCategories());
            request.setAttribute("destinations", tourDAO.getAllDestinations());
            request.getRequestDispatcher("/WEB-INF/views/admin/edit-tour.jsp").forward(request, response);
            return;
        } else if ("edit".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    Tour tour = tourDAO.getTourByIdAdmin(id);
                    if (tour != null) {
                        request.setAttribute("tour", tour);
                        request.setAttribute("categories", tourDAO.getAllCategories());
                        request.setAttribute("destinations", tourDAO.getAllDestinations());
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
                    Tour tour = tourDAO.getTourDetails(id);
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

        List<Tour> tours = tourDAO.searchToursAdmin(search, status, categoryId, destinationId);
        List<Category> categories = tourDAO.getAllCategories();
        List<Destination> destinations = tourDAO.getAllDestinations();

        request.setAttribute("tours", tours);
        request.setAttribute("categories", categories);
        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedDestination", destinationId);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-tours.jsp").forward(request, response);
    }

    private void handleToursPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Account currentUser = (Account) request.getSession().getAttribute("user");
        
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                tourDAO.updateTourStatus(id, "Inactive");
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
                    tour.setCreatedBy(1);
                }

                boolean success;
                if ("update".equalsIgnoreCase(action)) {
                    success = tourDAO.updateTour(tour);
                    request.getSession().setAttribute(success ? "successMessage" : "errorMessage", 
                        success ? "Tour updated successfully!" : "Failed to update tour.");
                } else {
                    success = tourDAO.addTour(tour);
                    request.getSession().setAttribute(success ? "successMessage" : "errorMessage", 
                        success ? "Tour created successfully!" : "Failed to create tour.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Invalid input data.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/tours");
    }

    // ================== CATEGORIES ==================
    private void handleCategoriesGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("edit".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Category editCategory = categoryDAO.getCategoryById(id);
                if (editCategory != null) {
                    request.setAttribute("editCategory", editCategory);
                } else {
                    request.setAttribute("errorMessage", "Category not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Category ID!");
            }
        }

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }

    private void handleCategoriesPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equalsIgnoreCase(action)) {
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Category name is required!");
            } else {
                Category cat = new Category();
                cat.setCategoryName(categoryName.trim());
                if (description != null) {
                    cat.setDescription(description.trim());
                }
                if (categoryDAO.addCategory(cat)) {
                    request.getSession().setAttribute("successMessage", "Category created successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to create category. Please try again.");
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");

            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Category name is required!");
                reloadPageWithEditCategory(request, response, idParam);
                return;
            }

            try {
                int id = Integer.parseInt(idParam);
                Category category = new Category();
                category.setCategoryId(id);
                category.setCategoryName(categoryName.trim());
                if (description != null) {
                    category.setDescription(description.trim());
                }
                boolean success = categoryDAO.updateCategory(category);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Category updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Failed to update category. Please try again.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Category ID!");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                if (categoryDAO.deleteCategory(id)) {
                    request.getSession().setAttribute("successMessage", "Category deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete category. It might contain tours!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Category ID!");
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }

    private void reloadPageWithEditCategory(HttpServletRequest request, HttpServletResponse response, String idParam) 
            throws ServletException, IOException {
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Category editCategory = categoryDAO.getCategoryById(id);
                if (editCategory != null) {
                    request.setAttribute("editCategory", editCategory);
                }
            } catch (NumberFormatException e) {}
        }
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(request, response);
    }
}
