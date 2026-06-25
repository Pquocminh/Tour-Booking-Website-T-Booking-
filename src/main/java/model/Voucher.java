package model;

import java.sql.Date;

public class Voucher {
    private int voucherId;
    private String voucherCode;
    private double discountPercent;
    private double minimumOrderValue;
    private double maxDiscountAmount;
    private int quantity;
    private Date startDate;
    private Date endDate;
    private String status;

    public Voucher() {
    }

    public Voucher(int voucherId, String voucherCode, double discountPercent, double minimumOrderValue, 
                   double maxDiscountAmount, int quantity, Date startDate, Date endDate, String status) {
        this.voucherId = voucherId;
        this.voucherCode = voucherCode;
        this.discountPercent = discountPercent;
        this.minimumOrderValue = minimumOrderValue;
        this.maxDiscountAmount = maxDiscountAmount;
        this.quantity = quantity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getMinimumOrderValue() {
        return minimumOrderValue;
    }

    public void setMinimumOrderValue(double minimumOrderValue) {
        this.minimumOrderValue = minimumOrderValue;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
