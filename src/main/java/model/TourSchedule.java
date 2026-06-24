package model;

import java.sql.Date;

public class TourSchedule {
    private int scheduleId;
    private int tourId;
    private Date departureDate;
    private Date returnDate;
    private double price;
    private int availableSlots;
    private String status;

    public TourSchedule() {
    }

    public TourSchedule(int scheduleId, int tourId, Date departureDate, Date returnDate, double price, int availableSlots, String status) {
        this.scheduleId = scheduleId;
        this.tourId = tourId;
        this.departureDate = departureDate;
        this.returnDate = returnDate;
        this.price = price;
        this.availableSlots = availableSlots;
        this.status = status;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public Date getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(Date departureDate) {
        this.departureDate = departureDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getAvailableSlots() {
        return availableSlots;
    }

    public void setAvailableSlots(int availableSlots) {
        this.availableSlots = availableSlots;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
