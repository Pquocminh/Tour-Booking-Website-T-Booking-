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

        String action = request.getParameter("action");
        if ("view".equalsIgnoreCase(action)) {
            handleAccountDetailGet(request, response);
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

        request.getRequestDispatcher("/WEB-INF/views/admin/accounts.jsp").forward(request, response);
    }

    private void handleAccountDetailGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Missing account ID.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Account account = accountDAO.getAccountById(id);
            if (account == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            request.setAttribute("account", account);
            request.getRequestDispatcher("/WEB-INF/views/admin/account-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid account ID format.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        switch (action.toLowerCase()) {
            case "create":
                handleAccountCreatePost(request, response);
                break;
            case "update":
                handleAccountUpdatePost(request, response);
                break;
            case "delete":
                handleAccountDeletePost(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                break;
        }
    }

    private void handleAccountCreatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String password = request.getParameter("password");

        // Input validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Required fields are missing.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Check if username already exists
        if (accountDAO.getAccountByUsernameOrEmail(username) != null) {
            session.setAttribute("errorMessage", "Username is already taken.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Check if email already exists
        if (accountDAO.getAccountByEmail(email) != null) {
            session.setAttribute("errorMessage", "Email is already in use.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Encrypt password using utils.PasswordUtils
        String passwordHash = utils.PasswordUtils.hashMD5(password);

        Account acc = new Account();
        acc.setUsername(username.trim());
        acc.setPasswordHash(passwordHash);
        acc.setEmail(email.trim());
        acc.setFullName(fullName != null ? fullName.trim() : "");
        acc.setPhone(phone != null ? phone.trim() : "");
        acc.setAddress(address != null ? address.trim() : "");
        acc.setRole(role.trim());
        acc.setStatus(status.trim());
        acc.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

        boolean success = accountDAO.insertAccount(acc);
        if (success) {
            session.setAttribute("successMessage", "Account created successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to create account due to a database error.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }

    private void handleAccountUpdatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Required fields are missing.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Account existingAcc = accountDAO.getAccountById(id);
            if (existingAcc == null) {
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Check if email belongs to someone else
            if (accountDAO.checkEmailExistsForOtherAccount(email, id)) {
                session.setAttribute("errorMessage", "Email is already in use by another account.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Update password optionally if provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                String passwordHash = utils.PasswordUtils.hashMD5(password);
                accountDAO.updatePasswordById(id, passwordHash);
            }

            Account acc = new Account();
            acc.setAccountId(id);
            acc.setEmail(email.trim());
            acc.setFullName(fullName != null ? fullName.trim() : "");
            acc.setPhone(phone != null ? phone.trim() : "");
            acc.setAddress(address != null ? address.trim() : "");
            acc.setRole(role.trim());
            acc.setStatus(status.trim());

            boolean success = accountDAO.updateAccount(acc);
            if (success) {
                session.setAttribute("successMessage", "Account updated successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update account due to a database error.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid account ID format.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }

    /**
     * Handles account deletion requests via POST.
     * Sequence Diagram Steps:
     * 1.1. handleAccountDeletePost(request, response)
     * 1.1.1. getSession()
     * 1.1.2. getAttribute("user")
     *   alt user == null || !user.role.equals("Admin") -> Redirect to Login Page
     * 1.1.3. Get and validate id parameter
     *   alt id invalid -> Redirect with error message
     * 1.1.4. deleteAccount(id)
     *   alt success == true -> Redirect with success message
     *   alt success == false -> Redirect with database error message
     */
    private void handleAccountDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1.1.1. getSession()
        HttpSession session = request.getSession();
        
        // 1.1.2. getAttribute("user")
        Account currentUser = (Account) session.getAttribute("user");

        // alt user == null || !user.role.equals("Admin")
        if (currentUser == null || !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            // 2. Redirect to Login Page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1.1.3. Get and validate id parameter
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            // alt id invalid -> 3. Redirect to /admin/accounts (error message)
            session.setAttribute("errorMessage", "Missing account ID.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            
            // Further validation: check if account exists
            Account existingAcc = accountDAO.getAccountById(id);
            if (existingAcc == null) {
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Safety check: Prevent deleting oneself
            if (currentUser.getAccountId() == id) {
                session.setAttribute("errorMessage", "You cannot delete your own account.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // 1.1.4. deleteAccount(id)
            boolean success = accountDAO.deleteAccount(id);
            
            // alt success == true
            if (success) {
                // 4. Redirect to /admin/accounts (success message)
                session.setAttribute("successMessage", "Account deleted successfully.");
            } else {
                // alt success == false -> 5. Redirect to /admin/accounts (database error message)
                session.setAttribute("errorMessage", "Failed to delete account due to a database error.");
            }
        } catch (NumberFormatException e) {
            // alt id invalid -> 3. Redirect to /admin/accounts (error message)
            session.setAttribute("errorMessage", "Invalid account ID format.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }
}

