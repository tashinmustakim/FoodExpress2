package com.app.dao;

import com.app.models.Review;
import java.util.List;

public interface ReviewDAO {

    void addReview(Review review);

    List<Review> getReviewsByRestaurantId(int restaurantId);

    List<Review> getReviewsByUserId(int userId);

    List<Review> getAllReviews();

    void deleteReview(int reviewId);

    double getAverageRatingForRestaurant(int restaurantId);
}
