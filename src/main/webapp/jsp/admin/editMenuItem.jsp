<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Edit Menu Item - Admin" />

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../shared/head.jspf" %>
    <style>
        .form-card {
            max-width: 600px;
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
            <a href="${pageContext.request.contextPath}/admin/menu?action=list&restaurantId=${menuItem.restaurantId}" 
               style="color: var(--primary); font-weight: 600; text-decoration: none;">
                ← Back to Manage Menu
            </a>
        </div>

        <div class="form-card">
            <h2 style="margin: 0 0 8px 0; color: var(--dark-text);">Edit Menu Item</h2>
            <p style="margin: 0 0 24px 0; color: var(--light-text);">Modify details for menu item: <strong>${menuItem.name}</strong></p>

            <form action="${pageContext.request.contextPath}/admin/menu?action=update" method="post">
                <input type="hidden" name="menuItemId" value="${menuItem.menuItemId}">
                <input type="hidden" name="restaurantId" value="${menuItem.restaurantId}">
                
                <div class="form-grid">
                    <!-- Item Name -->
                    <div class="form-group-full">
                        <label class="form-label" for="name">Item Name *</label>
                        <input type="text" id="name" name="name" class="form-control" required value="${menuItem.name}">
                    </div>

                    <!-- Description -->
                    <div class="form-group-full">
                        <label class="form-label" for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3">${menuItem.description}</textarea>
                    </div>

                    <!-- Price -->
                    <div>
                        <label class="form-label" for="price">Price (₹) *</label>
                        <input type="number" id="price" name="price" class="form-control" required step="0.01" min="0" value="${menuItem.price}">
                    </div>

                    <!-- Category -->
                    <div>
                        <label class="form-label" for="category">Category *</label>
                        <input type="text" id="category" name="category" class="form-control" required value="${menuItem.category}">
                    </div>

                    <!-- Type (Veg/Non-Veg) -->
                    <div>
                        <label class="form-label" for="isVeg">Food Type *</label>
                        <select id="isVeg" name="isVeg" class="form-control">
                            <option value="veg" ${menuItem.veg ? 'selected' : ''}>Vegetarian</option>
                            <option value="nonveg" ${not menuItem.veg ? 'selected' : ''}>Non-Vegetarian</option>
                        </select>
                    </div>

                    <!-- Stock Status -->
                    <div>
                        <label class="form-label" for="isAvailable">Stock Status *</label>
                        <select id="isAvailable" name="isAvailable" class="form-control">
                            <option value="available" ${menuItem.available ? 'selected' : ''}>In Stock</option>
                            <option value="unavailable" ${not menuItem.available ? 'selected' : ''}>Out of Stock</option>
                        </select>
                    </div>

                    <!-- Image URL -->
                    <div class="form-group-full">
                        <label class="form-label" for="imageUrl">Image URL Path</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${menuItem.imageUrl}">
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/menu?action=list&restaurantId=${menuItem.restaurantId}" class="btn btn--secondary">Cancel</a>
                    <button type="submit" class="btn btn--primary">Update Menu Item</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../shared/footer.jspf" %>
</body>
</html>