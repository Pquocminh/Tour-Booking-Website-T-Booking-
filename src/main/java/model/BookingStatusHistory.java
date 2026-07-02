package model;

import java.sql.Timestamp;

public class BookingStatusHistory {
    private int historyId;
    private int bookingId;
    private String status;
    private int changedBy;
    private Timestamp changedAt;
    private String note;

    // Constructors
    public BookingStatusHistory() {
    }

    public BookingStatusHistory(int historyId, int bookingId, String status, int changedBy, Timestamp changedAt, String note) {
        this.historyId = historyId;
        this.bookingId = bookingId;
        this.status = status;
        this.changedBy = changedBy;
        this.changedAt = changedAt;
        this.note = note;
    }

    // Getters and Setters
    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
