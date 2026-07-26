package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

import model.Voucher;
import dao.VoucherDAO;

@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/vouchers"})
public class AdminVoucherController extends HttpServlet {
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("detail".equalsIgnoreCase(action) && idParam != null) {
            model.Account user = (model.Account) request.getSession().getAttribute("user");
            if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
                request.getSession().setAttribute("errorMessage", "Access Denied.");
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                return;
            }
            try {
                int id = Integer.parseInt(idParam);
                Voucher voucher = voucherDAO.getVoucherById(id);
                if (voucher != null) {
                    request.setAttribute("voucher", voucher);
                    request.getRequestDispatcher("/WEB-INF/views/admin/voucher-detail.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Voucher not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Voucher ID!");
            }
        }

        if ("edit".equalsIgnoreCase(action) && idParam != null) {
            model.Account user = (model.Account) request.getSession().getAttribute("user");
            if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
                request.getSession().setAttribute("errorMessage", "Access Denied: Only Admin can edit vouchers.");
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                return;
            }
            try {
                int id = Integer.parseInt(idParam);
                Voucher voucher = voucherDAO.getVoucherById(id);
                if (voucher != null) {
                    request.setAttribute("voucher", voucher);
                    request.getRequestDispatcher("/WEB-INF/views/admin/voucher-edit.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Voucher not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Voucher ID!");
            }
        }

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 vouchers per page

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

        List<Voucher> allVouchers = voucherDAO.getAllVouchers();
        int totalVouchers = (allVouchers != null) ? allVouchers.size() : 0;
        int totalPages = (int) Math.ceil((double) totalVouchers / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalVouchers);
        List<Voucher> vouchers = (allVouchers != null && fromIndex < totalVouchers)
                ? allVouchers.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalVouchers", totalVouchers);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/WEB-INF/views/admin/vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        model.Account user = (model.Account) request.getSession().getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            request.getSession().setAttribute("errorMessage", "Access Denied: Only Admin can create, update, or delete vouchers.");
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            return;
        }

        if ("create".equalsIgnoreCase(action)) {
            String voucherCode = request.getParameter("voucherCode");
            String discountParam = request.getParameter("discountPercent");
            String minOrderParam = request.getParameter("minimumOrderValue");
            String maxDiscountParam = request.getParameter("maxDiscountAmount");
            String quantityParam = request.getParameter("quantity");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            String status = request.getParameter("status");

            if (voucherCode == null || voucherCode.trim().length() < 6) {
                request.setAttribute("errorMessage", "Voucher code must be at least 6 characters long!");
                reloadVouchersDashboard(request, response);
                return;
            }

            try {
                double discountPercent = Double.parseDouble(discountParam);
                double minOrder = Double.parseDouble(minOrderParam);
                double maxDiscount = Double.parseDouble(maxDiscountParam);
                int quantity = Integer.parseInt(quantityParam);
                Date startDate = Date.valueOf(startDateParam);
                Date endDate = Date.valueOf(endDateParam);

                String validationError = validateVoucherInput(discountPercent, minOrder, maxDiscount, quantity, startDate, endDate);
                if (validationError != null) {
                    request.setAttribute("errorMessage", validationError);
                    reloadVouchersDashboard(request, response);
                    return;
                }

                if (status == null || (!"Active".equalsIgnoreCase(status) && !"Inactive".equalsIgnoreCase(status))) {
                    status = "Active";
                }

                Voucher v = new Voucher(0, voucherCode.toUpperCase(), discountPercent, minOrder, maxDiscount, quantity, startDate, endDate, status);
                boolean success = voucherDAO.addVoucher(v);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Voucher created successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                } else {
                    request.setAttribute("errorMessage", "Failed to create voucher. The code might already exist.");
                    reloadVouchersDashboard(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Invalid input format. Please check your numbers and dates.");
                reloadVouchersDashboard(request, response);
            }

        } else if ("delete".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            try {
                int id = Integer.parseInt(idParam);
                boolean success = voucherDAO.deleteVoucher(id);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Voucher deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete voucher.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Voucher ID for deletion.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");

        } else if ("update".equalsIgnoreCase(action)) {
            String idParam = request.getParameter("id");
            String voucherCode = request.getParameter("voucherCode");
            String discountParam = request.getParameter("discountPercent");
            String minOrderParam = request.getParameter("minimumOrderValue");
            String maxDiscountParam = request.getParameter("maxDiscountAmount");
            String quantityParam = request.getParameter("quantity");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            String status = request.getParameter("status");

            try {
                int id = Integer.parseInt(idParam);
                
                if (voucherCode == null || voucherCode.trim().length() < 6) {
                    request.setAttribute("errorMessage", "Voucher code must be at least 6 characters long!");
                    reloadVoucherEditPage(id, request, response);
                    return;
                }

                double discountPercent = Double.parseDouble(discountParam);
                double minOrder = Double.parseDouble(minOrderParam);
                double maxDiscount = Double.parseDouble(maxDiscountParam);
                int quantity = Integer.parseInt(quantityParam);
                Date startDate = Date.valueOf(startDateParam);
                Date endDate = Date.valueOf(endDateParam);

                String validationError = validateVoucherInput(discountPercent, minOrder, maxDiscount, quantity, startDate, endDate);
                if (validationError != null) {
                    request.setAttribute("errorMessage", validationError);
                    reloadVoucherEditPage(id, request, response);
                    return;
                }

                if (status == null || (!"Active".equalsIgnoreCase(status) && !"Inactive".equalsIgnoreCase(status))) {
                    status = "Active";
                }

                Voucher v = new Voucher(id, voucherCode.toUpperCase(), discountPercent, minOrder, maxDiscount, quantity, startDate, endDate, status);
                boolean success = voucherDAO.updateVoucher(v);

                if (success) {
                    request.getSession().setAttribute("successMessage", "Voucher updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin/vouchers");
                } else {
                    request.setAttribute("errorMessage", "Failed to update voucher. The code might already exist.");
                    reloadVoucherEditPage(id, request, response);
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Invalid input format!");
                response.sendRedirect(request.getContextPath() + "/admin/vouchers");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
        }
    }

    private void reloadVouchersDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/views/admin/vouchers.jsp").forward(request, response);
    }

    private void reloadVoucherEditPage(int id, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Voucher voucher = voucherDAO.getVoucherById(id);
        if (voucher != null) {
            request.setAttribute("voucher", voucher);
            request.getRequestDispatcher("/WEB-INF/views/admin/voucher-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
        }
    }

    private String validateVoucherInput(double discountPercent, double minOrder, double maxDiscount, int quantity, Date startDate, Date endDate) {
        if (discountPercent <= 0 || discountPercent > 100) {
            return "Discount percentage must be between 1 and 100!";
        }
        if (minOrder < 0 || maxDiscount < 0) {
            return "Minimum Order Value and Max Discount Amount must be greater than or equal to 0!";
        }
        if (maxDiscount > 0 && minOrder > maxDiscount) {
            return "Minimum Order Value cannot be greater than Max Discount Amount!";
        }
        if (quantity <= 0) {
            return "Quantity must be greater than 0!";
        }
        if (startDate.after(endDate)) {
            return "Start Date must be before or equal to End Date";
        }
        return null;
    }
}
