package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Tour;
import service.WishlistService;

@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist"})
public class WishlistController extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Tour> wishlistTours = wishlistService.getWishlistTours(user.getAccountId());
        request.setAttribute("wishlistTours", wishlistTours);
        request.getRequestDispatcher("/WEB-INF/views/customer/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = request.getParameter("redirectUrl");

        if ("add".equalsIgnoreCase(action)) {
            String tourIdParam = request.getParameter("tourId");
            if (tourIdParam != null && !tourIdParam.isEmpty()) {
                try {
                    int tourId = Integer.parseInt(tourIdParam);
                    wishlistService.addToWishlist(user.getAccountId(), tourId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            // Delete one or more tours
            String[] tourIdsParam = request.getParameterValues("tourId");
            if (tourIdsParam != null && tourIdsParam.length > 0) {
                for (String tourIdStr : tourIdsParam) {
                    try {
                        int tourId = Integer.parseInt(tourIdStr);
                        wishlistService.removeFromWishlist(user.getAccountId(), tourId);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        // Determine where to redirect
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
