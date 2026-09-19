package com.app.models;

import java.sql.Timestamp;

public class Review {

    private int reviewId;
    private int userId;
    private int restaurantId;
    private Integer orderId;
    private double rating;
    private String comment;
    private Timestamp createdAt;

    public Review() {
    }

    public Review(int reviewId, int userId, int restaurantId, Integer orderId, double rating, String comment, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.orderId = orderId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
