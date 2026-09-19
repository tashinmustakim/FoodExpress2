<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Edit Restaurant - Admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../shared/head.jspf" %>
    <style>
        .form-card {
            max-width: 700px;
            margin: 0 auto 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 30px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-group-full {
            grid-column: span 2;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-text);
            font-size: 0.95rem;
        }
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
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

        <div class="form-card">
            <h2 style="margin: 0 0 8px 0; color: var(--dark-text);">Edit Restaurant</h2>
            <p style="margin: 0 0 24px 0; color: var(--light-text);">Modify details for restaurant: <strong>${restaurant.name}</strong></p>

            <form action="${pageContext.request.contextPath}/admin/restaurants?action=update" method="post">
                <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                
                <div class="form-grid">
                    <!-- Restaurant Name -->
                    <div class="form-group-full">
                        <label class="form-label" for="name">Restaurant Name *</label>
                        <input type="text" id="name" name="name" class="form-control" required value="${restaurant.name}">
                    </div>

                    <!-- Description -->
                    <div class="form-group-full">
                        <label class="form-label" for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3">${restaurant.description}</textarea>
                    </div>

                    <!-- Cuisine Type -->
                    <div>
                        <label class="form-label" for="cuisineType">Cuisine Type *</label>
                        <input type="text" id="cuisineType" name="cuisineType" class="form-control" required value="${restaurant.cuisineType}">
                    </div>

                    <!-- Phone Number -->
                    <div>
                        <label class="form-label" for="phone">Phone Number *</label>
                        <input type="text" id="phone" name="phone" class="form-control" required value="${restaurant.phone}">
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="form-label" for="email">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" value="${restaurant.email}">
                    </div>

                    <!-- Image URL -->
                    <div>
                        <label class="form-label" for="imageUrl">Image URL Path</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${restaurant.imageUrl}">
                    </div>

                    <!-- Address -->
                    <div class="form-group-full">
                        <label class="form-label" for="address">Street Address *</label>
                        <input type="text" id="address" name="address" class="form-control" required value="${restaurant.address}">
                    </div>

                    <!-- City -->
                    <div>
                        <label class="form-label" for="city">City *</label>
                        <input type="text" id="city" name="city" class="form-control" required value="${restaurant.city}">
                    </div>

                    <!-- State -->
                    <div>
                        <label class="form-label" for="state">State *</label>
                        <input type="text" id="state" name="state" class="form-control" required value="${restaurant.state}">
                    </div>

                    <!-- Zip Code -->
                    <div>
                        <label class="form-label" for="zip">Zip Code *</label>
                        <input type="text" id="zip" name="zip" class="form-control" required value="${restaurant.zip}">
                    </div>

                    <!-- Rating -->
                    <div>
                        <label class="form-label" for="rating">Rating (1.0 - 5.0) *</label>
                        <input type="number" id="rating" name="rating" class="form-control" required step="0.1" min="1.0" max="5.0" value="${restaurant.rating}">
                    </div>

                    <!-- Delivery Time -->
                    <div>
                        <label class="form-label" for="deliveryTime">Est. Delivery Time (mins) *</label>
                        <input type="number" id="deliveryTime" name="deliveryTime" class="form-control" required value="${restaurant.deliveryTime}">
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="form-label" for="isActive">Status *</label>
                        <select id="isActive" name="isActive" class="form-control">
                            <option value="true" ${restaurant.active ? 'selected' : ''}>Active</option>
                            <option value="false" ${not restaurant.active ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn btn--secondary">Cancel</a>
                    <button type="submit" class="btn btn--primary">Update Restaurant</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../shared/footer.jspf" %>
</body>
</html>