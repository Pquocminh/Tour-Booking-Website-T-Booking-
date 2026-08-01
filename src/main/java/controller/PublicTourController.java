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
import dao.CategoryDAO;
import dao.DestinationDAO;

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
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final DestinationDAO destinationDAO = new DestinationDAO();

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
        String categoryParam = request.getParameter("category");
        String destinationParam = request.getParameter("destination");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String minDurationParam = request.getParameter("minDuration");
        String maxDurationParam = request.getParameter("maxDuration");
        String sortBy = request.getParameter("sortBy");

        List<String> filterErrors = new java.util.ArrayList<>();

        Integer categoryFilter = null;
        if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                categoryFilter = Integer.parseInt(categoryParam.trim());
            } catch (NumberFormatException e) {
                filterErrors.add("Invalid category selected.");
            }
        }

        Integer destinationFilter = null;
        if (destinationParam != null && !destinationParam.trim().isEmpty()) {
            try {
                destinationFilter = Integer.parseInt(destinationParam.trim());
            } catch (NumberFormatException e) {
                filterErrors.add("Invalid destination selected.");
            }
        }

        Double minPriceFilter = parseAndValidatePrice(minPriceParam, "Minimum price", filterErrors);
        Double maxPriceFilter = parseAndValidatePrice(maxPriceParam, "Maximum price", filterErrors);

        if (minPriceFilter != null && maxPriceFilter != null && minPriceFilter > maxPriceFilter) {
            filterErrors.add("Minimum price cannot be greater than maximum price.");
            minPriceFilter = null;
            maxPriceFilter = null;
        }

        Integer minDurationFilter = null;
        if (minDurationParam != null && !minDurationParam.trim().isEmpty()) {
            try {
                int parsedMinDur = Integer.parseInt(minDurationParam.trim());
                if (parsedMinDur < 1) {
                    filterErrors.add("Minimum duration must be at least 1 day.");
                } else {
                    minDurationFilter = parsedMinDur;
                }
            } catch (NumberFormatException e) {
                filterErrors.add("Minimum duration must be a valid integer value.");
            }
        }

        Integer maxDurationFilter = null;
        if (maxDurationParam != null && !maxDurationParam.trim().isEmpty()) {
            try {
                int parsedMaxDur = Integer.parseInt(maxDurationParam.trim());
                if (parsedMaxDur < 1) {
                    filterErrors.add("Maximum duration must be at least 1 day.");
                } else {
                    maxDurationFilter = parsedMaxDur;
                }
            } catch (NumberFormatException e) {
                filterErrors.add("Maximum duration must be a valid integer value.");
            }
        }

        if (minDurationFilter != null && maxDurationFilter != null && minDurationFilter > maxDurationFilter) {
            filterErrors.add("Minimum duration cannot be greater than maximum duration.");
            minDurationFilter = null;
            maxDurationFilter = null;
        }

        if (searchKeyword != null) searchKeyword = searchKeyword.trim();
        if (searchKeyword != null && searchKeyword.isEmpty()) searchKeyword = null;

        List<Tour> rawTours = tourDAO.filterTours(
                searchKeyword,
                categoryFilter,
                destinationFilter,
                minPriceFilter,
                maxPriceFilter,
                minDurationFilter,
                maxDurationFilter,
                sortBy
        );

        boolean hasActiveFilters = (searchKeyword != null) || (categoryFilter != null) || (destinationFilter != null)
                || (minPriceFilter != null) || (maxPriceFilter != null)
                || (minDurationFilter != null) || (maxDurationFilter != null)
                || (sortBy != null && !sortBy.trim().isEmpty() && !"newest".equalsIgnoreCase(sortBy.trim()));

        if (!hasActiveFilters && rawTours != null) {
            rawTours.sort((t1, t2) -> {
                int diff = Integer.compare(t2.getDiscountPercent(), t1.getDiscountPercent());
                if (diff != 0) return diff;
                return Integer.compare(t2.getTourId(), t1.getTourId());
            });
        }

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 9; // 9 tours per page for 3x3 grid layout

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
            if (hasActiveFilters) {
                request.setAttribute("message", "No tours found matching your selected filter criteria.");
            } else {
                request.setAttribute("message", "Currently, there aren't any tours being sold.");
            }
        }

        request.setAttribute("tours", pagedTours);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTours", totalTours);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("hasActiveFilters", hasActiveFilters);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("categoryFilter", categoryFilter);
        request.setAttribute("destinationFilter", destinationFilter);
        request.setAttribute("minPriceFilter", minPriceFilter);
        request.setAttribute("maxPriceFilter", maxPriceFilter);
        request.setAttribute("minDurationFilter", minDurationFilter);
        request.setAttribute("maxDurationFilter", maxDurationFilter);
        request.setAttribute("sortByFilter", sortBy);

        request.setAttribute("filterErrors", filterErrors);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("destinations", destinationDAO.getAllDestinations());
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

    private Double parseAndValidatePrice(String priceParam, String fieldName, List<String> errors) {
        if (priceParam == null || priceParam.trim().isEmpty()) {
            return null;
        }
        String trimmed = priceParam.trim();

        boolean hasComma = trimmed.contains(",");
        boolean hasDot = trimmed.contains(".");

        if (hasComma) {
            if (!trimmed.matches("^\\d{1,3}(,\\d{3})+$")) {
                errors.add(fieldName + ": If comma is used, it must be followed by exactly 3 digits (e.g. 1,000 or 1,234).");
                return null;
            }
        } else if (hasDot) {
            if (!trimmed.matches("^\\d{1,3}(\\.\\d{3})+$")) {
                errors.add(fieldName + ": If dot separator is used, it must be followed by exactly 3 digits (e.g. 1.000 or 1.234).");
                return null;
            }
        } else {
            if (!trimmed.matches("^\\d+$")) {
                errors.add(fieldName + " must be a valid positive number.");
                return null;
            }
        }

        try {
            String cleanVal = trimmed.replace(",", "").replace(".", "");
            double parsed = Double.parseDouble(cleanVal);
            if (parsed < 1000) {
                errors.add(fieldName + " must be at least 1,000 VND.");
                return null;
            }
            return parsed;
        } catch (NumberFormatException e) {
            errors.add(fieldName + " must be a valid numeric value.");
            return null;
        }
    }
}
