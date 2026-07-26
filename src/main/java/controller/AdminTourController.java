package controller;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import model.Account;
import model.Booking;
import model.Category;
import model.Destination;
import model.Tour;
import dao.CategoryDAO;
import dao.TourDAO;

@WebServlet(name = "AdminTourController", urlPatterns = {"/admin/dashboard", "/admin/tours", "/admin/categories"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
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
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("Staff".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/staff/schedules");
            return;
        }
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
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
            request.getRequestDispatcher("/WEB-INF/views/admin/tour-edit.jsp").forward(request, response);
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
                        request.getRequestDispatcher("/WEB-INF/views/admin/tour-edit.jsp").forward(request, response);
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
                        request.getRequestDispatcher("/WEB-INF/views/admin/tour-detail.jsp").forward(request, response);
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

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 tours per page as requested

        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int parsedSize = Integer.parseInt(pageSizeParam.trim());
                if (parsedSize > 0) {
                    pageSize = parsedSize;
                }
            } catch (NumberFormatException e) {}
        }

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        List<Tour> allTours = tourDAO.searchToursAdmin(search, status, categoryId, destinationId);
        int totalTours = (allTours != null) ? allTours.size() : 0;
        int totalPages = (int) Math.ceil((double) totalTours / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalTours);
        List<Tour> tours = (allTours != null && fromIndex < totalTours)
                ? allTours.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        List<Category> categories = tourDAO.getAllCategories();
        List<Destination> destinations = tourDAO.getAllDestinations();

        java.util.List<Integer> tourIds = new java.util.ArrayList<>();
        if (tours != null) {
            for (Tour t : tours) {
                tourIds.add(t.getTourId());
            }
        }
        java.util.Set<Integer> schedTourIds = tourDAO.getTourIdsWithSchedules(tourIds);
        java.util.Map<Integer, Boolean> tourHasSchedules = new java.util.HashMap<>();
        if (tours != null) {
            for (Tour t : tours) {
                tourHasSchedules.put(t.getTourId(), schedTourIds.contains(t.getTourId()));
            }
        }

        request.setAttribute("tourHasSchedules", tourHasSchedules);
        request.setAttribute("tours", tours);
        request.setAttribute("categories", categories);
        request.setAttribute("destinations", destinations);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedDestination", destinationId);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTours", totalTours);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/views/admin/tours.jsp").forward(request, response);
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
                String durationParam = request.getParameter("durationDays");
                int duration = 1;
                if ("update".equalsIgnoreCase(action)) {
                    Tour existing = tourDAO.getTourByIdAdmin(tour.getTourId());
                    if (existing != null && existing.getDurationDays() > 0) {
                        duration = existing.getDurationDays();
                    }
                }
                if (durationParam != null && !durationParam.trim().isEmpty()) {
                    try {
                        duration = Integer.parseInt(durationParam.trim());
                    } catch (NumberFormatException e) {}
                }
                tour.setDurationDays(duration);
                String basePriceParam = request.getParameter("basePrice");
                double basePrice = 0.0;
                if ("update".equalsIgnoreCase(action)) {
                    Tour existing = tourDAO.getTourByIdAdmin(tour.getTourId());
                    if (existing != null) {
                        basePrice = existing.getBasePrice();
                    }
                }
                if (basePriceParam != null && !basePriceParam.trim().isEmpty()) {
                    try {
                        String cleanPrice = basePriceParam.trim().replaceAll("[,\\s]", "");
                        basePrice = Double.parseDouble(cleanPrice);
                    } catch (NumberFormatException e) {}
                }
                if (basePrice <= 0) {
                    request.getSession().setAttribute("errorMessage", "Starting price must be a positive number");
                    if ("update".equalsIgnoreCase(action)) {
                        response.sendRedirect(request.getContextPath() + "/admin/tours?action=edit&id=" + tour.getTourId());
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/tours?action=create");
                    }
                    return;
                }
                tour.setBasePrice(basePrice);
                tour.setStatus(request.getParameter("status"));
                String thumbnailUrl = request.getParameter("existingThumbnailUrl");
                if (thumbnailUrl == null) {
                    thumbnailUrl = request.getParameter("thumbnailUrl");
                }
                
                try {
                    Part filePart = request.getPart("thumbnailFile");
                    if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String cleanName = fileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
                        String uniqueFileName = "tour_" + System.currentTimeMillis() + "_" + cleanName;
                        
                        String relPath = "/assets/images/tours";
                        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "tours";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        File targetFile = new File(uploadDir, uniqueFileName);
                        filePart.write(targetFile.getAbsolutePath());
                        
                        try {
                            String srcPath = "D:" + File.separator + "HocTap" + File.separator + "SWP" + File.separator + "Tour-Booking-Website-T-Booking-" + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "assets" + File.separator + "images" + File.separator + "tours";
                            File srcDir = new File(srcPath);
                            if (srcDir.exists() || srcDir.mkdirs()) {
                                Files.copy(targetFile.toPath(), new File(srcDir, uniqueFileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                            }
                        } catch (Exception exSrc) {
                            // ignore if source folder not writable or accessible
                        }
                        
                        thumbnailUrl = relPath + "/" + uniqueFileName;
                    }
                } catch (Exception exPart) {
                    // ignore if request was not multipart or part not found
                }
                tour.setThumbnailUrl(thumbnailUrl);
                
                if (currentUser != null) {
                    tour.setCreatedBy(currentUser.getAccountId());
                } else {
                    tour.setCreatedBy(1);
                }

                boolean success;
                if ("update".equalsIgnoreCase(action)) {
                    success = tourDAO.updateTour(tour);
                    if (success) {
                        tourDAO.syncTourBasePriceFromSchedules(tour.getTourId());
                    }
                    request.getSession().setAttribute(success ? "successMessage" : "errorMessage", 
                        success ? "Tour updated successfully!" : "Failed to update tour.");
                } else {
                    success = tourDAO.addTour(tour);
                    if (success) {
                        tourDAO.syncTourBasePriceFromSchedules(tour.getTourId());
                    }
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

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 categories per page

        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int parsedSize = Integer.parseInt(pageSizeParam.trim());
                if (parsedSize > 0) {
                    pageSize = parsedSize;
                }
            } catch (NumberFormatException e) {}
        }

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        List<Category> allCategories = categoryDAO.getAllCategories();
        int totalCategories = (allCategories != null) ? allCategories.size() : 0;
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalCategories);
        List<Category> categories = (allCategories != null && fromIndex < totalCategories)
                ? allCategories.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
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
            if (categoryName == null || categoryName.trim().length() < 3) {
                request.setAttribute("errorMessage", "Category name must be at least 3 characters long!");
            } else if (description == null || description.trim().length() < 3) {
                request.setAttribute("errorMessage", "Category description must be at least 3 characters long!");
            } else {
                Category cat = new Category();
                cat.setCategoryName(categoryName.trim());
                cat.setDescription(description.trim());
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

            if (categoryName == null || categoryName.trim().length() < 3) {
                request.setAttribute("errorMessage", "Category name must be at least 3 characters long!");
                reloadPageWithEditCategory(request, response, idParam);
                return;
            }
            if (description == null || description.trim().length() < 3) {
                request.setAttribute("errorMessage", "Category description must be at least 3 characters long!");
                reloadPageWithEditCategory(request, response, idParam);
                return;
            }

            try {
                int id = Integer.parseInt(idParam);
                Category category = new Category();
                category.setCategoryId(id);
                category.setCategoryName(categoryName.trim());
                category.setDescription(description.trim());
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
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
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
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }
}

