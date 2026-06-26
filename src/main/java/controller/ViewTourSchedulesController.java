package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Tour;
import model.TourSchedule;
import model.Account;
import service.TourService;

@WebServlet(name = "ViewTourSchedulesController", urlPatterns = {"/view-tour-schedules", "/admin/view-tour-schedules"})
public class ViewTourSchedulesController extends HttpServlet {
    private final TourService tourService = new TourService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            if ("/admin/view-tour-schedules".equals(path)) {
                response.sendRedirect(request.getContextPath() + "/admin/tours");
            } else {
                response.sendRedirect(request.getContextPath() + "/tours");
            }
            return;
        }

        try {
            int tourId = Integer.parseInt(idParam);
            Tour tour = tourService.getTourById(tourId);

            if (tour == null) {
                if ("/admin/view-tour-schedules".equals(path)) {
                    response.sendRedirect(request.getContextPath() + "/admin/tours");
                } else {
                    response.sendRedirect(request.getContextPath() + "/tours");
                }
                return;
            }

            if ("/admin/view-tour-schedules".equals(path)) {
                // Admin/Staff check
                HttpSession session = request.getSession();
                Account user = (Account) session.getAttribute("user");
                if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                // Fetch all schedules for admin (past and future)
                List<TourSchedule> schedules = tourService.getTourSchedulesAdmin(tourId);
                request.setAttribute("tour", tour);
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("/WEB-INF/views/admin/view-tour-schedules.jsp").forward(request, response);
            } else {
                // Guest / Customer view - active future schedules
                List<TourSchedule> schedules = tourService.getTourSchedules(tourId);
                request.setAttribute("tour", tour);
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("/WEB-INF/views/guest/view-tour-schedules.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            if ("/admin/view-tour-schedules".equals(path)) {
                response.sendRedirect(request.getContextPath() + "/admin/tours");
            } else {
                response.sendRedirect(request.getContextPath() + "/tours");
            }
        }
    }
}
