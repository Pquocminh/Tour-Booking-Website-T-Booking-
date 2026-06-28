package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.Tour;
import model.TourSchedule;
import model.Booking;
import model.Account;
import service.TourService;
import service.AccountService;
import com.google.gson.Gson;

@WebServlet(name = "AdminCapacityController", urlPatterns = {"/admin/capacity"})
public class AdminCapacityController extends HttpServlet {
    private final TourService tourService = new TourService();
    private final Gson gson = new Gson();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getDetails".equalsIgnoreCase(action)) {
            handleGetDetails(request, response);
            return;
        }

        String tourIdParam = request.getParameter("tourId");
        
        List<Tour> tours = tourService.searchToursAdmin(null, null, null, null);
        request.setAttribute("tours", tours);

        if (tourIdParam != null && !tourIdParam.trim().isEmpty()) {
            try {
                int tourId = Integer.parseInt(tourIdParam.trim());
                Tour selectedTour = tourService.getTourByIdAdmin(tourId);
                if (selectedTour != null) {
                    List<TourSchedule> schedules = tourService.getTourSchedulesAdmin(tourId);
                    request.setAttribute("selectedTour", selectedTour);
                    request.setAttribute("schedules", schedules);
                    request.setAttribute("selectedTourId", tourId);
                } else {
                    request.setAttribute("errorMessage", "Tour not found!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Tour ID format!");
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-capacity.jsp").forward(request, response);
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
            TourSchedule sched = tourService.getTourScheduleById(scheduleId);
            if (sched == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Tour schedule not found");
                gson.toJson(error, response.getWriter());
                return;
            }

            Tour tour = tourService.getTourByIdAdmin(sched.getTourId());
            List<Booking> bookings = tourService.getBookingsByScheduleId(scheduleId);

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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String tourIdParam = request.getParameter("tourId");

        if ("release".equalsIgnoreCase(action)) {
            String scheduleIdParam = request.getParameter("scheduleId");
            String slotsParam = request.getParameter("slotsToRelease");

            if (scheduleIdParam == null || slotsParam == null || tourIdParam == null) {
                request.getSession().setAttribute("errorMessage", "Missing required parameters!");
                response.sendRedirect(request.getContextPath() + "/admin/capacity" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            try {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                int slotsToRelease = Integer.parseInt(slotsParam.trim());
                int tourId = Integer.parseInt(tourIdParam.trim());

                if (slotsToRelease <= 0) {
                    request.getSession().setAttribute("errorMessage", "Number of slots to release must be a positive integer!");
                    response.sendRedirect(request.getContextPath() + "/admin/capacity?tourId=" + tourId);
                    return;
                }

                TourSchedule sched = tourService.getTourScheduleById(scheduleId);
                if (sched == null) {
                    request.getSession().setAttribute("errorMessage", "Tour schedule not found!");
                    response.sendRedirect(request.getContextPath() + "/admin/capacity?tourId=" + tourId);
                    return;
                }

                if ("Cancelled".equalsIgnoreCase(sched.getStatus()) || "Completed".equalsIgnoreCase(sched.getStatus())) {
                    request.getSession().setAttribute("errorMessage", "Cannot release slots for a Cancelled or Completed tour schedule!");
                    response.sendRedirect(request.getContextPath() + "/admin/capacity?tourId=" + tourId);
                    return;
                }

                // Perform slot allocation update
                sched.setTotalSlots(sched.getTotalSlots() + slotsToRelease);
                sched.setAvailableSlots(sched.getAvailableSlots() + slotsToRelease);

                // Update status from Full to Open if we add capacity
                if ("Full".equalsIgnoreCase(sched.getStatus()) && sched.getAvailableSlots() > 0) {
                    sched.setStatus("Open");
                }

                boolean success = tourService.updateTourSchedule(sched);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Released " + slotsToRelease + " slots successfully for Schedule #" + scheduleId + "!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to update tour schedule capacity in database!");
                }

                response.sendRedirect(request.getContextPath() + "/admin/capacity?tourId=" + tourId);
                return;

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid numeric parameters format!");
                response.sendRedirect(request.getContextPath() + "/admin/capacity" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }
        }

        if ("reserve".equalsIgnoreCase(action)) {
            handleReserveSlots(request, response, tourIdParam);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/capacity" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleReserveSlots(HttpServletRequest request, HttpServletResponse response, String tourIdParam)
            throws IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        String customerIdentifier = request.getParameter("customerIdentifier");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String numberOfPeopleStr = request.getParameter("numberOfPeople");
        
        String redirectUrl = request.getContextPath() + "/admin/capacity" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : "");
        
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
            
            AccountService accountService = new AccountService();
            Account customer = accountService.getAccountByUsernameOrEmail(customerIdentifier.trim());
            
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
            
            TourSchedule sched = tourService.getTourScheduleById(scheduleId);
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
            
            boolean success = tourService.reserveSlots(booking);
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
}
