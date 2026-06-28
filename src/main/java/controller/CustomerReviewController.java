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
import model.Booking;
import model.Review;
import service.ReviewService;

@WebServlet(name = "CustomerReviewController", urlPatterns = {"/customer/reviews"})
public class CustomerReviewController extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Review> reviews = reviewService.getReviewsByCustomerId(user.getAccountId());
        List<Booking> unreviewedBookings = reviewService.getUnreviewedBookingsByCustomerId(user.getAccountId());

        request.setAttribute("reviews", reviews);
        request.setAttribute("unreviewedBookings", unreviewedBookings);

        request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("rate".equals(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                Review review = new Review();
                review.setBookingId(bookingId);
                review.setCustomerId(user.getAccountId());
                review.setRating(rating);
                review.setComment(comment);

                boolean success = reviewService.addReview(review);
                if (success) {
                    session.setAttribute("successMessage", "Review submitted successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to submit review. You may have already reviewed this booking, or entered invalid ratings.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid review parameters.");
            }
        } else if ("delete".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                boolean success = reviewService.deleteReview(reviewId, user.getAccountId());
                if (success) {
                    session.setAttribute("successMessage", "Review deleted successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete review.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid review ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/customer/reviews");
    }
}
