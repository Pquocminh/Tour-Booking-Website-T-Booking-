package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Tour;
import model.TourSchedule;
import service.TourService;

@WebServlet(name = "AdminCapacityController", urlPatterns = {"/admin/capacity"})
public class AdminCapacityController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        response.sendRedirect(request.getContextPath() + "/admin/capacity" + (tourIdParam != null ? "?tourId=" + tourIdParam : ""));
    }
}
