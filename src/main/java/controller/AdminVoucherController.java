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

        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
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

            if (voucherCode == null || voucherCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Voucher code is required!");
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

                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
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
                
                if (voucherCode == null || voucherCode.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Voucher code is required!");
                    reloadVoucherEditPage(id, request, response);
                    return;
                }

                double discountPercent = Double.parseDouble(discountParam);
                double minOrder = Double.parseDouble(minOrderParam);
                double maxDiscount = Double.parseDouble(maxDiscountParam);
                int quantity = Integer.parseInt(quantityParam);
                Date startDate = Date.valueOf(startDateParam);
                Date endDate = Date.valueOf(endDateParam);

                if (startDate.after(endDate)) {
                    request.setAttribute("errorMessage", "Start date cannot be after end date!");
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
}
