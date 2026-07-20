package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import model.Tour;
import model.TourSchedule;
import model.Booking;
import model.Account;
import model.Review;
import dao.TourDAO;
import dao.CustomerDAO;
import dao.EmployeeDAO;
import dao.ReviewDAO;
import com.google.gson.Gson;

@WebServlet(name = "StaffController", urlPatterns = {"/admin/staff/schedules", "/admin/staff/reviews"})
public class StaffController extends HttpServlet {
    private final TourDAO tourDAO = new TourDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/staff/schedules".equals(path)) {
            handleSchedulesGet(request, response);
        } else if ("/admin/staff/reviews".equals(path)) {
            handleReviewsGet(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/staff/schedules".equals(path)) {
            handleSchedulesPost(request, response);
        } else if ("/admin/staff/reviews".equals(path)) {
            handleReviewsPost(request, response);
        }
    }

    // ================== SCHEDULES ==================
    private void handleSchedulesGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getDetails".equalsIgnoreCase(action)) {
            handleGetDetails(request, response);
            return;
        }

        String tourIdParam = request.getParameter("tourId");
        
        List<Tour> tours = tourDAO.searchToursAdmin(null, null, null, null);
        request.setAttribute("tours", tours);

        Integer tourId = null;
        if (tourIdParam != null && !tourIdParam.trim().isEmpty()) {
            try {
                tourId = Integer.parseInt(tourIdParam.trim());
                request.setAttribute("selectedTourId", tourId);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Tour ID format!");
            }
        }

        List<TourSchedule> schedules = tourDAO.getAllTourSchedules(tourId);
        request.setAttribute("schedules", schedules);

        dao.EmployeeDAO employeeDAO = new dao.EmployeeDAO();
        List<model.Employee> staffList = employeeDAO.getAllAccounts(null, "Staff", "Active");
        request.setAttribute("staffList", staffList);

        request.getRequestDispatcher("/WEB-INF/views/staff/schedules.jsp").forward(request, response);
    }

    private void handleGetDetails(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String scheduleIdParam = request.getParameter("scheduleId");

        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Missing schedule ID");
            gson.toJson(error, response.getWriter());
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdParam.trim());
            TourSchedule sched = tourDAO.getTourScheduleById(scheduleId);
            if (sched == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Tour schedule not found");
                gson.toJson(error, response.getWriter());
                return;
            }

            Tour tour = tourDAO.getTourByIdAdmin(sched.getTourId());
            List<Booking> bookings = tourDAO.getBookingsByScheduleId(scheduleId);

            Map<String, Object> data = new HashMap<>();
            data.put("schedule", sched);
            data.put("tour", tour);
            data.put("bookings", bookings);

            gson.toJson(data, response.getWriter());
        } catch (NumberFormatException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Invalid schedule ID format");
            gson.toJson(error, response.getWriter());
        }
    }

    private void handleSchedulesPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String tourIdParam = request.getParameter("tourId");

        if ("create".equalsIgnoreCase(action)) {
            handleCreateSchedule(request, response, tourIdParam);
            return;
        }

        if ("delete".equalsIgnoreCase(action)) {
            handleDeleteSchedule(request, response, tourIdParam);
            return;
        }

        if ("reserve".equalsIgnoreCase(action)) {
            handleReserveSlots(request, response, tourIdParam);
            return;
        }
        
        if ("takeTour".equalsIgnoreCase(action)) {
            handleTakeTour(request, response, tourIdParam);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleTakeTour(HttpServletRequest request, HttpServletResponse response, String tourIdParam) throws IOException {
        String scheduleIdParam = request.getParameter("scheduleId");
        if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
            try {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                model.Account account = (model.Account) request.getSession().getAttribute("account");
                if (account != null) {
                    TourSchedule sched = tourDAO.getTourScheduleById(scheduleId);
                    if (sched != null) {
                        if (sched.getAssignedStaffId() != null) {
                            request.getSession().setAttribute("errorMessage", "This tour has already been assigned!");
                        } else {
                            sched.setAssignedStaffId(account.getAccountId());
                            if (tourDAO.updateTourSchedule(sched)) {
                                request.getSession().setAttribute("successMessage", "You have successfully taken the tour!");
                            } else {
                                request.getSession().setAttribute("errorMessage", "Failed to take the tour.");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Invalid request.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleCreateSchedule(HttpServletRequest request, HttpServletResponse response, String tourIdParam)
            throws IOException {
        String formTourIdParam = request.getParameter("formTourId");
        String departureDateStr = request.getParameter("departureDate");
        String returnDateStr = request.getParameter("returnDate");
        String priceParam = request.getParameter("price");
        String totalSlotsParam = request.getParameter("totalSlots");

        if (formTourIdParam == null || departureDateStr == null || returnDateStr == null || priceParam == null || totalSlotsParam == null) {
            request.getSession().setAttribute("errorMessage", "Missing required fields to create schedule!");
            response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
            return;
        }

        try {
            int tourId = Integer.parseInt(formTourIdParam.trim());
            Date departureDate = Date.valueOf(departureDateStr.trim());
            Date returnDate = Date.valueOf(returnDateStr.trim());
            double price = Double.parseDouble(priceParam.trim());
            int totalSlots = Integer.parseInt(totalSlotsParam.trim());

            if (departureDate.after(returnDate)) {
                request.getSession().setAttribute("errorMessage", "Departure date cannot be after return date!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            if (price < 0) {
                request.getSession().setAttribute("errorMessage", "Price cannot be negative!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            if (tourDAO.isScheduleDateExists(tourId, departureDate)) {
                request.getSession().setAttribute("errorMessage", "A schedule with this departure date already exists for this tour!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            if (totalSlots <= 0 || totalSlots > 45) {
                request.getSession().setAttribute("errorMessage", "Capacity must be between 1 and 45!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            TourSchedule sched = new TourSchedule();
            sched.setTourId(tourId);
            sched.setDepartureDate(departureDate);
            sched.setReturnDate(returnDate);
            sched.setPrice(price);
            sched.setTotalSlots(totalSlots);
            sched.setAvailableSlots(totalSlots);
            sched.setStatus("Open");

            boolean success = tourDAO.addTourSchedule(sched);
            if (success) {
                tourDAO.syncTourDurationFromSchedules(tourId);
                request.getSession().setAttribute("successMessage", "Created Tour Schedule successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to create tour schedule in database!");
            }

        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date or number format!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleDeleteSchedule(HttpServletRequest request, HttpServletResponse response, String tourIdParam)
            throws IOException {
        String scheduleIdParam = request.getParameter("scheduleId");

        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Missing schedule ID to delete!");
            response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdParam.trim());
            
            List<Booking> bookings = tourDAO.getBookingsByScheduleId(scheduleId);
            if (bookings != null && !bookings.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Cannot delete Tour Schedule #" + scheduleId + " because it contains active bookings. Please cancel bookings or the schedule instead to protect data integrity.");
            } else {
                boolean success = tourDAO.deleteTourSchedule(scheduleId);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Deleted Tour Schedule #" + scheduleId + " successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete Tour Schedule #" + scheduleId + " from database.");
                }
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid schedule ID format!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleReserveSlots(HttpServletRequest request, HttpServletResponse response, String tourIdParam)
            throws IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        String customerIdentifier = request.getParameter("customerIdentifier");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String numberOfPeopleStr = request.getParameter("numberOfPeople");
        
        String redirectUrl = request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : "");
        
        if (scheduleIdStr == null || customerIdentifier == null || contactName == null || contactPhone == null || numberOfPeopleStr == null) {
            request.getSession().setAttribute("errorMessage", "Missing required fields to reserve slots!");
            response.sendRedirect(redirectUrl);
            return;
        }
        
        try {
            int scheduleId = Integer.parseInt(scheduleIdStr.trim());
            int numberOfPeople = Integer.parseInt(numberOfPeopleStr.trim());
            
            if (numberOfPeople <= 0) {
                request.getSession().setAttribute("errorMessage", "Number of slots must be positive!");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            CustomerDAO customerDAO = new CustomerDAO();
            Account customer = customerDAO.getAccountByUsernameOrEmail(customerIdentifier.trim());
            
            if (customer == null) {
                request.getSession().setAttribute("errorMessage", "Customer account with username or email '" + customerIdentifier + "' not found! Please check and try again.");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            if (!"Customer".equalsIgnoreCase(customer.getRole())) {
                request.getSession().setAttribute("errorMessage", "Found account is a " + customer.getRole() + ", but bookings can only be reserved for Customer accounts!");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            TourSchedule sched = tourDAO.getTourScheduleById(scheduleId);
            if (sched == null) {
                request.getSession().setAttribute("errorMessage", "Tour schedule not found!");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            if (!"Open".equalsIgnoreCase(sched.getStatus())) {
                request.getSession().setAttribute("errorMessage", "This schedule is currently " + sched.getStatus() + " and cannot receive reservations.");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            if (sched.getAvailableSlots() < numberOfPeople) {
                request.getSession().setAttribute("errorMessage", "Not enough available slots! Only " + sched.getAvailableSlots() + " slots left, but tried to reserve " + numberOfPeople + " slots.");
                response.sendRedirect(redirectUrl);
                return;
            }
            
            Booking booking = new Booking();
            booking.setCustomerId(customer.getAccountId());
            booking.setScheduleId(scheduleId);
            booking.setNumberOfPeople(numberOfPeople);
            booking.setContactName(contactName.trim());
            booking.setContactPhone(contactPhone.trim());
            booking.setTotalPrice(numberOfPeople * sched.getPrice());
            booking.setStatus("Confirmed");
            
            boolean success = tourDAO.reserveSlots(booking);
            if (success) {
                request.getSession().setAttribute("successMessage", "Reserved " + numberOfPeople + " slots for " + contactName + " (Account: " + customer.getUsername() + ") successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to reserve slots in the database.");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid format for schedule ID or number of people.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        
        response.sendRedirect(redirectUrl);
    }

    // ================== REVIEWS ==================
    private void handleReviewsGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Review> reviews = reviewDAO.getAllReviewsAdmin();
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("/WEB-INF/views/admin/reviews.jsp").forward(request, response);
    }

    private void handleReviewsPost(HttpServletRequest request, HttpServletResponse response)
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

                boolean success = reviewDAO.updateReviewResponse(reviewId, responseText);
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
                
                boolean success = reviewDAO.updateReviewStatus(reviewId, newStatus);
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

