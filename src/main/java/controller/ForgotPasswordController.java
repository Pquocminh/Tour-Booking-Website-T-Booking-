package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.Account;
import service.AccountService;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {
    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        Account acc = accountService.getAccountByEmail(email);
        if (acc == null) {
            request.setAttribute("error", "This email address is not registered!");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate a 6-digit numeric OTP
        String otp = String.format("%06d", new Random().nextInt(1000000));
        long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000); // 5 minutes expiration

        // Store OTP details in session
        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetOtp", otp);
        session.setAttribute("resetOtpExpiry", expiryTime);

        // Send Email
        sendOtpEmail(email, otp);

        // Redirect to OTP verification page
        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }

    private void sendOtpEmail(String recipientEmail, String otp) {
        // Log to console fallback immediately for developer testing
        System.out.println("==================================================");
        System.out.println("[TESTING OTP] Email: " + recipientEmail);
        System.out.println("[TESTING OTP] generated OTP: " + otp);
        System.out.println("[TESTING OTP] Expires in: 5 minutes");
        System.out.println("==================================================");

        // SMTP configuration
        final String fromEmail = "tbooking.noreply@gmail.com"; // Configure as needed
        final String password = "your-app-password-here"; // Gmail App Password
        
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
            
            // Send in background/new thread to prevent blocking HTTP response
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
