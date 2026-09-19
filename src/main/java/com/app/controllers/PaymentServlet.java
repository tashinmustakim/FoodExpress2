package com.app.controllers;

import com.app.dao.OrderDAO;
import com.app.dao_implementation.OrderDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Ensure user logged in
        HttpSession session = req.getSession(false);
        com.app.models.User loggedUser = (session != null) ? (com.app.models.User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user?action=login");
            return;
        }
        int userId = loggedUser.getUserId();

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        req.setAttribute("orderId", orderIdParam);

        req.getRequestDispatcher("/jsp/customer/payment.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
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
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        int orderId = Integer.parseInt(orderIdParam);

        // Your DB supports: pending → completed
        orderDAO.updatePaymentStatus(orderId, "completed");

        // After completing payment → restaurant accepts automatically
        orderDAO.updateOrderStatus(orderId, "accepted");

        resp.sendRedirect(req.getContextPath() + "/orderSummary?orderId=" + orderId);
    }
}
