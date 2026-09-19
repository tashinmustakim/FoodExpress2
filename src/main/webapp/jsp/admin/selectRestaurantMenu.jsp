<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Select Restaurant Menu - Admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../shared/head.jspf" %>
    <style>
        .admin-header {
            margin-bottom: 24px;
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
        .action-btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-block;
            background-color: var(--primary);
            color: white;
        }
        .action-btn:hover {
            background-color: #e65100;
            transform: translateY(-1px);
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
            <h1 style="margin: 0; color: var(--dark-text);">Manage Menus</h1>
            <p style="margin: 4px 0 0 0; color: var(--light-text);">Select a restaurant below to view, add, edit, or delete its menu items.</p>
        </div>

        <!-- ================= RESTAURANT SELECTION TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Logo</th>
                        <th>Restaurant Details</th>
                        <th>Cuisine</th>
                        <th>Rating</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${restaurants}">
                        <tr>
                            <!-- Image -->
                            <td>
                                <c:choose>
                                    <c:when test="${not empty r.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/${r.imageUrl}" 
                                             alt="${r.name}" 
                                             style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width: 50px; height: 50px; border-radius: 8px; background: #eee; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                                            🍴
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Name & Address -->
                            <td>
                                <strong style="font-size: 1.05rem; color: var(--dark-text);">${r.name}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--light-text);">${r.address}, ${r.city}</span>
                            </td>

                            <!-- Cuisine -->
                            <td style="color: var(--medium-text); font-weight: 500;">
                                ${r.cuisineType}
                            </td>

                            <!-- Rating -->
                            <td>
                                <span style="color: #ffb300; font-weight: 600;">★ ${r.rating}</span>
                            </td>

                            <!-- Action Button -->
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/menu?action=list&restaurantId=${r.restaurantId}" 
                                   class="action-btn">
                                    Manage Menu
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty restaurants}">
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No restaurants found on the platform.
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
