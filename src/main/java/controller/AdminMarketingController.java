package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Promotion;
import model.Tour;
import model.SystemSetting;
import dao.PromotionDAO;
import dao.SystemSettingDAO;
import dao.TourDAO;

@WebServlet(name = "AdminMarketingController", urlPatterns = {"/admin/promotions", "/admin/discount-policies"})
public class AdminMarketingController extends HttpServlet {
    private final PromotionDAO promotionDAO = new PromotionDAO();
    private final TourDAO tourDAO = new TourDAO();
    private final SystemSettingDAO settingDAO = new SystemSettingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/promotions".equals(path)) {
            handlePromotionsGet(request, response);
        } else if ("/admin/discount-policies".equals(path)) {
            handleDiscountPoliciesGet(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/promotions".equals(path)) {
            handlePromotionsPost(request, response);
        } else if ("/admin/discount-policies".equals(path)) {
            handleDiscountPoliciesPost(request, response);
        }
    }

    // ================== PROMOTIONS ==================
    private void handlePromotionsGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("view".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Promotion promotion = promotionDAO.getPromotionById(id);
                if (promotion != null) {
                    List<Tour> tours = promotionDAO.getToursByPromotionId(id);
                    request.setAttribute("promotion", promotion);
                    request.setAttribute("tours", tours);
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotion-detail.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Promotion not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Promotion ID!");
            }
        } else if ("edit".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Promotion promotion = promotionDAO.getPromotionById(id);
                if (promotion != null) {
                    List<Tour> tours = tourDAO.getAvailableTours();
                    List<Tour> mappedTours = promotionDAO.getToursByPromotionId(id);
                    List<Integer> mappedTourIds = new ArrayList<>();
                    for (Tour t : mappedTours) {
                        mappedTourIds.add(t.getTourId());
                    }
                    request.setAttribute("promotion", promotion);
                    request.setAttribute("tours", tours);
                    request.setAttribute("mappedTourIds", mappedTourIds);
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotion-edit.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Promotion not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Promotion ID!");
            }
        }

        List<Promotion> promotions = promotionDAO.getAllPromotions();
        List<Tour> tours = tourDAO.getAvailableTours();
        request.setAttribute("promotions", promotions);
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/admin/promotions.jsp").forward(request, response);
    }

    private void handlePromotionsPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String promotionName = request.getParameter("promotionName");
            String discountParam = request.getParameter("discountPercent");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            String status = request.getParameter("status");
            String[] tourIdsParam = request.getParameterValues("tourIds");

            if (promotionName == null || promotionName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Promotion name is required!");
                reloadPromotionsDashboard(request, response);
                return;
            }

            int discountPercent;
            try {
                discountPercent = Integer.parseInt(discountParam);
                if (discountPercent <= 0 || discountPercent > 100) {
                    request.setAttribute("errorMessage", "Discount percent must be between 1 and 100!");
                    reloadPromotionsDashboard(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid discount percent value!");
                reloadPromotionsDashboard(request, response);
                return;
            }

            Date startDate;
            Date endDate;
            try {
                startDate = Date.valueOf(startDateParam);
                endDate = Date.valueOf(endDateParam);
                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
                    reloadPromotionsDashboard(request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid date format! Expected YYYY-MM-DD.");
                reloadPromotionsDashboard(request, response);
                return;
            }

            if (status == null || (!"Active".equalsIgnoreCase(status) && !"Inactive".equalsIgnoreCase(status))) {
                status = "Active";
            }

            List<Integer> tourIds = new ArrayList<>();
            if (tourIdsParam != null) {
                for (String tIdStr : tourIdsParam) {
                    try {
                        tourIds.add(Integer.parseInt(tIdStr));
                    } catch (NumberFormatException e) {}
                }
            }

            Promotion p = new Promotion(0, promotionName, discountPercent, startDate, endDate, status);
            boolean success = promotionDAO.addPromotion(p, tourIds);

            if (success) {
                request.getSession().setAttribute("successMessage", "Promotion created successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            } else {
                request.setAttribute("errorMessage", "Failed to create promotion. Please check inputs and try again.");
                reloadPromotionsDashboard(request, response);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                boolean success = promotionDAO.deletePromotion(id);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Promotion deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete promotion.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Promotion ID for deletion.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        } else if ("update".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            String promotionName = request.getParameter("promotionName");
            String discountParam = request.getParameter("discountPercent");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            String status = request.getParameter("status");
            String[] tourIdsParam = request.getParameterValues("tourIds");

            int id;
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Promotion ID!");
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
                return;
            }

            if (promotionName == null || promotionName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Promotion name is required!");
                reloadPromotionEditPage(id, request, response);
                return;
            }

            int discountPercent;
            try {
                discountPercent = Integer.parseInt(discountParam);
                if (discountPercent <= 0 || discountPercent > 100) {
                    request.setAttribute("errorMessage", "Discount percent must be between 1 and 100!");
                    reloadPromotionEditPage(id, request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid discount percent value!");
                reloadPromotionEditPage(id, request, response);
                return;
            }

            Date startDate;
            Date endDate;
            try {
                startDate = Date.valueOf(startDateParam);
                endDate = Date.valueOf(endDateParam);
                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
                    reloadPromotionEditPage(id, request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid date format! Expected YYYY-MM-DD.");
                reloadPromotionEditPage(id, request, response);
                return;
            }

            if (status == null || (!"Active".equalsIgnoreCase(status) && !"Inactive".equalsIgnoreCase(status))) {
                status = "Active";
            }

            List<Integer> tourIds = new ArrayList<>();
            if (tourIdsParam != null) {
                for (String tIdStr : tourIdsParam) {
                    try {
                        tourIds.add(Integer.parseInt(tIdStr));
                    } catch (NumberFormatException e) {}
                }
            }

            Promotion p = new Promotion(id, promotionName, discountPercent, startDate, endDate, status);
            boolean success = promotionDAO.updatePromotion(p, tourIds);

            if (success) {
                request.getSession().setAttribute("successMessage", "Promotion updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            } else {
                request.setAttribute("errorMessage", "Failed to update promotion. Please check inputs and try again.");
                reloadPromotionEditPage(id, request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }

    private void reloadPromotionsDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Promotion> promotions = promotionDAO.getAllPromotions();
        List<Tour> tours = tourDAO.getAvailableTours();
        request.setAttribute("promotions", promotions);
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/admin/promotions.jsp").forward(request, response);
    }

    private void reloadPromotionEditPage(int id, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Promotion promotion = promotionDAO.getPromotionById(id);
        if (promotion != null) {
            List<Tour> tours = tourDAO.getAvailableTours();
            List<Tour> mappedTours = promotionDAO.getToursByPromotionId(id);
            List<Integer> mappedTourIds = new ArrayList<>();
            for (Tour t : mappedTours) {
                mappedTourIds.add(t.getTourId());
            }
            request.setAttribute("promotion", promotion);
            request.setAttribute("tours", tours);
            request.setAttribute("mappedTourIds", mappedTourIds);
            request.getRequestDispatcher("/WEB-INF/views/admin/promotion-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }

    // ================== DISCOUNT POLICIES ==================
    private void handleDiscountPoliciesGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<SystemSetting> list = settingDAO.getAllSettings();
            Map<String, String> settings = new HashMap<>();
            for (SystemSetting s : list) {
                settings.put(s.getSettingKey(), s.getSettingValue());
            }
            request.setAttribute("settings", settings);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/discount-policies.jsp").forward(request, response);
    }

    private void handleDiscountPoliciesPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updatePolicies".equalsIgnoreCase(action)) {
            String depositPercentParam = request.getParameter("depositPercent");
            String bookingWindowDaysParam = request.getParameter("bookingWindowDays");
            String cancellationWindowDaysParam = request.getParameter("cancellationWindowDays");

            int depositPercent;
            int bookingWindowDays;
            int cancellationWindowDays;

            try {
                depositPercent = Integer.parseInt(depositPercentParam);
                bookingWindowDays = Integer.parseInt(bookingWindowDaysParam);
                cancellationWindowDays = Integer.parseInt(cancellationWindowDaysParam);
                
                if (depositPercent <= 0 || depositPercent > 100) {
                    throw new IllegalArgumentException("Deposit percentage must be between 1 and 100!");
                }
                if (bookingWindowDays < 0) {
                    throw new IllegalArgumentException("Booking window days cannot be negative!");
                }
                if (cancellationWindowDays < 0) {
                    throw new IllegalArgumentException("Cancellation window days cannot be negative!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for one or more policies!");
                reloadDiscountPoliciesPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadDiscountPoliciesPage(request, response);
                return;
            }

            Map<String, String> newSettings = new HashMap<>();
            newSettings.put("deposit_percent", String.valueOf(depositPercent));
            newSettings.put("booking_window_days", String.valueOf(bookingWindowDays));
            newSettings.put("cancellation_window_days", String.valueOf(cancellationWindowDays));

            try {
                boolean success = true;
                for (Map.Entry<String, String> entry : newSettings.entrySet()) {
                    if (!settingDAO.updateSetting(entry.getKey(), entry.getValue())) {
                        success = false;
                    }
                }
                if (success) {
                    request.getSession().setAttribute("successMessage", "Global Policies updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/discount-policies");
                } else {
                    request.setAttribute("errorMessage", "Failed to update some policies. Please try again.");
                    reloadDiscountPoliciesPage(request, response);
                }
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                e.printStackTrace();
                reloadDiscountPoliciesPage(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/discount-policies");
        }
    }

    private void reloadDiscountPoliciesPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> settings = new HashMap<>();
        settings.put("deposit_percent", request.getParameter("depositPercent"));
        settings.put("booking_window_days", request.getParameter("bookingWindowDays"));
        settings.put("cancellation_window_days", request.getParameter("cancellationWindowDays"));

        request.setAttribute("settings", settings);
        request.getRequestDispatcher("/WEB-INF/views/admin/discount-policies.jsp").forward(request, response);
    }
}

