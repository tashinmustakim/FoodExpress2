<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Manage Restaurants - Admin" />

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
        .restaurant-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        .badge-active {
            background-color: #e8f5e9;
            color: var(--accent-green);
        }
        .badge-inactive {
            background-color: #ffebee;
            color: var(--accent-red);
        }
        .action-links {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .action-btn {
            padding: 8px 14px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-block;
        }
        .btn-menu {
            background-color: #e3f2fd;
            color: var(--accent-blue);
        }
        .btn-menu:hover {
            background-color: #bbdefb;
        }
        .btn-edit {
            background-color: #fff3e0;
            color: var(--primary);
        }
        .btn-edit:hover {
            background-color: #ffe0b2;
        }
        .btn-delete {
            background-color: #ffebee;
            color: var(--accent-red);
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
                <h1 style="margin: 0; color: var(--dark-text);">Manage Restaurants</h1>
                <p style="margin: 4px 0 0 0; color: var(--light-text);">View, add, edit or delete restaurants in the platform.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/restaurants?action=add" class="btn btn--primary">
                + Add Restaurant
            </a>
        </div>

        <!-- ================= RESTAURANT TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Logo</th>
                        <th>Restaurant Details</th>
                        <th>Cuisine</th>
                        <th>Rating / Time</th>
                        <th>Status</th>
                        <th>Actions</th>
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

                            <!-- Name & Contact -->
                            <td>
                                <strong style="font-size: 1.05rem; color: var(--dark-text);">${r.name}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--light-text);">${r.address}, ${r.city}</span><br>
                                <span style="font-size: 0.8rem; color: var(--medium-text);">${r.phone}</span>
                            </td>

                            <!-- Cuisine -->
                            <td style="color: var(--medium-text); font-weight: 500;">
                                ${r.cuisineType}
                            </td>

                            <!-- Rating & Delivery Time -->
                            <td>
                                <span style="color: #ffb300; font-weight: 600;">★ ${r.rating}</span><br>
                                <small style="color: var(--light-text);">${r.deliveryTime} mins</small>
                            </td>

                            <!-- Status -->
                            <td>
                                <c:choose>
                                    <c:when test="${r.active}">
                                        <span class="restaurant-badge badge-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="restaurant-badge badge-inactive">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Actions -->
                            <td>
                                <div class="action-links">
                                    <a href="${pageContext.request.contextPath}/admin/restaurants?action=edit&id=${r.restaurantId}" 
                                       class="action-btn btn-edit" title="Edit Restaurant Details">
                                        Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/restaurants?action=delete&id=${r.restaurantId}" 
                                       class="action-btn btn-delete" 
                                       onclick="return confirm('Are you sure you want to delete this restaurant and all its menus?');" 
                                       title="Delete Restaurant">
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty restaurants}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No restaurants found. Click "Add Restaurant" to create one.
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
