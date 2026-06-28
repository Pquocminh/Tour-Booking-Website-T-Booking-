package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
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

@WebServlet(name = "AdminScheduleController", urlPatterns = {"/admin/schedules"})
public class AdminScheduleController extends HttpServlet {
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

        Integer tourId = null;
        if (tourIdParam != null && !tourIdParam.trim().isEmpty()) {
            try {
                tourId = Integer.parseInt(tourIdParam.trim());
                request.setAttribute("selectedTourId", tourId);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Tour ID format!");
            }
        }

        List<TourSchedule> schedules = tourService.getAllTourSchedules(tourId);
        request.setAttribute("schedules", schedules);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-schedules.jsp").forward(request, response);
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

        if ("cancel".equalsIgnoreCase(action)) {
            String scheduleIdParam = request.getParameter("scheduleId");
            if (scheduleIdParam == null) {
                request.getSession().setAttribute("errorMessage", "Missing schedule ID!");
                response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            try {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                TourSchedule sched = tourService.getTourScheduleById(scheduleId);
                if (sched == null) {
                    request.getSession().setAttribute("errorMessage", "Tour schedule not found!");
                } else if ("Cancelled".equalsIgnoreCase(sched.getStatus()) || "Completed".equalsIgnoreCase(sched.getStatus())) {
                    request.getSession().setAttribute("errorMessage", "Cannot cancel a schedule that is already Cancelled or Completed!");
                } else {
                    sched.setStatus("Cancelled");
                    boolean success = tourService.updateTourSchedule(sched);
                    if (success) {
                        request.getSession().setAttribute("successMessage", "Cancelled Tour Schedule #" + scheduleId + " successfully!");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Failed to cancel tour schedule in database!");
                    }
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid Schedule ID format!");
            }
            response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
            return;
        }

        if ("reserve".equalsIgnoreCase(action)) {
            handleReserveSlots(request, response, tourIdParam);
            return;
        }

        if ("update".equalsIgnoreCase(action)) {
            String scheduleIdParam = request.getParameter("scheduleId");
            String departureDateStr = request.getParameter("departureDate");
            String returnDateStr = request.getParameter("returnDate");
            String priceParam = request.getParameter("price");
            String totalSlotsParam = request.getParameter("totalSlots");
            String status = request.getParameter("status");

            if (scheduleIdParam == null || departureDateStr == null || returnDateStr == null || priceParam == null || totalSlotsParam == null || status == null) {
                request.getSession().setAttribute("errorMessage", "Missing required fields for update!");
                response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            try {
                int scheduleId = Integer.parseInt(scheduleIdParam.trim());
                Date departureDate = Date.valueOf(departureDateStr.trim());
                Date returnDate = Date.valueOf(returnDateStr.trim());
                double price = Double.parseDouble(priceParam.trim());
                int totalSlots = Integer.parseInt(totalSlotsParam.trim());

                if (departureDate.after(returnDate)) {
                    request.getSession().setAttribute("errorMessage", "Departure date cannot be after return date!");
                    response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                    return;
                }

                if (price < 0) {
                    request.getSession().setAttribute("errorMessage", "Price cannot be negative!");
                    response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                    return;
                }

                TourSchedule sched = tourService.getTourScheduleById(scheduleId);
                if (sched == null) {
                    request.getSession().setAttribute("errorMessage", "Tour schedule not found!");
                } else {
                    int bookedSlots = sched.getTotalSlots() - sched.getAvailableSlots();
                    if (totalSlots < bookedSlots) {
                        request.getSession().setAttribute("errorMessage", "Total slots (" + totalSlots + ") cannot be less than booked slots (" + bookedSlots + ")!");
                    } else {
                        int availableSlots = totalSlots - bookedSlots;
                        
                        // Auto-adjust status based on availability if open/full
                        if ("Open".equalsIgnoreCase(status) && availableSlots == 0) {
                            status = "Full";
                        } else if ("Full".equalsIgnoreCase(status) && availableSlots > 0) {
                            status = "Open";
                        }

                        sched.setDepartureDate(departureDate);
                        sched.setReturnDate(returnDate);
                        sched.setPrice(price);
                        sched.setTotalSlots(totalSlots);
                        sched.setAvailableSlots(availableSlots);
                        sched.setStatus(status);

                        boolean success = tourService.updateTourSchedule(sched);
                        if (success) {
                            request.getSession().setAttribute("successMessage", "Updated Tour Schedule #" + scheduleId + " successfully!");
                        } else {
                            request.getSession().setAttribute("errorMessage", "Failed to update tour schedule in database!");
                        }
                    }
                }
            } catch (IllegalArgumentException e) {
                request.getSession().setAttribute("errorMessage", "Invalid date format! Use YYYY-MM-DD.");
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : ""));
    }

    private void handleReserveSlots(HttpServletRequest request, HttpServletResponse response, String tourIdParam)
            throws IOException {
        String scheduleIdStr = request.getParameter("scheduleId");
        String customerIdentifier = request.getParameter("customerIdentifier");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String numberOfPeopleStr = request.getParameter("numberOfPeople");
        
        String redirectUrl = request.getContextPath() + "/admin/schedules" + (tourIdParam != null && !tourIdParam.trim().isEmpty() ? "?tourId=" + tourIdParam : "");
        
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

