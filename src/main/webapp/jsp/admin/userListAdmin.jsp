<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Manage Users - Admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../shared/head.jspf" %>
    <style>
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }
        .admin-table th, .admin-table td {
            padding: 16px 20px;
            text-align: left;
        }
        .admin-table th {
            background-color: var(--dark-text);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        .admin-table tr {
            border-bottom: 1px solid var(--border-color);
            transition: background 0.2s;
        }
        .admin-table tr:hover {
            background-color: #fafafa;
        }
        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            text-transform: uppercase;
        }
        .badge-admin {
            background-color: #ede7f6;
            color: #673ab7;
        }
        .badge-customer {
            background-color: #e8f5e9;
            color: var(--accent-green);
        }
        .badge-delivery {
            background-color: #fff3e0;
            color: var(--primary);
        }
        .action-links {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .role-select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 0.85rem;
            background: white;
        }
        .btn-delete {
            background-color: #ffebee;
            color: var(--accent-red);
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
        }
        .btn-delete:hover {
            background-color: #ffcdd2;
        }
    </style>
</head>
<body>
    <%@ include file="../shared/header.jspf" %>

    <div class="container main-content">
        <!-- ================= BREADCRUMB / NAV ================= -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               style="color: var(--primary); font-weight: 600; text-decoration: none;">
                ← Back to Dashboard
            </a>
        </div>

        <div class="admin-header">
            <div>
                <h1 style="margin: 0; color: var(--dark-text);">Manage Users</h1>
                <p style="margin: 4px 0 0 0; color: var(--light-text);">View all registered users and manage account permissions.</p>
            </div>
        </div>

        <!-- ================= USERS TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>User Details</th>
                        <th>Contact Info</th>
                        <th>Role</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <!-- User ID -->
                            <td style="font-weight: 700; color: var(--dark-text);">
                                #${u.userId}
                            </td>

                            <!-- Name & Username -->
                            <td>
                                <strong style="font-size: 0.95rem; color: var(--dark-text);">${u.name}</strong><br>
                                <span style="font-size: 0.8rem; color: var(--light-text);">@${u.username}</span>
                            </td>

                            <!-- Email & Phone -->
                            <td>
                                <span style="font-size: 0.9rem; color: var(--dark-text);">${u.email}</span><br>
                                <span style="font-size: 0.8rem; color: var(--light-text);">${u.phone}</span>
                            </td>

                            <!-- Role Badge -->
                            <td>
                                <c:choose>
                                    <c:when test="${u.role eq 'admin'}">
                                        <span class="role-badge badge-admin">Admin</span>
                                    </c:when>
                                    <c:when test="${u.role eq 'delivery'}">
                                        <span class="role-badge badge-delivery">Delivery</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge badge-customer">Customer</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Address -->
                            <td style="font-size: 0.85rem; color: var(--medium-text); max-width: 200px;">
                                ${empty u.address ? 'N/A' : u.address}
                            </td>

                            <!-- Actions -->
                            <td>
                                <div class="action-links">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="get" style="display: inline;">
                                        <input type="hidden" name="action" value="changeRole">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        
                                        <select name="role" class="role-select" onchange="this.form.submit()">
                                            <option value="customer" ${u.role eq 'customer' ? 'selected' : ''}>Customer</option>
                                            <option value="admin" ${u.role eq 'admin' ? 'selected' : ''}>Admin</option>
                                            <option value="delivery" ${u.role eq 'delivery' ? 'selected' : ''}>Delivery</option>
                                        </select>
                                    </form>

                                    <c:if test="${u.userId != sessionScope.loggedUser.userId}">
                                        <a href="${pageContext.request.contextPath}/admin/users?action=delete&userId=${u.userId}" 
                                           class="btn-delete" 
                                           onclick="return confirm('Are you sure you want to delete this user?');">
                                            Delete
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No users found on the platform.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>

    <%@ include file="../shared/footer.jspf" %>
</body>
</html>
