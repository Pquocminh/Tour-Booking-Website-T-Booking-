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
import service.TourService;
import com.google.gson.Gson;

@WebServlet(name = "StaffScheduleController", urlPatterns = {"/admin/staff/schedules"})
public class StaffScheduleController extends HttpServlet {
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

        request.getRequestDispatcher("/WEB-INF/views/staff/manage-schedules.jsp").forward(request, response);
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

        if ("create".equalsIgnoreCase(action)) {
            handleCreateSchedule(request, response, tourIdParam);
            return;
        }

        if ("delete".equalsIgnoreCase(action)) {
            handleDeleteSchedule(request, response, tourIdParam);
            return;
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

            if (totalSlots <= 0) {
                request.getSession().setAttribute("errorMessage", "Capacity must be greater than zero!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/schedules" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
                return;
            }

            TourSchedule sched = new TourSchedule();
            sched.setTourId(tourId);
            sched.setDepartureDate(departureDate);
            sched.setReturnDate(returnDate);
            sched.setPrice(price);
            sched.setTotalSlots(totalSlots);
            sched.setAvailableSlots(totalSlots); // initially all slots are available
            sched.setStatus("Open");

            boolean success = tourService.addTourSchedule(sched);
            if (success) {
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
            
            // Check if there are any bookings for this schedule
            List<Booking> bookings = tourService.getBookingsByScheduleId(scheduleId);
            if (bookings != null && !bookings.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Cannot delete Tour Schedule #" + scheduleId + " because it contains active bookings. Please cancel bookings or the schedule instead to protect data integrity.");
            } else {
                boolean success = tourService.deleteTourSchedule(scheduleId);
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
}
