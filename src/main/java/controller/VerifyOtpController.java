package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOtpController", urlPatterns = {"/verify-otp"})
public class VerifyOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String otp = (String) session.getAttribute("resetOtp");
        
        if (email == null || otp == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // Check expiration
        if (System.currentTimeMillis() > expiryTime) {
            request.setAttribute("error", "The verification code has expired. Please try again.");
            // Clear expired values
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        // Check correctness
        if (!enteredOtp.equals(sessionOtp)) {
            request.setAttribute("error", "Invalid verification code!");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        // OTP verified successfully
        session.setAttribute("otp_verified", true);
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }
}
