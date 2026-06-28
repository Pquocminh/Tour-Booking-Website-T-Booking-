package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import service.SystemSettingService;

@WebServlet(name = "AdminDiscountPolicyController", urlPatterns = {"/admin/discount-policies"})
public class AdminDiscountPolicyController extends HttpServlet {
    private final SystemSettingService settingService = new SystemSettingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Map<String, String> settings = settingService.getSettingsMap();
            request.setAttribute("settings", settings);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-discount-policies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updatePolicies".equalsIgnoreCase(action)) {
            String discountMinAmountParam = request.getParameter("discountMinAmount");
            String discountPercentParam = request.getParameter("discountPercent");
            String depositPercentParam = request.getParameter("depositPercent");
            String groupMinPeopleParam = request.getParameter("groupMinPeople");
            String groupDiscountPercentParam = request.getParameter("groupDiscountPercent");

            // Form validation
            double discountMinAmount;
            int discountPercent;
            int depositPercent;
            int groupMinPeople;
            int groupDiscountPercent;

            try {
                discountMinAmount = Double.parseDouble(discountMinAmountParam);
                if (discountMinAmount < 0) {
                    throw new IllegalArgumentException("Minimum order value cannot be negative!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for minimum order value!");
                reloadPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadPage(request, response);
                return;
            }

            try {
                discountPercent = Integer.parseInt(discountPercentParam);
                if (discountPercent < 0 || discountPercent > 100) {
                    throw new IllegalArgumentException("Discount percentage must be between 0 and 100!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for discount percentage!");
                reloadPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadPage(request, response);
                return;
            }

            try {
                depositPercent = Integer.parseInt(depositPercentParam);
                if (depositPercent <= 0 || depositPercent > 100) {
                    throw new IllegalArgumentException("Deposit percentage must be between 1 and 100!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for deposit percentage!");
                reloadPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadPage(request, response);
                return;
            }

            try {
                groupMinPeople = Integer.parseInt(groupMinPeopleParam);
                if (groupMinPeople < 1) {
                    throw new IllegalArgumentException("Minimum group size must be at least 1 person!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for group size!");
                reloadPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadPage(request, response);
                return;
            }

            try {
                groupDiscountPercent = Integer.parseInt(groupDiscountPercentParam);
                if (groupDiscountPercent < 0 || groupDiscountPercent > 100) {
                    throw new IllegalArgumentException("Group discount percentage must be between 0 and 100!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid format for group discount percentage!");
                reloadPage(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                reloadPage(request, response);
                return;
            }

            // Save settings
            Map<String, String> newSettings = new HashMap<>();
            newSettings.put("discount_min_amount", String.valueOf(discountMinAmount));
            newSettings.put("discount_percent", String.valueOf(discountPercent));
            newSettings.put("deposit_percent", String.valueOf(depositPercent));
            newSettings.put("group_min_people", String.valueOf(groupMinPeople));
            newSettings.put("group_discount_percent", String.valueOf(groupDiscountPercent));

            try {
                boolean success = settingService.updateSettings(newSettings);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Discount and Deposit Policies updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/discount-policies");
                } else {
                    request.setAttribute("errorMessage", "Failed to update some policies. Please try again.");
                    reloadPage(request, response);
                }
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                e.printStackTrace();
                reloadPage(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/discount-policies");
        }
    }

    private void reloadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Expose parameters that was submitted to allow simple re-fill
        Map<String, String> settings = new HashMap<>();
        settings.put("discount_min_amount", request.getParameter("discountMinAmount"));
        settings.put("discount_percent", request.getParameter("discountPercent"));
        settings.put("deposit_percent", request.getParameter("depositPercent"));
        settings.put("group_min_people", request.getParameter("groupMinPeople"));
        settings.put("group_discount_percent", request.getParameter("groupDiscountPercent"));

        request.setAttribute("settings", settings);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-discount-policies.jsp").forward(request, response);
    }
}
