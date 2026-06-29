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
import model.Review;
import service.ReviewService;

@WebServlet(name = "AdminReviewController", urlPatterns = {"/admin/staff/reviews"})
public class AdminReviewController extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // Cấp quyền cho Admin và Staff
        if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Review> reviews = reviewService.getAllReviewsAdmin();
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("respond".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String responseText = request.getParameter("response");

                boolean success = reviewService.updateReviewResponse(reviewId, responseText);
                if (success) {
                    session.setAttribute("successMessage", "Đã lưu câu trả lời thành công!");
                } else {
                    session.setAttribute("errorMessage", "Không thể lưu câu trả lời. Vui lòng thử lại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
            }
        } else if ("toggleStatus".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String currentStatus = request.getParameter("currentStatus");
                
                String newStatus = "VISIBLE".equalsIgnoreCase(currentStatus) ? "HIDDEN" : "VISIBLE";
                
                boolean success = reviewService.updateReviewStatus(reviewId, newStatus);
                if (success) {
                    session.setAttribute("successMessage", "Đã chuyển trạng thái đánh giá thành " + newStatus + ".");
                } else {
                    session.setAttribute("errorMessage", "Không thể thay đổi trạng thái đánh giá.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff/reviews");
    }
}
