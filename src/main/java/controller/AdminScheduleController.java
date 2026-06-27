package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Tour;
import model.TourSchedule;
import service.TourService;

@WebServlet(name = "AdminScheduleController", urlPatterns = {"/admin/schedules"})
public class AdminScheduleController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
}
