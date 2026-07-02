package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import model.Account;
import dao.AccountDAO;

@WebServlet(name = "AdminAccountController", urlPatterns = {"/admin/accounts"})
public class AdminAccountController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Defaults to "All" if empty
        if (role == null) {
            role = "All";
        }
        if (status == null) {
            status = "All";
        }

        List<Account> accounts = accountDAO.getAllAccounts(search, role, status);

        request.setAttribute("accounts", accounts);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("selectedRole", role);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-accounts.jsp").forward(request, response);
    }
}
