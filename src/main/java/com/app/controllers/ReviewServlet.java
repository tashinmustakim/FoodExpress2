package com.app.controllers;

import com.app.dao.ReviewDAO;
import com.app.dao_implementation.ReviewDAOImpl;
import com.app.models.Review;
import com.app.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/user?action=login");
            return;
        }

        String action = req.getParameter("action");
        if ("add".equals(action)) {
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
            double rating = Double.parseDouble(req.getParameter("rating"));
            String comment = req.getParameter("comment");

            String orderIdStr = req.getParameter("orderId");
            Integer orderId = (orderIdStr != null && !orderIdStr.trim().isEmpty()) 
                    ? Integer.parseInt(orderIdStr) : null;

            Review review = new Review();
            review.setUserId(user.getUserId());
            review.setRestaurantId(restaurantId);
            review.setOrderId(orderId);
            review.setRating(rating);
            review.setComment(comment);

            reviewDAO.addReview(review);

            if (orderId != null) {
                resp.sendRedirect(req.getContextPath() + "/orderHistory");
            } else {
                resp.sendRedirect(req.getContextPath() + "/restaurant?action=details&restaurantId=" + restaurantId);
            }
        }
    }
}
