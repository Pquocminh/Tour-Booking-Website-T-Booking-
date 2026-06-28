package service;

import dao.ReviewDAO;
import model.Booking;
import model.Review;
import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<Review> getReviewsByCustomerId(int customerId) {
        return reviewDAO.getReviewsByCustomerId(customerId);
    }

    public List<Booking> getUnreviewedBookingsByCustomerId(int customerId) {
        return reviewDAO.getUnreviewedBookingsByCustomerId(customerId);
    }

    public boolean addReview(Review review) {
        if (review == null || review.getRating() < 1 || review.getRating() > 5) {
            return false;
        }
        if (review.getComment() != null) {
            review.setComment(review.getComment().trim());
        }
        if (reviewDAO.hasReviewed(review.getBookingId())) {
            return false;
        }
        review.setStatus("Approved");
        return reviewDAO.addReview(review);
    }

    public boolean deleteReview(int reviewId, int customerId) {
        return reviewDAO.deleteReview(reviewId, customerId);
    }
}
