package com.app.controllers;

import com.app.dao.UserDAO;
import com.app.dao_implementation.UserDAOImpl;
import com.app.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
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
                int delUserId = Integer.parseInt(req.getParameter("userId"));
                userDAO.deleteUser(delUserId);
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;

            case "changeRole":
                int userId = Integer.parseInt(req.getParameter("userId"));
                String newRole = req.getParameter("role");
                if (newRole != null && !newRole.trim().isEmpty()) {
                    User u = userDAO.getUser(userId);
                    if (u != null) {
                        u.setRole(newRole);
                        userDAO.updateUser(u);
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;

            default: // list
                List<User> userList = userDAO.getAllUsers();
                req.setAttribute("users", userList);
                req.getRequestDispatcher("/jsp/admin/userListAdmin.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
