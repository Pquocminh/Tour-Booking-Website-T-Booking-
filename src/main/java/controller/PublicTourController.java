package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import dao.WishlistDAO;

import model.Tour;
import dao.PromotionDAO;
import model.Promotion;
import model.Review;
import dao.ReviewDAO;
import dao.TourDAO;

@WebServlet(name = "PublicTourController", urlPatterns = {"/tours", "/tour-detail"})
public class PublicTourController extends HttpServlet {
    private final TourDAO tourDAO = new TourDAO();
    private final PromotionDAO promotionDAO = new PromotionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/tour-detail".equals(path)) {
            viewTourDetail(request, response);
        } else if ("/tours".equals(path)) {
            String searchKeyword = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String destinationFilter = request.getParameter("destination");
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                searchTours(request, response, searchKeyword);
            } else if (categoryFilter != null && !categoryFilter.isEmpty()) {
                filterByCategory(request, response, Integer.parseInt(categoryFilter));
            } else if (destinationFilter != null && !destinationFilter.isEmpty()) {
                filterByDestination(request, response, Integer.parseInt(destinationFilter));
            } else {
                viewTourList(request, response);
            }
        }
    }
    
    private void viewTourList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Tour> tours = tourDAO.getAvailableTours();
        if (tours == null || tours.isEmpty()) {
            request.setAttribute("message", "Currently, there aren't any tours being sold.");
        }
        request.setAttribute("tours", tours);
        request.setAttribute("activePromotions", promotionDAO.getActivePromotions());
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void searchTours(HttpServletRequest request, HttpServletResponse response, String keyword)
            throws ServletException, IOException {
        List<Tour> tours = tourDAO.searchTours(keyword.trim());
        if (tours == null || tours.isEmpty()) {
            request.setAttribute("message", "No tours found matching your search.");
        }
        request.setAttribute("tours", tours);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("isSearchResult", true);
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response, int categoryId)
            throws ServletException, IOException {
        List<Tour> tours = tourDAO.searchToursByCategory(categoryId);
        if (tours == null || tours.isEmpty()) {
            request.setAttribute("message", "No tours available in this category.");
        }
        request.setAttribute("tours", tours);
        request.setAttribute("filterType", "category");
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void filterByDestination(HttpServletRequest request, HttpServletResponse response, int destinationId)
            throws ServletException, IOException {
        List<Tour> tours = tourDAO.searchToursByDestination(destinationId);
        if (tours == null || tours.isEmpty()) {
            request.setAttribute("message", "No tours available for this destination.");
        }
        request.setAttribute("tours", tours);
        request.setAttribute("filterType", "destination");
        request.getRequestDispatcher("/WEB-INF/views/guest/tours.jsp").forward(request, response);
    }
    
    private void viewTourDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        try {
            int tourId = Integer.parseInt(idParam);
            Tour tour = tourDAO.getTourDetails(tourId);
            if (tour == null) {
                response.sendRedirect(request.getContextPath() + "/tours");
                return;
            }
            
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getVisibleReviewsByTourId(tourId);
            request.setAttribute("reviews", reviews);

            double averageRating = 0;
            if (!reviews.isEmpty()) {
                int totalStars = 0;
                for (Review r : reviews) {
                    totalStars += r.getRating();
                }
                averageRating = (double) totalStars / reviews.size();
            }
            request.setAttribute("averageRating", averageRating);

            request.setAttribute("tour", tour);

            HttpSession session = request.getSession(false);
            boolean isInWishlist = false;
            if (session != null) {
                model.Account user = (model.Account) session.getAttribute("user");
                if (user != null) {
                    WishlistDAO wishlistDAO = new WishlistDAO();
                    isInWishlist = wishlistDAO.isInWishlist(user.getAccountId(), tourId);
                }
            }
            request.setAttribute("isInWishlist", isInWishlist);

            request.getRequestDispatcher("/WEB-INF/views/guest/tour-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tours");
        }
    }
}
