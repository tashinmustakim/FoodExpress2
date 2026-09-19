package com.app.controllers;

import com.app.dao.*;
import com.app.dao_implementation.*;
import com.app.models.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/orderSummary")
public class OrderSummaryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    private final MenuItemDAO menuItemDAO = new MenuItemDAOImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        com.app.models.User loggedUser = (session != null) ? (com.app.models.User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user?action=login");
            return;
        }
        int userId = loggedUser.getUserId();

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/orderHistory");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam);

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getUserId() != userId) {
            resp.sendRedirect(req.getContextPath() + "/orderHistory");
            return;
        }

        List<OrderItem> items = orderDAO.getOrderItems(orderId);

        // Fetch Restaurant details
        Restaurant restaurant = restaurantDAO.getRestaurantById(order.getRestaurantId());

        // Fetch MenuItems details
        Set<Integer> menuIds = new HashSet<>();
        for (OrderItem item : items) {
            menuIds.add(item.getMenuItemId());
        }
        Map<Integer, MenuItem> menuItemsMap = menuItemDAO.getMenuItemsAsMap(menuIds);

        // Fetch Address details
        Address address = null;
        if (order.getAddressId() != null) {
            address = addressDAO.getAddressById(order.getAddressId(), userId);
        }

        req.setAttribute("order", order);
        req.setAttribute("items", items);
        req.setAttribute("restaurant", restaurant);
        req.setAttribute("menuItemsMap", menuItemsMap);
        req.setAttribute("address", address);

        req.getRequestDispatcher("/jsp/customer/order_summary.jsp")
                .forward(req, resp);
    }
}
