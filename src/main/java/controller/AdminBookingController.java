package controller;

import dao.BookingDAO;
import model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBookingController", urlPatterns = {"/admin/bookings"})
public class AdminBookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Booking> bookings = bookingDAO.getAllBookings();
        request.setAttribute("bookings", bookings);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            String bookingIdStr = request.getParameter("bookingId");
            String status = request.getParameter("status");

            if (bookingIdStr != null && status != null) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    boolean success = bookingDAO.updateBookingStatus(bookingId, status);
                    if (success) {
                        request.getSession().setAttribute("successMessage", "Updated Booking #" + bookingId + " status to " + status + ".");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Failed to update booking status.");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("errorMessage", "Invalid Booking ID.");
                }
            }
        } else if ("cancel".equals(action)) {
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr != null) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    boolean success = bookingDAO.cancelBooking(bookingId);
                    if (success) {
                        request.getSession().setAttribute("successMessage", "Cancelled Booking #" + bookingId + " successfully and released slots.");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Failed to cancel booking.");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("errorMessage", "Invalid Booking ID.");
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }
}

