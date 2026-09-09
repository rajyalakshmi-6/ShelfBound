package com.shelfbound.model;

import java.sql.Timestamp;

public class Offer {
    private int offerId;
    private String couponCode;
    private double discountPercentage;
    private String description;
    private double minOrderAmount;
    private String status; // "ACTIVE" or "INACTIVE"
    private Timestamp createdAt;

    public Offer() {
    }

    public Offer(int offerId, String couponCode, double discountPercentage, String description, double minOrderAmount, String status, Timestamp createdAt) {
        this.offerId = offerId;
        this.couponCode = couponCode;
        this.discountPercentage = discountPercentage;
        this.description = description;
        this.minOrderAmount = minOrderAmount;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Offer(String couponCode, double discountPercentage, String description, double minOrderAmount, String status) {
        this.couponCode = couponCode;
        this.discountPercentage = discountPercentage;
        this.description = description;
        this.minOrderAmount = minOrderAmount;
        this.status = status;
    }

    public int getOfferId() {
        return offerId;
    }

    public void setOfferId(int offerId) {
        this.offerId = offerId;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(double minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
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

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }
}
