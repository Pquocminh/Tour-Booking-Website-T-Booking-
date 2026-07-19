package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;
import java.util.Random;

import model.Account;
import dao.AccountDAO;
import utils.PasswordUtils;

@WebServlet(name = "AuthController", urlPatterns = {
    "/login", "/logout", "/register", "/login-google",
    "/forgot-password", "/verify-otp", "/reset-password"
})
public class AuthController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/login": handleLoginGet(request, response); break;
            case "/logout": handleLogoutGet(request, response); break;
            case "/register": handleRegisterGet(request, response); break;
            case "/forgot-password": handleForgotPasswordGet(request, response); break;
            case "/verify-otp": handleVerifyOtpGet(request, response); break;
            case "/reset-password": handleResetPasswordGet(request, response); break;
            default: response.sendError(HttpServletResponse.SC_NOT_FOUND); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/login": handleLoginPost(request, response); break;
            case "/register": handleRegisterPost(request, response); break;
            case "/login-google": handleLoginGooglePost(request, response); break;
            case "/forgot-password": handleForgotPasswordPost(request, response); break;
            case "/verify-otp": handleVerifyOtpPost(request, response); break;
            case "/reset-password": handleResetPasswordPost(request, response); break;
            default: response.sendError(HttpServletResponse.SC_NOT_FOUND); break;
        }
    }

    // ================== LOGIN ==================
    private void handleLoginGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("user");
        if (loggedInUser != null) {
            if ("Admin".equalsIgnoreCase(loggedInUser.getRole()) || "Staff".equalsIgnoreCase(loggedInUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/tours");
            }
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    private void handleLoginPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String pass = request.getParameter("password");

        Account acc = null;
        if (username != null && pass != null) {
            String hashedPassword = PasswordUtils.hashMD5(pass);
            acc = accountDAO.checkLogin(username.trim(), hashedPassword);
        }
        if (acc != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", acc);
            if ("Admin".equalsIgnoreCase(acc.getRole()) || "Staff".equalsIgnoreCase(acc.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/tours");
            }
        } else {
            request.setAttribute("error", "Invalid username or password, or account is suspended!");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    // ================== LOGOUT ==================
    private void handleLogoutGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().invalidate();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JSESSIONID".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/tours");
    }

    // ================== REGISTER ==================
    private void handleRegisterGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private void handleRegisterPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        Account acc = new Account();
        acc.setFullName(fullName);
        acc.setEmail(email);
        acc.setPhone(phone);
        acc.setUsername(username);
        acc.setPasswordHash(password);

        String result = "Registration failed! Please try again.";
        if (acc != null) {
            if (!password.matches("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$")) {
                result = "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.";
            } else if (!password.equals(confirmPassword)) {
                result = "Passwords do not match!";
            } else if (accountDAO.checkUsernameExists(username)) {
                result = "Username is already taken!";
            } else if (accountDAO.getAccountByEmail(email) != null) {
                result = "Email is already registered!";
            } else {
                String hashedPassword = PasswordUtils.hashMD5(password);
                acc.setPasswordHash(hashedPassword);
                acc.setRole("Customer");
                acc.setStatus("Active");
                boolean success = accountDAO.insertAccount(acc);
                if (success) {
                    result = "success";
                }
            }
        }
        if ("success".equalsIgnoreCase(result)) {
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } else {
            request.setAttribute("error", result);
            request.setAttribute("registeredAccount", acc);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    // ================== GOOGLE LOGIN ==================
    private void handleLoginGooglePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idToken = request.getParameter("credential");
        if (idToken == null || idToken.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=Missing+Google+Credential");
            return;
        }

        GoogleUser googleUser = verifyGoogleToken(idToken);
        if (googleUser != null && "true".equalsIgnoreCase(googleUser.email_verified)) {
            Account acc = null;
            if (googleUser.email != null) {
                acc = accountDAO.getAccountByEmail(googleUser.email);
                if (acc == null) {
                    Account newAcc = new Account();
                    newAcc.setEmail(googleUser.email);
                    newAcc.setFullName(googleUser.name);
                    String randomUser = "user_" + System.currentTimeMillis();
                    newAcc.setUsername(randomUser);
                    String randomPass = PasswordUtils.hashMD5(randomUser + Math.random());
                    newAcc.setPasswordHash(randomPass);
                    newAcc.setRole("Customer");
                    newAcc.setStatus("Active");
                    if (accountDAO.insertAccount(newAcc)) {
                        acc = accountDAO.getAccountByEmail(googleUser.email);
                    }
                } else if ("Suspended".equalsIgnoreCase(acc.getStatus())) {
                    acc = null;
                }
            }
            if (acc != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", acc);
                if ("Admin".equalsIgnoreCase(acc.getRole()) || "Staff".equalsIgnoreCase(acc.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/tours");
                }
                return;
            }
        }

        request.setAttribute("error", "Google authentication failed, or account is suspended!");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    private GoogleUser verifyGoogleToken(String idToken) {
        try {
            String urlString = "https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken;
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                InputStream is = conn.getInputStream();
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                reader.close();

                Gson gson = new Gson();
                return gson.fromJson(sb.toString(), GoogleUser.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static class GoogleUser {
        String email;
        String name;
        String sub;
        String email_verified;
    }

    // ================== FORGOT PASSWORD ==================
    private void handleForgotPasswordGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    private void handleForgotPasswordPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        Account acc = accountDAO.getAccountByEmail(email);
        if (acc == null) {
            request.setAttribute("error", "This email address is not registered!");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(1000000));
        long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000);

        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetOtp", otp);
        session.setAttribute("resetOtpExpiry", expiryTime);

        sendOtpEmail(email, otp);

        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }

    // ================== VERIFY OTP ==================
    private void handleVerifyOtpGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String otp = (String) session.getAttribute("resetOtp");
        
        if (email == null || otp == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
    }

    private void handleVerifyOtpPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionEmail = (String) session.getAttribute("resetEmail");
        String sessionOtp = (String) session.getAttribute("resetOtp");
        Long expiryTime = (Long) session.getAttribute("resetOtpExpiry");

        if (sessionEmail == null || sessionOtp == null || expiryTime == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String enteredOtp = request.getParameter("otp");
        if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
            request.setAttribute("error", "OTP is required!");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        enteredOtp = enteredOtp.trim();

        if (System.currentTimeMillis() > expiryTime) {
            request.setAttribute("error", "The verification code has expired. Please try again.");
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        if (!enteredOtp.equals(sessionOtp)) {
            request.setAttribute("error", "Invalid verification code!");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        session.setAttribute("otp_verified", true);
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }

    // ================== RESET PASSWORD ==================
    private void handleResetPasswordGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean verified = (Boolean) session.getAttribute("otp_verified");
        String email = (String) session.getAttribute("resetEmail");

        if (verified == null || !verified || email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
    }

    private void handleResetPasswordPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean verified = (Boolean) session.getAttribute("otp_verified");
        String email = (String) session.getAttribute("resetEmail");

        if (verified == null || !verified || email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        boolean success = false;
        if (email != null && password != null) {
            String hashedPassword = PasswordUtils.hashMD5(password);
            Account acc = accountDAO.getAccountByEmail(email);
            if (acc != null) {
                success = accountDAO.updatePasswordById(acc.getAccountId(), hashedPassword);
            }
        }
        if (success) {
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");
            session.removeAttribute("otp_verified");

            response.sendRedirect(request.getContextPath() + "/login?resetSuccess=true");
        } else {
            request.setAttribute("error", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
        }
    }

    private void sendOtpEmail(String recipientEmail, String otp) {
        System.out.println("==================================================");
        System.out.println("[TESTING OTP] Email: " + recipientEmail);
        System.out.println("[TESTING OTP] generated OTP: " + otp);
        System.out.println("[TESTING OTP] Expires in: 5 minutes");
        System.out.println("==================================================");

        final String fromEmail = "pquocminh.ce190255@gmail.com";
        final String password = "fwbd wjof lbsx wpng";
        
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("T-Booking: Password Reset Verification Code");
            
            String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
                    + "<h2>Password Reset Request</h2>"
                    + "<p>Dear User,</p>"
                    + "<p>You requested to reset your password. Use the following verification code to proceed:</p>"
                    + "<h1 style='color: #4F46E5; background-color: #F3F4F6; padding: 10px; display: inline-block; border-radius: 8px; letter-spacing: 2px;'>" + otp + "</h1>"
                    + "<p>This OTP is valid for <strong>5 minutes</strong>. If you did not request this, please ignore this email.</p>"
                    + "<br/>"
                    + "<p>Best regards,</p>"
                    + "<p><strong>T-Booking Team</strong></p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            new Thread(() -> {
                try {
                    Transport.send(message);
                    System.out.println("[SMTP] OTP email sent successfully to " + recipientEmail);
                } catch (Exception e) {
                    System.err.println("[SMTP] Failed to send email via SMTP (Using Console Fallback): " + e.getMessage());
                }
            }).start();

        } catch (Exception e) {
            System.err.println("[SMTP] Configuration error: " + e.getMessage());
        }
    }
}
