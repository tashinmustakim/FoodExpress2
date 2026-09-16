package com.app.dao_implementation;

import com.app.dao.ReviewDAO;
import com.app.models.Review;
import com.app.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    private static final String INSERT_REVIEW =
            "INSERT INTO reviews (user_id, restaurant_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)";

    private static final String SELECT_BY_RESTAURANT =
            "SELECT * FROM reviews WHERE restaurant_id = ? ORDER BY created_at DESC";

    private static final String SELECT_BY_USER =
            "SELECT * FROM reviews WHERE user_id = ? ORDER BY created_at DESC";

    private static final String SELECT_ALL =
            "SELECT * FROM reviews ORDER BY created_at DESC";

    private static final String DELETE_REVIEW =
            "DELETE FROM reviews WHERE review_id = ?";

    private static final String AVG_RATING =
            "SELECT AVG(rating) FROM reviews WHERE restaurant_id = ?";

    private static final String UPDATE_RESTAURANT_RATING =
            "UPDATE restaurants SET rating = ? WHERE restaurant_id = ?";

    @Override
    public void addReview(Review review) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_REVIEW)) {

            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getRestaurantId());

            if (review.getOrderId() != null) {
                stmt.setInt(3, review.getOrderId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setDouble(4, review.getRating());
            stmt.setString(5, review.getComment());
            stmt.executeUpdate();

            // Auto update restaurant average rating
            recalculateRestaurantRating(review.getRestaurantId());

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_RESTAURANT)) {

            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Review> getReviewsByUserId(int userId) {
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_USER)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void deleteReview(int reviewId) {
        int restaurantId = -1;
        // Find restaurant ID before deleting
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT restaurant_id FROM reviews WHERE review_id = ?")) {
            stmt.setInt(1, reviewId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    restaurantId = rs.getInt("restaurant_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_REVIEW)) {

            stmt.setInt(1, reviewId);
            stmt.executeUpdate();

            if (restaurantId != -1) {
                recalculateRestaurantRating(restaurantId);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public double getAverageRatingForRestaurant(int restaurantId) {
        double avg = 0.0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(AVG_RATING)) {

            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    avg = rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return avg;
    }

    private void recalculateRestaurantRating(int restaurantId) {
        double avg = getAverageRatingForRestaurant(restaurantId);
        if (avg <= 0) avg = 4.5; // default fallback if no reviews
        avg = Math.round(avg * 10.0) / 10.0; // round to 1 decimal

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_RESTAURANT_RATING)) {

            stmt.setDouble(1, avg);
            stmt.setInt(2, restaurantId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Review mapReview(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setRestaurantId(rs.getInt("restaurant_id"));

        int orderId = rs.getInt("order_id");
        r.setOrderId(rs.wasNull() ? null : orderId);

        r.setRating(rs.getDouble("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
