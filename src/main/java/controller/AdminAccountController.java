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
import dao.CustomerDAO;
import dao.EmployeeDAO;
import model.Customer;
import model.Employee;

@WebServlet(name = "AdminAccountController", urlPatterns = {"/admin/accounts"})
public class AdminAccountController extends HttpServlet {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

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

        List<Account> accounts = new java.util.ArrayList<>();
        if ("Customer".equals(role)) {
            accounts.addAll(customerDAO.getAllAccounts(search, status));
        } else if ("Staff".equals(role)) {
            accounts.addAll(employeeDAO.getAllAccounts(search, "Staff", status));
        } else {
            // role is "All" (or any other invalid role, we only show Customer and Staff)
            accounts.addAll(customerDAO.getAllAccounts(search, status));
            accounts.addAll(employeeDAO.getAllAccounts(search, "Staff", status));
        }

        // Determine active tab based on role search results
        String activeTab = "employees"; // default
        if ("Customer".equalsIgnoreCase(role)) {
            activeTab = "customers";
        } else if ("Staff".equalsIgnoreCase(role)) {
            activeTab = "employees";
        } else { // role is "All" or empty
            boolean hasStaff = false;
            boolean hasCustomer = false;
            for (Account acc : accounts) {
                if ("Staff".equalsIgnoreCase(acc.getRole())) {
                    hasStaff = true;
                } else if ("Customer".equalsIgnoreCase(acc.getRole())) {
                    hasCustomer = true;
                }
            }
            if (!hasStaff && hasCustomer) {
                activeTab = "customers";
            }
        }

        request.setAttribute("accounts", accounts);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("selectedRole", role);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("activeTab", activeTab);

        request.getRequestDispatcher("/WEB-INF/views/admin/accounts.jsp").forward(request, response);
    }

    /**
     * Handles account details page request via GET.
     * Sequence Diagram Steps:
     * 1.1. handleAccountDetailGet(request, response)
     * 1.1.1. getSession()
     * 1.1.2. getAttribute("user")
     *   alt user == null || !user.role.equals("Admin") -> Redirect to Login Page
     * 1.1.3. getParameter("id")
     *   alt id is valid -> deleteAccount(id) (in this case, getAccountById)
     *   alt id is invalid/empty -> Redirect to /admin/accounts (invalid ID message)
     */
    private void handleAccountDetailGet(HttpServletRequest request, HttpServletResponse response)
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

        // 1.1.3. getParameter("id")
        String idStr = request.getParameter("id");
        String role = request.getParameter("role");
        if (idStr == null || idStr.trim().isEmpty()) {
            // alt id is invalid/empty -> 5. Redirect to /admin/accounts (invalid ID message)
            session.setAttribute("errorMessage", "Missing account ID.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            
            // 1.1.4. getAccountById(id)
            Account account = null;
            if (role != null && !role.trim().isEmpty()) {
                account = ("Customer".equalsIgnoreCase(role) ? customerDAO.getAccountById(id) : employeeDAO.getAccountById(id));
            } else {
                account = customerDAO.getAccountById(id);
                if (account == null) {
                    account = employeeDAO.getAccountById(id);
                }
            }
            
            // alt account != null
            if (account != null) {
                // Safety check: Prevent Admin from viewing Admin accounts
                if ("Admin".equalsIgnoreCase(account.getRole())) {
                    session.setAttribute("errorMessage", "Access denied. Admin cannot manage other Admin accounts.");
                    response.sendRedirect(request.getContextPath() + "/admin/accounts");
                    return;
                }
                request.setAttribute("account", account);
                // 1.1.5. forward(request, response) -> 3. Render account details page
                request.getRequestDispatcher("/WEB-INF/views/admin/account-details.jsp").forward(request, response);
            } else {
                // account == null -> 4. Redirect to /admin/accounts (error message)
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
            }
        } catch (NumberFormatException e) {
            // alt id is invalid/empty -> 5. Redirect to /admin/accounts (invalid ID message)
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
        String status = request.getParameter("status");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

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

        // Safety check: Admin cannot create Admin accounts
        if ("Admin".equalsIgnoreCase(role)) {
            session.setAttribute("errorMessage", "You cannot create Admin accounts.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Check if username already exists
        if ((customerDAO.getAccountByUsernameOrEmail(username) != null || employeeDAO.getAccountByUsernameOrEmail(username) != null)) {
            session.setAttribute("errorMessage", "Username is already taken.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Check if email already exists
        if ((customerDAO.getAccountByEmail(email) != null ? customerDAO.getAccountByEmail(email) : employeeDAO.getAccountByEmail(email)) != null) {
            session.setAttribute("errorMessage", "Email is already in use.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        // Encrypt password using utils.PasswordUtils
        String passwordHash = utils.PasswordUtils.hashMD5(password);

        Account acc = "Customer".equalsIgnoreCase(role) ? new Customer() : new Employee();
        acc.setUsername(username.trim());
        acc.setPasswordHash(passwordHash);
        acc.setEmail(email.trim());
        acc.setFullName(fullName != null ? fullName.trim() : "");
        acc.setPhone(phone != null ? phone.trim() : "");
        acc.setAddress(address != null ? address.trim() : "");
        acc.setRole(role.trim());
        acc.setStatus(status.trim());
        acc.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

        boolean success;
            if (acc instanceof Employee) {
                success = employeeDAO.insertAccount((Employee)acc);
            } else {
                success = customerDAO.insertAccount((Customer)acc);
            }
        if (success) {
            session.setAttribute("successMessage", "Account created successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to create account due to a database error.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }

    /**
     * Handles account updates via POST.
     * Sequence Diagram Steps:
     * 1.1. handleAccountUpdatePost(request, response)
     * 1.1.1. getSession()
     * 1.1.2. getAttribute("user")
     *   alt user == null || !user.role.equals("Admin") -> Redirect to Login Page
     * 1.1.3. Get and validate parameters
     *   alt inputs invalid -> Redirect to /admin/accounts (error message)
     * 1.1.4. updateAccount(acc)
     *   alt success == true -> Redirect to /admin/accounts (success message)
     *   alt success == false -> Redirect to /admin/accounts (database error message)
     */
    private void handleAccountUpdatePost(HttpServletRequest request, HttpServletResponse response)
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

        // 1.1.3. Get and validate parameters
        String idStr = request.getParameter("id");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String status = request.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            // alt inputs invalid -> 3. Redirect to /admin/accounts (error message)
            session.setAttribute("errorMessage", "Required fields are missing.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Account existingAcc = null;
            if ("Customer".equalsIgnoreCase(role)) {
                existingAcc = customerDAO.getAccountById(id);
            } else {
                existingAcc = employeeDAO.getAccountById(id);
            }
            if (existingAcc == null) {
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Safety check: Admin cannot update Admin accounts
            if ("Admin".equalsIgnoreCase(existingAcc.getRole())) {
                session.setAttribute("errorMessage", "Access denied. Admin cannot modify Admin accounts.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Check if email belongs to someone else
            if (("Customer".equalsIgnoreCase(role) ? customerDAO.checkEmailExistsForOtherAccount(email, id) : employeeDAO.checkEmailExistsForOtherAccount(email, id))) {
                session.setAttribute("errorMessage", "Email is already in use by another account.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Update password optionally if provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                String passwordHash = utils.PasswordUtils.hashMD5(password);
                if ("Customer".equalsIgnoreCase(role)) customerDAO.updatePasswordById(id, passwordHash);
                else employeeDAO.updatePasswordById(id, passwordHash);
            }

            // inputs valid -> Construct Account object
            Account acc = "Customer".equalsIgnoreCase(role) ? new Customer() : new Employee();
            acc.setAccountId(id);
            acc.setEmail(email.trim());
            acc.setFullName(fullName != null ? fullName.trim() : "");
            acc.setPhone(phone != null ? phone.trim() : "");
            acc.setAddress(address != null ? address.trim() : "");
            acc.setRole(role.trim());
            acc.setStatus(status.trim());

            // 1.1.4. updateAccount(acc)
            boolean success = acc instanceof Employee ? employeeDAO.updateAccount((Employee)acc) : customerDAO.updateAccount((model.Customer)acc);
            
            // alt success == true
            if (success) {
                // 4. Redirect to /admin/accounts (success message)
                session.setAttribute("successMessage", "Account updated successfully.");
            } else {
                // alt success == false -> 5. Redirect to /admin/accounts (database error message)
                session.setAttribute("errorMessage", "Failed to update account due to a database error.");
            }
        } catch (NumberFormatException e) {
            // alt inputs invalid -> 3. Redirect to /admin/accounts (error message)
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
        String role = request.getParameter("role");
        if (idStr == null || idStr.trim().isEmpty()) {
            // alt id invalid -> 3. Redirect to /admin/accounts (error message)
            session.setAttribute("errorMessage", "Missing account ID.");
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            
            // Further validation: check if account exists
            Account existingAcc = null;
            if (role != null && !role.trim().isEmpty()) {
                if ("Customer".equalsIgnoreCase(role)) {
                    existingAcc = customerDAO.getAccountById(id);
                } else {
                    existingAcc = employeeDAO.getAccountById(id);
                }
            } else {
                existingAcc = customerDAO.getAccountById(id);
                if (existingAcc != null) {
                    role = "Customer";
                } else {
                    existingAcc = employeeDAO.getAccountById(id);
                    if (existingAcc != null) {
                        role = existingAcc.getRole();
                    }
                }
            }

            if (existingAcc == null) {
                session.setAttribute("errorMessage", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // Safety check: Prevent deleting Admin accounts
            if ("Admin".equalsIgnoreCase(existingAcc.getRole())) {
                session.setAttribute("errorMessage", "Access denied. Admin cannot delete Admin accounts.");
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
            boolean success = "Customer".equalsIgnoreCase(role) ? customerDAO.deleteAccount(id) : employeeDAO.deleteAccount(id);
            
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
