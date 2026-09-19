<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="pageTitle" value="Customer Reviews - Admin" />

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
        .rating-star {
            color: #ffb300;
            font-weight: 700;
            font-size: 1rem;
        }
        .btn-delete {
            background-color: #ffebee;
            color: var(--accent-red);
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
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
                <h1 style="margin: 0; color: var(--dark-text);">Customer Reviews & Ratings</h1>
                <p style="margin: 4px 0 0 0; color: var(--light-text);">View and moderate all customer reviews submitted for platform restaurants.</p>
            </div>
        </div>

        <!-- ================= REVIEWS TABLE ================= -->
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Review ID</th>
                        <th>Customer</th>
                        <th>Restaurant</th>
                        <th>Rating</th>
                        <th>Comment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="rev" items="${reviews}">
                        <tr>
                            <!-- ID -->
                            <td style="font-weight: 700; color: var(--dark-text);">
                                #${rev.reviewId}
                            </td>

                            <!-- Customer Name -->
                            <td>
                                <strong style="font-size: 0.95rem; color: var(--dark-text);">${userMap[rev.userId].name}</strong><br>
                                <span style="font-size: 0.8rem; color: var(--light-text);">@${userMap[rev.userId].username}</span>
                            </td>

                            <!-- Restaurant Name -->
                            <td style="font-weight: 500; color: var(--medium-text);">
                                ${restaurantMap[rev.restaurantId].name}
                            </td>

                            <!-- Rating -->
                            <td>
                                <span class="rating-star">★ ${rev.rating}</span>
                            </td>

                            <!-- Comment -->
                            <td style="max-width: 350px; font-size: 0.9rem; color: var(--dark-text); line-height: 1.4;">
                                "${rev.comment}"
                            </td>

                            <!-- Delete Action -->
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/reviews?action=delete&reviewId=${rev.reviewId}" 
                                   class="btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this review?');">
                                    Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty reviews}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--light-text); padding: 40px;">
                                No customer reviews have been submitted yet.
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
