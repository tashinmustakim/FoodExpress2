package com.app.controllers;

import com.app.dao.OrderDAO;
import com.app.dao.RestaurantDAO;
import com.app.dao.UserDAO;
import com.app.dao_implementation.OrderDAOImpl;
import com.app.dao_implementation.RestaurantDAOImpl;
import com.app.dao_implementation.UserDAOImpl;
import com.app.models.Order;
import com.app.models.Restaurant;
import com.app.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
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
            case "updateStatus":
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                String status = req.getParameter("status");
                if (status != null && !status.trim().isEmpty()) {
                    orderDAO.updateOrderStatus(orderId, status);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                break;

            default: // list
                List<Order> orderList = orderDAO.getAllOrders();
                Map<Integer, User> userMap = new HashMap<>();
                Map<Integer, Restaurant> restaurantMap = new HashMap<>();

                for (Order o : orderList) {
                    if (!userMap.containsKey(o.getUserId())) {
                        userMap.put(o.getUserId(), userDAO.getUser(o.getUserId()));
                    }
                    if (!restaurantMap.containsKey(o.getRestaurantId())) {
                        restaurantMap.put(o.getRestaurantId(), restaurantDAO.getRestaurantById(o.getRestaurantId()));
                    }
                }

                req.setAttribute("orders", orderList);
                req.setAttribute("userMap", userMap);
                req.setAttribute("restaurantMap", restaurantMap);
                req.getRequestDispatcher("/jsp/admin/orderListAdmin.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
