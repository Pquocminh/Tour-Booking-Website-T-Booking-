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
import dao.CustomerDAO;
import dao.EmployeeDAO;
import model.Employee;
import dao.ReviewDAO;
import dao.WishlistDAO;
import dao.PaymentDAO;
import dao.VoucherDAO;
import model.Payment;
import utils.PasswordUtils;

@WebServlet(name = "CustomerController", urlPatterns = {"/profile", "/customer/reviews", "/booking", "/wishlist", "/payment", "/bills", "/bill-detail"})
public class CustomerController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

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
        } else if ("/payment".equals(path)) {
            handlePaymentGet(request, response);
        } else if ("/bills".equals(path)) {
            handleBillsGet(request, response);
        } else if ("/bill-detail".equals(path)) {
            handleBillDetailGet(request, response);
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
        } else if ("/payment".equals(path)) {
            String action = request.getParameter("action");
            if ("applyVoucher".equals(action)) {
                handleApplyVoucherPost(request, response);
            } else {
                handlePaymentPost(request, response);
            }
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
        Account freshUser = user instanceof Employee ? employeeDAO.getAccountByEmail(user.getEmail()) : customerDAO.getAccountByEmail(user.getEmail());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
        }
        request.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(request, response);
    }

    private String capitalizeWords(String str) {
        if (str == null || str.trim().isEmpty()) return "";
        String[] words = str.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String word : words) {
            if (!word.isEmpty()) {
                sb.append(Character.toUpperCase(word.charAt(0)));
                if (word.length() > 1) {
                    sb.append(word.substring(1).toLowerCase());
                }
                sb.append(" ");
            }
        }
        return sb.toString().trim();
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

            String result = "Failed to update profile. Please try again.";

            if (fullName == null || fullName.trim().isEmpty()) {
                result = "Full name cannot be empty!";
            } else {
                fullName = capitalizeWords(fullName);
                if (!fullName.matches("^[\\p{L}\\s]+$")) {
                    result = "Full name cannot contain numbers or special characters!";
                } else if (email == null || email.trim().isEmpty() || !email.trim().toLowerCase().matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$")) {
                    result = "Email address must be a valid @gmail.com address!";
                } else if (phone == null || phone.trim().isEmpty()) {
                    result = "Phone number cannot be empty!";
                } else if (!phone.trim().matches("^\\d{9,11}$")) {
                    result = "Phone number must contain digits only (9-11 numbers) without letters or special characters!";
                } else {
                    String cleanEmail = email.trim().toLowerCase();
                    String cleanPhone = phone.trim();
                    String cleanAddress = address != null ? address.trim() : "";

                    Account tempUser = user instanceof Employee ? new model.Employee() : new model.Customer();
                    tempUser.setAccountId(user.getAccountId());
                    tempUser.setFullName(fullName);
                    tempUser.setEmail(cleanEmail);
                    tempUser.setPhone(cleanPhone);
                    tempUser.setAddress(cleanAddress);

                    Account existing = tempUser instanceof Employee ? employeeDAO.getAccountByEmail(cleanEmail) : customerDAO.getAccountByEmail(cleanEmail);
                    if (existing != null && existing.getAccountId() != tempUser.getAccountId()) {
                        result = "Email is already in use by another account!";
                    } else {
                        boolean updated = tempUser instanceof Employee ? employeeDAO.updateProfile((Employee)tempUser) : customerDAO.updateProfile((model.Customer)tempUser);
                        if (updated) {
                            result = "success";
                        }
                    }
                }
            }

            if ("success".equals(result)) {
                Account freshUser = user instanceof Employee ? employeeDAO.getAccountByEmail(email.trim().toLowerCase()) : customerDAO.getAccountByEmail(email.trim().toLowerCase());
                if (freshUser != null) {
                    session.setAttribute("user", freshUser);
                } else {
                    user.setFullName(fullName);
                    user.setEmail(email.trim().toLowerCase());
                    user.setPhone(phone.trim());
                    user.setAddress(address != null ? address.trim() : "");
                    session.setAttribute("user", user);
                }
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
                    boolean updated = user instanceof Employee ? employeeDAO.updatePasswordById(user.getAccountId(), hashedNew) : customerDAO.updatePasswordById(user.getAccountId(), hashedNew);
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
                    if (review.getComment() == null || review.getComment().isEmpty()) {
                        session.setAttribute("errorMessage", "Review comment cannot be empty.");
                        response.sendRedirect(request.getContextPath() + "/customer/reviews");
                        return;
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
        } else if ("detail".equals(action)) {
            handleBookingDetailGet(request, response);
        } else {
            HttpSession session = request.getSession();
            Account user = (Account) session.getAttribute("user");
            if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> bookings = bookingDAO.getBookingsByCustomerId(user.getAccountId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/views/customer/booking-list.jsp").forward(request, response);
        }
    }

    private void handleBookingDetailGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(idParam);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking != null && booking.getCustomerId() == user.getAccountId()) {
                TourDAO tourDAO = new TourDAO();
                TourSchedule schedule = tourDAO.getTourScheduleById(booking.getScheduleId());
                if (schedule != null) {
                    Tour tour = tourDAO.getTourById(schedule.getTourId());
                    request.setAttribute("tour", tour);
                    request.setAttribute("schedule", schedule);
                }
                
                if (booking.getVoucherId() != null) {
                    VoucherDAO voucherDAO = new VoucherDAO();
                    model.Voucher voucher = voucherDAO.getVoucherById(booking.getVoucherId());
                    request.setAttribute("voucher", voucher);
                }
                
                PaymentDAO paymentDAO = new PaymentDAO();
                List<Payment> payments = paymentDAO.getPaymentsByBookingId(bookingId);
                
                request.setAttribute("booking", booking);
                request.setAttribute("payments", payments);
                request.getRequestDispatcher("/WEB-INF/views/customer/booking-detail.jsp").forward(request, response);
                return;
            } else {
                session.setAttribute("errorMessage", "Booking not found or access denied.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID.");
        }
        response.sendRedirect(request.getContextPath() + "/booking");
    }

    private void handleBookingPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account user = (Account) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            handleBookingCancelPost(request, response);
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
            TourDAO tourDAO = new TourDAO();
            TourSchedule schedule = tourDAO.getTourScheduleById(scheduleId);

            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }

            int numberOfPeople;
            try {
                String trimmedPeopleStr = numberOfPeopleStr.trim();

                // Business Rule 1: Mandatory traveler count check
                if (trimmedPeopleStr.isEmpty()) {
                    request.getSession().setAttribute("errorMessage", "Please enter the number of travelers.");
                    response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
                    return;
                }

                // Business Rule 2: Fractional values prohibited
                if (trimmedPeopleStr.contains(".") || trimmedPeopleStr.contains(",")) {
                    request.getSession().setAttribute("errorMessage", "Decimal values are not allowed. Please enter a whole number.");
                    response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
                    return;
                }

                numberOfPeople = Integer.parseInt(trimmedPeopleStr);

                // Business Rule 3: Minimum capacity threshold check (>= 1 traveler)
                if (numberOfPeople <= 0) {
                    request.getSession().setAttribute("errorMessage", "Number of travelers must be at least 1.");
                    response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
                    return;
                }
            } catch (NumberFormatException e) {
                // Business Rule 4: Strictly numeric input validation
                request.getSession().setAttribute("errorMessage", "Invalid character detected. Please enter digits only.");
                response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
                return;
            }

            try {
                SystemSettingDAO sysDao = new SystemSettingDAO();
                String bookingWindowStr = sysDao.getSettingValueByKey("booking_window_days");
                if (bookingWindowStr != null && !bookingWindowStr.trim().isEmpty()) {
                    int bookingWindowDays = Integer.parseInt(bookingWindowStr);
                    java.time.LocalDate today = java.time.LocalDate.now();
                    java.time.LocalDate departureDate = schedule.getDepartureDate().toLocalDate();
                    long daysUntilDeparture = java.time.temporal.ChronoUnit.DAYS.between(today, departureDate);
                    
                    if (daysUntilDeparture < bookingWindowDays) {
                        request.getSession().setAttribute("errorMessage", "Booking failed! The booking window has closed. You must book at least " + bookingWindowDays + " days before departure.");
                        response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Business Rule 5: Capacity limit enforcement
            if (schedule.getAvailableSlots() < numberOfPeople) {
                request.getSession().setAttribute("errorMessage", "Not enough capacity! Only " + schedule.getAvailableSlots() + " slot(s) remaining for this schedule.");
                response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
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
                response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + booking.getBookingId());
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to book tour. Please try again.");
                response.sendRedirect(request.getContextPath() + "/tour-detail?id=" + schedule.getTourId());
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }

    private void handleBookingCancelPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        String idParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(idParam);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking != null && booking.getCustomerId() == user.getAccountId()) {
                if ("Pending".equalsIgnoreCase(booking.getStatus()) || "Confirmed".equalsIgnoreCase(booking.getStatus())) {
                    
                    try {
                        TourDAO tourDAO = new TourDAO();
                        TourSchedule schedule = tourDAO.getTourScheduleById(booking.getScheduleId());
                        if (schedule != null) {
                            SystemSettingDAO sysDao = new SystemSettingDAO();
                            String cancelWindowStr = sysDao.getSettingValueByKey("cancellation_window_days");
                            if (cancelWindowStr != null && !cancelWindowStr.trim().isEmpty()) {
                                int cancelWindowDays = Integer.parseInt(cancelWindowStr);
                                java.time.LocalDate today = java.time.LocalDate.now();
                                java.time.LocalDate departureDate = schedule.getDepartureDate().toLocalDate();
                                long daysUntilDeparture = java.time.temporal.ChronoUnit.DAYS.between(today, departureDate);
                                
                                if (daysUntilDeparture < cancelWindowDays) {
                                    session.setAttribute("errorMessage", "Cancellation failed! You can only cancel at least " + cancelWindowDays + " days before departure.");
                                    response.sendRedirect(request.getContextPath() + "/booking");
                                    return;
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    boolean success = bookingDAO.cancelBooking(bookingId);
                    if (success) {
                        session.setAttribute("successMessage", "Booking cancelled successfully.");
                    } else {
                        session.setAttribute("errorMessage", "Failed to cancel booking.");
                    }
                } else {
                    session.setAttribute("errorMessage", "Only pending bookings can be cancelled.");
                }
            } else {
                session.setAttribute("errorMessage", "Booking not found or access denied.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID.");
        }
        response.sendRedirect(request.getContextPath() + "/booking");
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

        WishlistDAO wishlistDAO = new WishlistDAO();

        if ("removeMultiple".equalsIgnoreCase(action)) {
            String[] tourIdsStr = request.getParameterValues("tourIds");
            if (tourIdsStr != null && tourIdsStr.length > 0) {
                List<Integer> tourIds = new java.util.ArrayList<>();
                for (String idStr : tourIdsStr) {
                    try {
                        tourIds.add(Integer.parseInt(idStr));
                    } catch (NumberFormatException e) {
                        // ignore
                    }
                }
                if (!tourIds.isEmpty()) {
                    boolean success = wishlistDAO.removeMultipleToursFromWishlist(user.getAccountId(), tourIds);
                    if (success) {
                        session.setAttribute("successMessage", "Selected tours removed from wishlist successfully!");
                    } else {
                        session.setAttribute("errorMessage", "Failed to remove selected tours from wishlist.");
                    }
                } else {
                    session.setAttribute("errorMessage", "No valid tours selected.");
                }
            } else {
                session.setAttribute("errorMessage", "No tours selected.");
            }
        } else if (tourIdStr != null && !tourIdStr.trim().isEmpty()) {
            try {
                int tourId = Integer.parseInt(tourIdStr);

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

    // ================== PAYMENT ==================
    private void handlePaymentGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking != null && booking.getCustomerId() == user.getAccountId() && "Pending".equalsIgnoreCase(booking.getStatus())) {
                request.setAttribute("booking", booking);
                if (booking.getVoucherId() != null) {
                    VoucherDAO voucherDAO = new VoucherDAO();
                    model.Voucher voucher = voucherDAO.getVoucherById(booking.getVoucherId());
                    request.setAttribute("appliedVoucher", voucher);
                    
                    TourDAO tourDAO = new TourDAO();
                    TourSchedule schedule = tourDAO.getTourScheduleById(booking.getScheduleId());
                    if (schedule != null) {
                        double originalTotalPrice = schedule.getPrice() * booking.getNumberOfPeople();
                        double discount = originalTotalPrice - booking.getTotalPrice();
                        request.setAttribute("discountAmount", discount);
                    } else {
                        request.setAttribute("errorMessage", "Tour itinerary information not found. Please contact support.");
                        request.setAttribute("discountAmount", 0.0);
                    }
                }
                request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/booking");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while loading the payment page.");
            response.sendRedirect(request.getContextPath() + "/booking");
        }
    }

    private void handleApplyVoucherPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Booking booking = null;
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String voucherCode = request.getParameter("voucherCode");

            BookingDAO bookingDAO = new BookingDAO();
            booking = bookingDAO.getBookingById(bookingId);

            if (booking != null && booking.getCustomerId() == user.getAccountId() && "Pending".equalsIgnoreCase(booking.getStatus())) {
                
                // 1. Kiểm tra mã voucher rỗng
                if (voucherCode == null || voucherCode.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "The voucher code cannot be left blank.");
                    
                    // Nạp lại thông tin voucher đã áp dụng hiện tại nếu có
                    if (booking.getVoucherId() != null) {
                        VoucherDAO voucherDAO = new VoucherDAO();
                        model.Voucher voucher = voucherDAO.getVoucherById(booking.getVoucherId());
                        request.setAttribute("appliedVoucher", voucher);
                        
                        TourDAO tourDAO = new TourDAO();
                        TourSchedule schedule = tourDAO.getTourScheduleById(booking.getScheduleId());
                        if (schedule != null) {
                            double originalTotalPrice = schedule.getPrice() * booking.getNumberOfPeople();
                            double discount = originalTotalPrice - booking.getTotalPrice();
                            request.setAttribute("discountAmount", discount);
                        }
                    }
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
                    return;
                }

                // 2. Tìm voucher trong database
                VoucherDAO voucherDAO = new VoucherDAO();
                model.Voucher voucher = voucherDAO.getVoucherByCode(voucherCode.trim());

                TourDAO tourDAO = new TourDAO();
                TourSchedule schedule = tourDAO.getTourScheduleById(booking.getScheduleId());
                
                // 3. Kiểm tra null lịch trình tour
                if (schedule == null) {
                    request.setAttribute("errorMessage", "Tour itinerary information not found. Please contact support.");
                    // Vẫn nạp lại thông tin voucher đã áp dụng cũ nếu có
                    if (booking.getVoucherId() != null) {
                        model.Voucher oldVoucher = voucherDAO.getVoucherById(booking.getVoucherId());
                        request.setAttribute("appliedVoucher", oldVoucher);
                    }
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
                    return;
                }

                double originalTotalPrice = schedule.getPrice() * booking.getNumberOfPeople();
                java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());

                if (voucher != null 
                        && "Active".equalsIgnoreCase(voucher.getStatus())
                        && !currentDate.before(voucher.getStartDate())
                        && !currentDate.after(voucher.getEndDate())
                        && voucher.getQuantity() > 0
                        && originalTotalPrice >= voucher.getMinimumOrderValue()) {

                    double discount = originalTotalPrice * (voucher.getDiscountPercent() / 100.0);
                    if (discount > voucher.getMaxDiscountAmount()) {
                        discount = voucher.getMaxDiscountAmount();
                    }

                    double newTotalPrice = originalTotalPrice - discount;

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

                    double newDepositAmount = newTotalPrice * (depositPercent / 100.0);

                    boolean success = bookingDAO.applyVoucherToBooking(bookingId, voucher.getVoucherId(), newTotalPrice, newDepositAmount);
                    if (success) {
                        booking = bookingDAO.getBookingById(bookingId);
                        request.setAttribute("successMessage", "Voucher applied successfully.");
                        request.setAttribute("appliedVoucher", voucher);
                        request.setAttribute("discountAmount", discount);
                    } else {
                        request.setAttribute("errorMessage", "Voucher application failed due to a database error.");
                        // Nạp lại thông tin cũ
                        if (booking.getVoucherId() != null) {
                            model.Voucher oldVoucher = voucherDAO.getVoucherById(booking.getVoucherId());
                            request.setAttribute("appliedVoucher", oldVoucher);
                            double oldDiscount = originalTotalPrice - booking.getTotalPrice();
                            request.setAttribute("discountAmount", oldDiscount);
                        }
                    }
                } else {
                    request.setAttribute("errorMessage", "The voucher code is invalid or has expired.");
                    // Nạp lại thông tin cũ
                    if (booking.getVoucherId() != null) {
                        model.Voucher oldVoucher = voucherDAO.getVoucherById(booking.getVoucherId());
                        request.setAttribute("appliedVoucher", oldVoucher);
                        double oldDiscount = originalTotalPrice - booking.getTotalPrice();
                        request.setAttribute("discountAmount", oldDiscount);
                    }
                }

                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/booking");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (booking != null) {
                request.setAttribute("errorMessage", "A system error occurred while applying the voucher: " + e.getMessage());
                request.setAttribute("booking", booking);
                try {
                    request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/booking");
                }
            } else {
                session.setAttribute("errorMessage", "Invalid request or non-existent booking.");
                response.sendRedirect(request.getContextPath() + "/booking");
            }
        }
    }

    private void handlePaymentPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDAO bookingDAO = new BookingDAO();
            boolean success = bookingDAO.updateBookingStatus(bookingId, "Pending");
            
            if (success) {
                session.setAttribute("successMessage", "Payment confirmation submitted successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to submit payment confirmation.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid booking ID.");
        }
        
        response.sendRedirect(request.getContextPath() + "/booking");
    }

    private void handleBillsGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bills = bookingDAO.getBookingsByCustomerId(user.getAccountId());
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/WEB-INF/views/customer/bill-list.jsp").forward(request, response);
    }

    private void handleBillDetailGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("bookingId");
        try {
            int bookingId = Integer.parseInt(idParam);
            Booking booking = bookingDAO.getBookingDetails(bookingId);
            if (booking != null && booking.getCustomerId() == user.getAccountId()) {
                request.setAttribute("bill", booking);
                request.getRequestDispatcher("/WEB-INF/views/customer/bill-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/bills");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bills");
        }
    }
}
