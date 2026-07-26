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
        // Parse pagination parameters
        int currentPage = 1;
        int pageSize = 10; // Default 10 bookings per page

        String search = request.getParameter("search");
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

        List<Booking> allBookings = bookingDAO.getAllBookings(search);
        int totalBookings = (allBookings != null) ? allBookings.size() : 0;
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalBookings);
        List<Booking> bookings = (allBookings != null && fromIndex < totalBookings)
                ? allBookings.subList(fromIndex, toIndex)
                : new java.util.ArrayList<>();

        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchKeyword", search);
        
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
                    
                    if ("Confirmed".equals(status)) {
                        StringBuilder errorMsg = new StringBuilder();
                        boolean success = bookingDAO.confirmBooking(bookingId, errorMsg);
                        if (success) {
                            request.getSession().setAttribute("successMessage", "Successfully confirmed Booking #" + bookingId + " and deducted slots.");
                        } else {
                            request.getSession().setAttribute("errorMessage", errorMsg.toString());
                        }
                    } else {
                        boolean success = bookingDAO.updateBookingStatus(bookingId, status);
                        if (success) {
                            request.getSession().setAttribute("successMessage", "Updated Booking #" + bookingId + " status to " + status + ".");
                        } else {
                            request.getSession().setAttribute("errorMessage", "Failed to update booking status.");
                        }
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

