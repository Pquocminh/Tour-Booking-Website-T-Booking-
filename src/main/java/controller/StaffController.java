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
        
        if ("edit".equalsIgnoreCase(action)) {
            String scheduleIdParam = request.getParameter("id");
            if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
                try {
                    int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                    TourSchedule schedule = tourDAO.getTourScheduleById(scheduleId);
                    if (schedule != null) {
                        request.setAttribute("schedule", schedule);
                        Tour tour = tourDAO.getTourById(schedule.getTourId());
                        request.setAttribute("tour", tour);
                        
                        dao.EmployeeDAO employeeDAO = new dao.EmployeeDAO();
                        List<model.Employee> staffList = employeeDAO.getAllAccounts(null, "Staff", "Active");
                        request.setAttribute("staffList", staffList);
                        
                        request.getRequestDispatcher("/WEB-INF/views/staff/schedule-form.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/staff/schedules");
            return;
        }

        String tourIdParam = request.getParameter("tourId");
        
        List<Tour> tours = tourDAO.searchToursAdmin(null, null, null, null);
        request.setAttribute("tours", tours);

        Tour selectedTour = null;
        Integer selectedTourId = null;
        String searchQuery = null;
        List<TourSchedule> schedules = null;

        if (tourIdParam != null && !tourIdParam.trim().isEmpty()) {
            String query = tourIdParam.trim();
            searchQuery = query;
            int tourId = -1;
            
            if (query.startsWith("ID: #")) {
                try {
                    int dashIndex = query.indexOf(" - ");
                    if (dashIndex != -1) {
                        tourId = Integer.parseInt(query.substring(5, dashIndex).trim());
                    } else {
                        tourId = Integer.parseInt(query.substring(5).trim());
                    }
                } catch (NumberFormatException e) {
                    // Ignore, fallback to text search
                }
            } else {
                try {
                    tourId = Integer.parseInt(query);
                } catch (NumberFormatException e) {
                    // Not a pure number
                }
            }

            if (tourId > 0) {
                selectedTour = tourDAO.getTourByIdAdmin(tourId);
                if (selectedTour != null) {
                    schedules = tourDAO.getAllTourSchedulesByTourId(tourId);
                    selectedTourId = tourId;
                    searchQuery = "ID: #" + selectedTour.getTourId() + " - " + selectedTour.getTourName();
                } else {
                    schedules = tourDAO.getAllTourSchedulesByKeyword(query);
                }
            } else {
                schedules = tourDAO.getAllTourSchedulesByKeyword(query);
            }
        } else {
            schedules = tourDAO.getAllTourSchedules(null);
        }

        request.setAttribute("selectedTour", selectedTour);
        request.setAttribute("selectedTourId", selectedTourId);
        request.setAttribute("searchQuery", searchQuery);
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

        if ("update".equalsIgnoreCase(action)) {
            handleUpdateSchedule(request, response, tourIdParam);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleUpdateSchedule(HttpServletRequest request, HttpServletResponse response, String tourIdParam) throws IOException {
        String scheduleIdParam = request.getParameter("scheduleId");
        String departureDateStr = request.getParameter("departureDate");
        String returnDateStr = request.getParameter("returnDate");
        String status = request.getParameter("status");
        String priceStr = request.getParameter("price");

        if (scheduleIdParam == null || departureDateStr == null || returnDateStr == null || status == null || priceStr == null || priceStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Missing required fields for update!");
            response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdParam.trim());
            Date departureDate = Date.valueOf(departureDateStr.trim());
            Date returnDate = Date.valueOf(returnDateStr.trim());

            TourSchedule sched = tourDAO.getTourScheduleById(scheduleId);
            if (sched == null) {
                request.getSession().setAttribute("errorMessage", "Tour schedule not found!");
            } else {
                if (!sched.getDepartureDate().equals(departureDate) && tourDAO.isScheduleDateExists(sched.getTourId(), departureDate)) {
                    request.getSession().setAttribute("errorMessage", "A schedule with this departure date already exists for this tour!");
                    response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                    return;
                }

                int bookedSlots = sched.getTotalSlots() - sched.getAvailableSlots();
                int availableSlots = sched.getTotalSlots() - bookedSlots;
                
                if ("Open".equalsIgnoreCase(status) && availableSlots == 0) {
                    status = "Full";
                } else if ("Full".equalsIgnoreCase(status) && availableSlots > 0) {
                    status = "Open";
                }

                double priceVal = Double.parseDouble(priceStr.trim());
                if (priceVal <= 0) {
                    request.getSession().setAttribute("errorMessage", "Schedule price must be greater than 0!");
                    response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                    return;
                }
                sched.setPrice(priceVal);
                sched.setDepartureDate(departureDate);
                sched.setReturnDate(returnDate);
                sched.setStatus(status);
                
                String assignedStaffIdParam = request.getParameter("assignedStaffId");
                if (assignedStaffIdParam != null && !assignedStaffIdParam.trim().isEmpty()) {
                    sched.setAssignedStaffId(Integer.parseInt(assignedStaffIdParam.trim()));
                } else {
                    sched.setAssignedStaffId(null);
                }

                boolean success = tourDAO.updateTourSchedule(sched);
                if (success) {
                    tourDAO.syncTourBasePriceFromSchedules(sched.getTourId());
                    request.getSession().setAttribute("successMessage", "Updated Tour Schedule #" + scheduleId + " successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to update tour schedule in database!");
                }
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format! Use YYYY-MM-DD.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleTakeTour(HttpServletRequest request, HttpServletResponse response, String tourIdParam) throws IOException {
        String scheduleIdParam = request.getParameter("scheduleId");
        if (scheduleIdParam != null && !scheduleIdParam.trim().isEmpty()) {
            try {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                model.Account account = (model.Account) request.getSession().getAttribute("user");
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

            int depYear = departureDate.toLocalDate().getYear();
            int retYear = returnDate.toLocalDate().getYear();

            if (depYear < 2020 || depYear > 2099 || retYear < 2020 || retYear > 2099) {
                request.getSession().setAttribute("errorMessage", "Year must be a valid 4-digit year (2020 - 2099)!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

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
            if (totalSlots < 44) {
                totalSlots = 44;
            } else if (totalSlots % 44 != 0) {
                totalSlots = Math.round((float) totalSlots / 44) * 44;
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
                tourDAO.syncTourBasePriceFromSchedules(tourId);
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
            TourSchedule schedToDelete = tourDAO.getTourScheduleById(scheduleId);
            
            List<Booking> bookings = tourDAO.getBookingsByScheduleId(scheduleId);
            if (bookings != null && !bookings.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Cannot delete Tour Schedule #" + scheduleId + " because it contains active bookings. Please cancel bookings or the schedule instead to protect data integrity.");
            } else {
                boolean success = tourDAO.deleteTourSchedule(scheduleId);
                if (success) {
                    if (schedToDelete != null) {
                        tourDAO.syncTourBasePriceFromSchedules(schedToDelete.getTourId());
                    }
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
            double unitPrice = sched.getPrice();
            dao.PromotionDAO promoDAO = new dao.PromotionDAO();
            model.Promotion activePromo = promoDAO.getActivePromotionByTourId(sched.getTourId());
            if (activePromo != null && activePromo.getDiscountPercent() > 0 && activePromo.getDiscountPercent() <= 100) {
                unitPrice = unitPrice * (100 - activePromo.getDiscountPercent()) / 100.0;
            }
            booking.setTotalPrice(numberOfPeople * unitPrice);
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

        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 reviews per page

        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                int parsedSize = Integer.parseInt(pageSizeParam.trim());
                if (parsedSize > 0) pageSize = parsedSize;
            } catch (NumberFormatException e) {}
        }

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        List<Review> allReviews = reviewDAO.getAllReviewsAdmin();
        int totalReviews = (allReviews != null) ? allReviews.size() : 0;
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalReviews);
        List<Review> reviews = (allReviews != null && fromIndex < totalReviews)
                ? allReviews.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("pageSize", pageSize);

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
                    session.setAttribute("successMessage", "Response saved successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to save response. Please try again.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid review ID.");
            }
        } else if ("toggleStatus".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String currentStatus = request.getParameter("currentStatus");
                
                boolean isCurrentlyVisible = "VISIBLE".equalsIgnoreCase(currentStatus) || "APPROVED".equalsIgnoreCase(currentStatus);
                String newStatus = isCurrentlyVisible ? "HIDDEN" : "Approved";
                
                boolean success = reviewDAO.updateReviewStatus(reviewId, newStatus);
                if (success) {
                    String displayStatus = "HIDDEN".equalsIgnoreCase(newStatus) ? "Hidden" : "Visible";
                    session.setAttribute("successMessage", "Review status updated to " + displayStatus + ".");
                } else {
                    session.setAttribute("errorMessage", "Failed to update review status.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid review ID.");
            }
        }

        String pageParam = request.getParameter("page");
        String redirectUrl = request.getContextPath() + "/admin/staff/reviews";
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            redirectUrl += "?page=" + pageParam.trim();
        }
        response.sendRedirect(redirectUrl);
    }
}

