package controller;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Booking;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // Authorization check
        if (user == null || (!"Admin".equalsIgnoreCase(user.getRole()) && !"Staff".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch statistics
        int totalUsers = dashboardDAO.getTotalUsers();
        int totalTours = dashboardDAO.getTotalTours();
        int totalBookings = dashboardDAO.getTotalBookings();
        double totalRevenue = dashboardDAO.getTotalRevenue();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTours", totalTours);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalRevenue", totalRevenue);

        List<Booking> recentBookings = dashboardDAO.getRecentBookings(5);
        request.setAttribute("recentBookings", recentBookings);

        // Fetch Real Data for charts
        String[] revenueData = dashboardDAO.getRevenueLast7Days();
        request.setAttribute("salesLabels", revenueData[0]);
        request.setAttribute("salesData", revenueData[1]);
        
        request.setAttribute("donutData", dashboardDAO.getBookingStatusDistribution());
        
        request.setAttribute("barData1", "[60, 45, 80, 50, 70]"); // Sample Series 1
        request.setAttribute("barData2", "[40, 30, 50, 30, 50]"); // Sample Series 2

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
