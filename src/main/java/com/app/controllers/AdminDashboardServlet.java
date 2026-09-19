package com.app.controllers;

import com.app.dao.OrderDAO;
import com.app.dao.RestaurantDAO;
import com.app.dao.UserDAO;
import com.app.dao_implementation.OrderDAOImpl;
import com.app.dao_implementation.RestaurantDAOImpl;
import com.app.dao_implementation.UserDAOImpl;
import com.app.models.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private RestaurantDAO restaurantDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
        userDAO = new UserDAOImpl();
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        com.app.models.User u = (session != null) ? (com.app.models.User) session.getAttribute("loggedUser") : null;
        return u != null && "admin".equalsIgnoreCase(u.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/user?action=login");
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();
        double totalRevenue = 0;
        for (Order o : orders) {
            // Count all placed/completed orders
            totalRevenue += o.getTotalAmount();
        }

        int totalOrders = orders.size();
        int activeRestaurants = restaurantDAO.getAllRestaurants().size();
        int totalUsers = userDAO.getAllUsers().size();

        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("activeRestaurants", activeRestaurants);
        req.setAttribute("totalUsers", totalUsers);

        req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
    }
}
