package com.app.controllers;

import com.app.dao.RestaurantDAO;
import com.app.dao.ReviewDAO;
import com.app.dao.UserDAO;
import com.app.dao_implementation.RestaurantDAOImpl;
import com.app.dao_implementation.ReviewDAOImpl;
import com.app.dao_implementation.UserDAOImpl;
import com.app.models.Restaurant;
import com.app.models.Review;
import com.app.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;
    private UserDAO userDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAOImpl();
        userDAO = new UserDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        return u != null && "admin".equalsIgnoreCase(u.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/user?action=login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                int delReviewId = Integer.parseInt(req.getParameter("reviewId"));
                reviewDAO.deleteReview(delReviewId);
                resp.sendRedirect(req.getContextPath() + "/admin/reviews");
                break;

            default: // list
                List<Review> reviewList = reviewDAO.getAllReviews();
                Map<Integer, User> userMap = new HashMap<>();
                Map<Integer, Restaurant> restaurantMap = new HashMap<>();

                for (Review r : reviewList) {
                    if (!userMap.containsKey(r.getUserId())) {
                        userMap.put(r.getUserId(), userDAO.getUser(r.getUserId()));
                    }
                    if (!restaurantMap.containsKey(r.getRestaurantId())) {
                        restaurantMap.put(r.getRestaurantId(), restaurantDAO.getRestaurantById(r.getRestaurantId()));
                    }
                }

                req.setAttribute("reviews", reviewList);
                req.setAttribute("userMap", userMap);
                req.setAttribute("restaurantMap", restaurantMap);
                req.getRequestDispatcher("/jsp/admin/reviewListAdmin.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
