<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Manage Menu - Admin" />

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
        .menu-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }
        .badge-veg {
            background-color: #e8f5e9;
            color: var(--accent-green);
            border: 1px solid var(--accent-green);
        }
        .badge-nonveg {
            background-color: #ffebee;
            color: var(--accent-red);
            border: 1px solid var(--accent-red);
        }
        .badge-available {
            background-color: #e8f5e9;
            color: var(--accent-green);
        }
        .badge-unavailable {
            background-color: #eeeeee;
            color: var(--medium-text);
        }
        .action-links {
            display: flex;
            gap: 8px;
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
            <a href="${pageContext.request.contextPath}/admin/restaurants" 
               style="color: var(--primary); font-weight: 600; text-decoration: none;">
                ← Back to Manage Restaurants
            </a>
        </div>

        <div class="admin-header">
            <div>
                <h1 style="margin: 0; color: var(--dark-text);">Manage Menu</h1>
                <p style="margin: 4px 0 0 0; color: var(--light-text);">
                    Restaurant: <strong style="color: var(--dark-text);">${restaurant.name}</strong>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/menu?action=add&restaurantId=${restaurant.restaurantId}" class="btn btn--primary">
                + Add Menu Item
            </a>
        </div>

        <!-- ================= MENU ITEMS TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Item Details</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Type</th>
                        <th>Availability</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${menuItems}">
                        <tr>
                            <!-- Image -->
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/${item.imageUrl}" 
                                             alt="${item.name}" 
                                             style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width: 50px; height: 50px; border-radius: 8px; background: #eee; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                                            🍔
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Name & Description -->
                            <td style="max-width: 300px;">
                                <strong style="font-size: 1.05rem; color: var(--dark-text);">${item.name}</strong><br>
                                <span style="font-size: 0.85rem; color: var(--light-text); line-height: 1.4; display: block; margin-top: 4px;">
                                    ${item.description}
                                </span>
                            </td>

                            <!-- Category -->
                            <td style="color: var(--medium-text); font-weight: 500;">
                                ${item.category}
                            </td>

                            <!-- Price -->
                            <td style="font-weight: 600; color: var(--dark-text);">
                                ₹ ${item.price}
                            </td>

                            <!-- Veg / Non-Veg -->
                            <td>
                                <c:choose>
                                    <c:when test="${item.veg}">
                                        <span class="menu-badge badge-veg">VEG</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="menu-badge badge-nonveg">NON-VEG</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Availability -->
                            <td>
                                <c:choose>
                                    <c:when test="${item.available}">
                                        <span class="menu-badge badge-available">In Stock</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="menu-badge badge-unavailable">Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Actions -->
                            <td>
                                <div class="action-links">
                                    <a href="${pageContext.request.contextPath}/admin/menu?action=edit&id=${item.menuItemId}" 
                                       class="action-btn btn-edit" title="Edit Item Details">
                                        Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/menu?action=delete&id=${item.menuItemId}" 
                                       class="action-btn btn-delete" 
                                       onclick="return confirm('Are you sure you want to delete this menu item?');" 
                                       title="Delete Item">
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty menuItems}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No menu items found for this restaurant. Click "Add Menu Item" to create one.
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
