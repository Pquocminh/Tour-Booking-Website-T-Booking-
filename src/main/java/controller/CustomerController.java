package controller;

import dao.BookingDAO;
import dao.TourDAO;
import dao.SystemSettingDAO;
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
import model.TourSchedule;
import model.Tour;
import dao.AccountDAO;
import dao.ReviewDAO;
import dao.WishlistDAO;
import utils.PasswordUtils;

@WebServlet(name = "CustomerController", urlPatterns = {"/profile", "/customer/reviews", "/booking", "/wishlist"})
public class CustomerController extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/profile".equals(path)) {
            handleProfileGet(request, response);
        } else if ("/customer/reviews".equals(path)) {
            handleReviewsGet(request, response);
        } else if ("/booking".equals(path)) {
            handleBookingGet(request, response);
        } else if ("/wishlist".equals(path)) {
            handleWishlistGet(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/profile".equals(path)) {
            handleProfilePost(request, response);
        } else if ("/customer/reviews".equals(path)) {
            handleReviewsPost(request, response);
        } else if ("/booking".equals(path)) {
            handleBookingPost(request, response);
        } else if ("/wishlist".equals(path)) {
            handleWishlistPost(request, response);
        }
    }

    // ================== PROFILE ==================
    private void handleProfileGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    private void handleProfilePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            Account tempUser = new Account();
            tempUser.setAccountId(user.getAccountId());
            tempUser.setFullName(fullName);
            tempUser.setEmail(email);
            tempUser.setPhone(phone);
            tempUser.setAddress(address);

            String result = "Failed to update profile. Please try again.";
            if (tempUser.getFullName() == null || tempUser.getFullName().trim().isEmpty()) {
                result = "Full name cannot be empty!";
            } else if (tempUser.getEmail() == null || tempUser.getEmail().trim().isEmpty()) {
                result = "Email cannot be empty!";
            } else {
                Account existing = accountDAO.getAccountByEmail(tempUser.getEmail());
                if (existing != null && existing.getAccountId() != tempUser.getAccountId()) {
                    result = "Email is already in use by another account!";
                } else {
                    boolean updated = accountDAO.updateProfile(tempUser);
                    if (updated) {
                        result = "success";
                    }
                }
            }

            if ("success".equals(result)) {
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                session.setAttribute("user", user);
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", result);
            }
        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            String result = "Failed to change password. Please try again.";
            if (!newPassword.equals(confirmPassword)) {
                result = "New passwords do not match!";
            } else if (oldPassword == null || oldPassword.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
                result = "Passwords cannot be empty!";
            } else {
                String hashedOld = PasswordUtils.hashMD5(oldPassword);
                if (!hashedOld.equals(user.getPasswordHash())) {
                    result = "Incorrect old password!";
                } else {
                    String hashedNew = PasswordUtils.hashMD5(newPassword);
                    boolean updated = accountDAO.updatePasswordById(user.getAccountId(), hashedNew);
                    if (updated) {
                        user.setPasswordHash(hashedNew);
                        result = "success";
                    }
                }
            }

            if ("success".equals(result)) {
                session.setAttribute("user", user); // Re-set to session since password hash was updated
                session.setAttribute("successMessage", "Password changed successfully!");
            } else {
                session.setAttribute("errorMessage", result);
            }
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    // ================== REVIEWS ==================
    private void handleReviewsGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Review> reviews = reviewDAO.getReviewsByCustomerId(user.getAccountId());
        List<Booking> unreviewedBookings = reviewDAO.getUnreviewedBookingsByCustomerId(user.getAccountId());

        request.setAttribute("reviews", reviews);
        request.setAttribute("unreviewedBookings", unreviewedBookings);

        request.getRequestDispatcher("/WEB-INF/views/customer/reviews.jsp").forward(request, response);
    }

    private void handleReviewsPost(HttpServletRequest request, HttpServletResponse response)
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

                boolean success = false;
                if (review != null && review.getRating() >= 1 && review.getRating() <= 5) {
                    if (review.getComment() != null) {
                        review.setComment(review.getComment().trim());
                    }
                    if (!reviewDAO.hasReviewed(review.getBookingId())) {
                        review.setStatus("Approved");
                        success = reviewDAO.addReview(review);
                    }
                }
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
                boolean success = reviewDAO.deleteReview(reviewId, user.getAccountId());
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

    // ================== BOOKING ==================
    private void handleBookingGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("success".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/guest/booking-success.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }

    private void handleBookingPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account user = (Account) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        String numberOfPeopleStr = request.getParameter("numberOfPeople");

        if (scheduleIdStr == null || numberOfPeopleStr == null) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdStr);
            int numberOfPeople = Integer.parseInt(numberOfPeopleStr);

            if (numberOfPeople <= 0) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }

            TourDAO tourDAO = new TourDAO();
            TourSchedule schedule = tourDAO.getTourScheduleById(scheduleId);

            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }

            if (schedule.getAvailableSlots() < numberOfPeople) {
                request.setAttribute("errorMessage", "Not enough available slots for your group.");
                request.getRequestDispatcher("/tour-detail?id=" + schedule.getTourId()).forward(request, response);
                return;
            }

            double totalPrice = schedule.getPrice() * numberOfPeople;
            
            String contactName = user.getFullName();
            String contactPhone = user.getPhone() != null ? user.getPhone() : "0123456789"; 

            double depositPercent = 30.0;
            try {
                SystemSettingDAO sysDao = new SystemSettingDAO();
                String depositSettingStr = sysDao.getSettingValueByKey("deposit_percent");
                if (depositSettingStr != null && !depositSettingStr.trim().isEmpty()) {
                    depositPercent = Double.parseDouble(depositSettingStr);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            double depositAmount = totalPrice * (depositPercent / 100.0);

            Booking booking = new Booking();
            booking.setCustomerId(user.getAccountId());
            booking.setScheduleId(scheduleId);
            booking.setNumberOfPeople(numberOfPeople);
            booking.setContactName(contactName);
            booking.setContactPhone(contactPhone);
            booking.setTotalPrice(totalPrice);
            booking.setDepositAmount(depositAmount);
            booking.setStatus("Pending");

            BookingDAO bookingDAO = new BookingDAO();
            boolean success = bookingDAO.insertBooking(booking);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/booking?action=success");
            } else {
                request.setAttribute("errorMessage", "Failed to book tour. Please try again.");
                request.getRequestDispatcher("/tour-detail?id=" + schedule.getTourId()).forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }

    // ================== WISHLIST ==================
    private void handleWishlistGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WishlistDAO wishlistDAO = new WishlistDAO();
        List<Tour> wishlistTours = wishlistDAO.getWishlistToursByCustomerId(user.getAccountId());
        request.setAttribute("wishlistTours", wishlistTours);

        request.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(request, response);
    }

    private void handleWishlistPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String tourIdStr = request.getParameter("tourId");
        String redirect = request.getParameter("redirect");

        if (tourIdStr != null && !tourIdStr.trim().isEmpty()) {
            try {
                int tourId = Integer.parseInt(tourIdStr);
                WishlistDAO wishlistDAO = new WishlistDAO();

                if ("add".equalsIgnoreCase(action)) {
                    boolean success = wishlistDAO.addTourToWishlist(user.getAccountId(), tourId);
                    if (success) {
                        session.setAttribute("successMessage", "Tour added to wishlist successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to add tour to wishlist.");
                    }
                } else if ("remove".equalsIgnoreCase(action)) {
                    boolean success = wishlistDAO.removeTourFromWishlist(user.getAccountId(), tourId);
                    if (success) {
                        session.setAttribute("successMessage", "Tour removed from wishlist successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to remove tour from wishlist.");
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid tour ID.");
            }
        }

        if ("detail".equalsIgnoreCase(redirect) && tourIdStr != null) {
            response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + tourIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
