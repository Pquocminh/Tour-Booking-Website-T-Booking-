package model;

import java.sql.Timestamp;

public class Wishlist {
    private int customerId;
    private int tourId;
    private Timestamp addedAt;

    public Wishlist() {
    }

    public Wishlist(int customerId, int tourId, Timestamp addedAt) {
        this.customerId = customerId;
        this.tourId = tourId;
        this.addedAt = addedAt;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public Timestamp getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }
}
