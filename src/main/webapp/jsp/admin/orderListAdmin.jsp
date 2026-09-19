<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="pageTitle" value="Manage Orders - Admin" />

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
        .order-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
            text-transform: uppercase;
        }
        .badge-pending {
            background-color: #fff8e1;
            color: #f57f17;
        }
        .badge-preparing {
            background-color: #e3f2fd;
            color: #0288d1;
        }
        .badge-delivery {
            background-color: #e8eaf6;
            color: #3f51b5;
        }
        .badge-delivered {
            background-color: #e8f5e9;
            color: var(--accent-green);
        }
        .badge-cancelled {
            background-color: #ffebee;
            color: var(--accent-red);
        }
        .status-select {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 0.85rem;
            background: white;
            cursor: pointer;
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
                <h1 style="margin: 0; color: var(--dark-text);">Manage Orders</h1>
                <p style="margin: 4px 0 0 0; color: var(--light-text);">View all platform orders and update live delivery status.</p>
            </div>
        </div>

        <!-- ================= ORDERS TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Restaurant</th>
                        <th>Total Amount</th>
                        <th>Current Status</th>
                        <th>Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <!-- Order ID -->
                            <td style="font-weight: 700; color: var(--dark-text);">
                                #${o.orderId}
                            </td>

                            <!-- Customer Name -->
                            <td>
                                <strong style="font-size: 0.95rem; color: var(--dark-text);">${userMap[o.userId].name}</strong><br>
                                <span style="font-size: 0.8rem; color: var(--light-text);">${userMap[o.userId].phone}</span>
                            </td>

                            <!-- Restaurant Name -->
                            <td style="font-weight: 500; color: var(--medium-text);">
                                ${restaurantMap[o.restaurantId].name}
                            </td>

                            <!-- Total Amount -->
                            <td style="font-weight: 700; color: var(--dark-text);">
                                ₹ <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/>
                            </td>

                            <!-- Current Status Badge -->
                            <td>
                                <c:choose>
                                    <c:when test="${o.status eq 'DELIVERED'}">
                                        <span class="order-badge badge-delivered">Delivered</span>
                                    </c:when>
                                    <c:when test="${o.status eq 'OUT_FOR_DELIVERY'}">
                                        <span class="order-badge badge-delivery">Out for Delivery</span>
                                    </c:when>
                                    <c:when test="${o.status eq 'PREPARING'}">
                                        <span class="order-badge badge-preparing">Preparing</span>
                                    </c:when>
                                    <c:when test="${o.status eq 'CANCELLED'}">
                                        <span class="order-badge badge-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="order-badge badge-pending">${o.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <!-- Update Status Action -->
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="get" style="display: flex; gap: 8px; align-items: center;">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                    
                                    <select name="status" class="status-select" onchange="this.form.submit()">
                                        <option value="">-- Change --</option>
                                        <option value="PENDING" ${o.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                                        <option value="PREPARING" ${o.status eq 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                        <option value="OUT_FOR_DELIVERY" ${o.status eq 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                        <option value="DELIVERED" ${o.status eq 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                        <option value="CANCELLED" ${o.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No orders have been placed yet.
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
