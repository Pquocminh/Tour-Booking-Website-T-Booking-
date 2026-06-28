package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Promotion;
import model.Tour;
import service.PromotionService;
import service.TourService;

@WebServlet(name = "AdminPromotionController", urlPatterns = {"/admin/promotions"})
public class AdminPromotionController extends HttpServlet {
    private final PromotionService promotionService = new PromotionService();
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("view".equalsIgnoreCase(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Promotion promotion = promotionService.getPromotionById(id);
                if (promotion != null) {
                    List<Tour> tours = promotionService.getToursByPromotionId(id);
                    request.setAttribute("promotion", promotion);
                    request.setAttribute("tours", tours);
                    request.getRequestDispatcher("/WEB-INF/views/admin/promotion-details.jsp").forward(request, response);
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
                Promotion promotion = promotionService.getPromotionById(id);
                if (promotion != null) {
                    List<Tour> tours = tourService.getAvailableTours();
                    List<Tour> mappedTours = promotionService.getToursByPromotionId(id);
                    List<Integer> mappedTourIds = new ArrayList<>();
                    for (Tour t : mappedTours) {
                        mappedTourIds.add(t.getTourId());
                    }
                    request.setAttribute("promotion", promotion);
                    request.setAttribute("tours", tours);
                    request.setAttribute("mappedTourIds", mappedTourIds);
                    request.getRequestDispatcher("/WEB-INF/views/admin/edit-promotion.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Promotion not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Promotion ID!");
            }
        }

        // Default: list all promotions and active tours for creation form
        List<Promotion> promotions = promotionService.getAllPromotions();
        List<Tour> tours = tourService.getAvailableTours();
        request.setAttribute("promotions", promotions);
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-promotions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
                reloadDashboard(request, response);
                return;
            }

            int discountPercent;
            try {
                discountPercent = Integer.parseInt(discountParam);
                if (discountPercent <= 0 || discountPercent > 100) {
                    request.setAttribute("errorMessage", "Discount percent must be between 1 and 100!");
                    reloadDashboard(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid discount percent value!");
                reloadDashboard(request, response);
                return;
            }

            Date startDate;
            Date endDate;
            try {
                startDate = Date.valueOf(startDateParam);
                endDate = Date.valueOf(endDateParam);
                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
                    reloadDashboard(request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid date format! Expected YYYY-MM-DD.");
                reloadDashboard(request, response);
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
            boolean success = promotionService.addPromotion(p, tourIds);

            if (success) {
                request.getSession().setAttribute("successMessage", "Promotion created successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            } else {
                request.setAttribute("errorMessage", "Failed to create promotion. Please check inputs and try again.");
                reloadDashboard(request, response);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                boolean success = promotionService.deletePromotion(id);
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
                reloadEditPage(id, request, response);
                return;
            }

            int discountPercent;
            try {
                discountPercent = Integer.parseInt(discountParam);
                if (discountPercent <= 0 || discountPercent > 100) {
                    request.setAttribute("errorMessage", "Discount percent must be between 1 and 100!");
                    reloadEditPage(id, request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid discount percent value!");
                reloadEditPage(id, request, response);
                return;
            }

            Date startDate;
            Date endDate;
            try {
                startDate = Date.valueOf(startDateParam);
                endDate = Date.valueOf(endDateParam);
                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
                    reloadEditPage(id, request, response);
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid date format! Expected YYYY-MM-DD.");
                reloadEditPage(id, request, response);
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
            boolean success = promotionService.updatePromotion(p, tourIds);

            if (success) {
                request.getSession().setAttribute("successMessage", "Promotion updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            } else {
                request.setAttribute("errorMessage", "Failed to update promotion. Please check inputs and try again.");
                reloadEditPage(id, request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }

    private void reloadDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Promotion> promotions = promotionService.getAllPromotions();
        List<Tour> tours = tourService.getAvailableTours();
        request.setAttribute("promotions", promotions);
        request.setAttribute("tours", tours);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-promotions.jsp").forward(request, response);
    }

    private void reloadEditPage(int id, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Promotion promotion = promotionService.getPromotionById(id);
        if (promotion != null) {
            List<Tour> tours = tourService.getAvailableTours();
            List<Tour> mappedTours = promotionService.getToursByPromotionId(id);
            List<Integer> mappedTourIds = new ArrayList<>();
            for (Tour t : mappedTours) {
                mappedTourIds.add(t.getTourId());
            }
            request.setAttribute("promotion", promotion);
            request.setAttribute("tours", tours);
            request.setAttribute("mappedTourIds", mappedTourIds);
            request.getRequestDispatcher("/WEB-INF/views/admin/edit-promotion.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }
}
