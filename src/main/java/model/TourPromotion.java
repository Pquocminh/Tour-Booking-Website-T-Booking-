package model;

public class TourPromotion {
    private int promotionId;
    private int tourId;

    public TourPromotion() {
    }

    public TourPromotion(int promotionId, int tourId) {
        this.promotionId = promotionId;
        this.tourId = tourId;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }
}
