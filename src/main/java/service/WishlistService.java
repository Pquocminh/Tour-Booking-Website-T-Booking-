package service;

import dao.WishlistDAO;
import model.Tour;
import java.util.List;

public class WishlistService {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    public List<Tour> getWishlistTours(int customerId) {
        return wishlistDAO.getWishlistToursByCustomerId(customerId);
    }

    public boolean addToWishlist(int customerId, int tourId) {
        if (wishlistDAO.isWishlisted(customerId, tourId)) {
            return true; // Already wishlisted
        }
        return wishlistDAO.addWishlist(customerId, tourId);
    }

    public boolean removeFromWishlist(int customerId, int tourId) {
        return wishlistDAO.deleteWishlist(customerId, tourId);
    }

    public boolean isWishlisted(int customerId, int tourId) {
        return wishlistDAO.isWishlisted(customerId, tourId);
    }
}
