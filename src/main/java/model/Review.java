package model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int bookingId;
    private int customerId;
    private int rating;
    private String comment;
    private String staffResponse; // Nullable
    private Timestamp responseDate; // Nullable
    private String status; // VISIBLE, HIDDEN
    private Timestamp createdAt;

    public Review() {
    }

    public Review(int reviewId, int bookingId, int customerId, int rating, String comment, 
                  String staffResponse, Timestamp responseDate, String status, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.staffResponse = staffResponse;
        this.responseDate = responseDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getStaffResponse() {
        return staffResponse;
    }

    public void setStaffResponse(String staffResponse) {
        this.staffResponse = staffResponse;
    }

    public Timestamp getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Timestamp responseDate) {
        this.responseDate = responseDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    private String tourName;
    private String customerName;
    private java.sql.Date departureDate;
    private Timestamp bookingDate;

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public java.sql.Date getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(java.sql.Date departureDate) {
        this.departureDate = departureDate;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }
}
