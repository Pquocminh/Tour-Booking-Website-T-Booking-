package service;

import dao.PromotionDAO;
import model.Promotion;
import model.Tour;
import java.util.List;

public class PromotionService {
    private final PromotionDAO promotionDAO = new PromotionDAO();

    public List<Promotion> getAllPromotions() {
        return promotionDAO.getAllPromotions();
    }

    public Promotion getPromotionById(int id) {
        return promotionDAO.getPromotionById(id);
    }

    public List<Tour> getToursByPromotionId(int id) {
        return promotionDAO.getToursByPromotionId(id);
    }

    public boolean addPromotion(Promotion p, List<Integer> tourIds) {
        if (p == null || p.getPromotionName() == null || p.getPromotionName().trim().isEmpty()) {
            return false;
        }
        if (p.getDiscountPercent() <= 0 || p.getDiscountPercent() > 100) {
            return false;
        }
        if (p.getStartDate() == null || p.getEndDate() == null) {
            return false;
        }
        if (p.getStartDate().after(p.getEndDate())) {
            return false;
        }

        p.setPromotionName(p.getPromotionName().trim());
        if (p.getStatus() == null || p.getStatus().trim().isEmpty()) {
            p.setStatus("Active");
        } else {
            p.setStatus(p.getStatus().trim());
        }

        return promotionDAO.addPromotion(p, tourIds);
    }

    public boolean deletePromotion(int id) {
        if (id <= 0) {
            return false;
        }
        return promotionDAO.deletePromotion(id);
    }
}
