package controller;

import dao.BookingDAO;
import dao.TourDAO;
import model.Account;
import model.Booking;
import model.TourSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // User must be logged in to book
        Account user = (Account) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
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
            int numberOfPeople = Integer.parseInt(numberOfPeopleStr);

            if (numberOfPeople <= 0) {
                // Invalid input
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }

            TourDAO tourDAO = new TourDAO();
            TourSchedule schedule = tourDAO.getTourScheduleById(scheduleId);

            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }

            if (schedule.getAvailableSlots() < numberOfPeople) {
                // Not enough slots
                request.setAttribute("errorMessage", "Not enough available slots for your group.");
                request.getRequestDispatcher("/WEB-INF/views/guest/tour-details.jsp?id=" + schedule.getTourId()).forward(request, response);
                return;
            }

            double totalPrice = schedule.getPrice() * numberOfPeople;
            
            // Assume contact name and phone from the user profile for simplicity in Iteration 2
            String contactName = user.getFullName();
            String contactPhone = user.getPhone() != null ? user.getPhone() : "0123456789"; 

            double depositPercent = 30.0; // Default fallback
            try {
                dao.SystemSettingDAO sysDao = new dao.SystemSettingDAO();
                String depositSettingStr = sysDao.getSettingValueByKey("deposit_percent");
                if (depositSettingStr != null && !depositSettingStr.trim().isEmpty()) {
                    depositPercent = Double.parseDouble(depositSettingStr);
                }
            } catch (Exception e) {
                e.printStackTrace(); // Keep default if error
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
            booking.setStatus("Pending"); // Initial status

            BookingDAO bookingDAO = new BookingDAO();
            boolean success = bookingDAO.insertBooking(booking);

            if (success) {
                // Redirect to success page
                response.sendRedirect(request.getContextPath() + "/booking?action=success");
            } else {
                request.setAttribute("errorMessage", "Failed to book tour. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/guest/tour-details.jsp?id=" + schedule.getTourId()).forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("success".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/guest/booking-success.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }
}
