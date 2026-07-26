package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import dao.WishlistDAO;

import model.Tour;
import dao.PromotionDAO;
import model.Promotion;
import model.Review;
import dao.ReviewDAO;
import dao.TourDAO;

@WebServlet(name = "PublicTourController", urlPatterns = {"/tours", "/tour-detail"})
public class PublicTourController extends HttpServlet {
    private final TourDAO tourDAO = new TourDAO();
    private final PromotionDAO promotionDAO = new PromotionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String path = request.getServletPath();
        
        if ("/tour-detail".equals(path)) {
            viewTourDetail(request, response);
        } else if ("/tours".equals(path)) {
            handlePublicTourList(request, response);
        }
    }
    
    private void handlePublicTourList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchKeyword = request.getParameter("search");
        String categoryFilter = request.getParameter("category");
        String destinationFilter = request.getParameter("destination");

        List<Tour> rawTours;
        boolean isSearchResult = false;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            rawTours = tourDAO.searchTours(searchKeyword.trim());
            request.setAttribute("searchKeyword", searchKeyword.trim());
            isSearchResult = true;
        } else if (categoryFilter != null && !categoryFilter.isEmpty()) {
            try {
                int catId = Integer.parseInt(categoryFilter.trim());
                rawTours = tourDAO.searchToursByCategory(catId);
                request.setAttribute("categoryFilter", catId);
            } catch (NumberFormatException e) {
                rawTours = tourDAO.getAvailableTours();
            }
        } else if (destinationFilter != null && !destinationFilter.isEmpty()) {
            try {
                int destId = Integer.parseInt(destinationFilter.trim());
                rawTours = tourDAO.searchToursByDestination(destId);
                request.setAttribute("destinationFilter", destId);
            } catch (NumberFormatException e) {
                rawTours = tourDAO.getAvailableTours();
            }
        } else {
            rawTours = tourDAO.getAvailableTours();
        }

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 tours per page for guests and customers

        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int parsedSize = Integer.parseInt(pageSizeParam.trim());
                if (parsedSize > 0) pageSize = parsedSize;
            } catch (NumberFormatException e) {}
        }

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalTours = (rawTours != null) ? rawTours.size() : 0;
        int totalPages = (int) Math.ceil((double) totalTours / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalTours);
        List<Tour> pagedTours = (rawTours != null && fromIndex < totalTours)
                ? rawTours.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        if (totalTours == 0) {
            if (isSearchResult) {
                request.setAttribute("message", "No tours found matching your search.");
            } else {
                request.setAttribute("message", "Currently, there aren't any tours being sold.");
            }
        }

        request.setAttribute("tours", pagedTours);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTours", totalTours);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("isSearchResult", isSearchResult);
        request.setAttribute("activePromotions", promotionDAO.getActivePromotions());

        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void viewTourDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        try {
            int tourId = Integer.parseInt(idParam);
            Tour tour = tourDAO.getTourDetails(tourId);
            if (tour == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }
            
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getVisibleReviewsByTourId(tourId);
            request.setAttribute("reviews", reviews);

            double averageRating = 0;
            if (!reviews.isEmpty()) {
                int totalStars = 0;
                for (Review r : reviews) {
                    totalStars += r.getRating();
                }
                averageRating = (double) totalStars / reviews.size();
            }
            request.setAttribute("averageRating", averageRating);

            request.setAttribute("tour", tour);

            // Get cancellation window days and calculate non-refundable schedules
            dao.SystemSettingDAO sysDao = new dao.SystemSettingDAO();
            int cancellationWindowDays = 7;
            try {
                String cancelWindowStr = sysDao.getSettingValueByKey("cancellation_window_days");
                if (cancelWindowStr != null && !cancelWindowStr.trim().isEmpty()) {
                    cancellationWindowDays = Integer.parseInt(cancelWindowStr);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            java.util.Map<Integer, Boolean> scheduleRefundableMap = new java.util.HashMap<>();
            if (tour.getSchedules() != null) {
                java.time.LocalDate today = java.time.LocalDate.now();
                for (model.TourSchedule sch : tour.getSchedules()) {
                    if (sch.getDepartureDate() != null) {
                        java.time.LocalDate departureDate = sch.getDepartureDate().toLocalDate();
                        long daysUntilDeparture = java.time.temporal.ChronoUnit.DAYS.between(today, departureDate);
                        boolean isNonRefundable = daysUntilDeparture < cancellationWindowDays;
                        scheduleRefundableMap.put(sch.getScheduleId(), isNonRefundable);
                    }
                }
            }
            request.setAttribute("cancellationWindowDays", cancellationWindowDays);
            request.setAttribute("scheduleRefundableMap", scheduleRefundableMap);

            HttpSession session = request.getSession(false);
            boolean isInWishlist = false;
            if (session != null) {
                model.Account user = (model.Account) session.getAttribute("user");
                if (user != null) {
                    WishlistDAO wishlistDAO = new WishlistDAO();
                    isInWishlist = wishlistDAO.isInWishlist(user.getAccountId(), tourId);
                }
            }
            request.setAttribute("isInWishlist", isInWishlist);

            request.getRequestDispatcher("/WEB-INF/views/guest/tour-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }
}
