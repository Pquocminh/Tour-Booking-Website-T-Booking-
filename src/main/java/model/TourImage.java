package model;

import java.sql.Timestamp;

public class TourImage {
    private int imageId;
    private int tourId;
    private String imageUrl;
    private boolean isThumbnail;
    private Timestamp uploadedAt;

    public TourImage() {
    }

    public TourImage(int imageId, int tourId, String imageUrl, boolean isThumbnail, Timestamp uploadedAt) {
        this.imageId = imageId;
        this.tourId = tourId;
        this.imageUrl = imageUrl;
        this.isThumbnail = isThumbnail;
        this.uploadedAt = uploadedAt;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isThumbnail() {
        return isThumbnail;
    }

    public void setThumbnail(boolean isThumbnail) {
        this.isThumbnail = isThumbnail;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
