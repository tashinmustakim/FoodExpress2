# 📑 FoodXpress — Controllers Comprehensive Guide & Code Explanation

This document provides a detailed breakdown of all **17 Web Controllers (Servlets)** in the **FoodXpress** web application, explaining their responsibilities, HTTP methods (`doGet`, `doPost`), code logic, and how they interact with the DAO layer and JSP views.

---

## 🧭 Overview of Architecture

In the FoodXpress MVC Architecture, **Controllers (Servlets)** intercept incoming HTTP requests, process user input, interact with MySQL via the Data Access Object (DAO) layer, update Session/Request scopes, and forward the user to the appropriate JSP view.

```text
HTTP Request ──► [Servlet Controller] ──► [DAO Layer] ──► [MySQL DB]
                          │
                          ▼
                 [Request Attributes] ──► Forward to [JSP View]
```

---

## 👤 Part A: Customer Controllers (Customer Portal)

### 1. `UserServlet.java`
* **URL Mapping**: `/user`
* **Responsibility**: Manages user authentication lifecycle including registration, login, logout, password verification, and session role assignment.
* **Key Logic & Flow**:
  * `action=register`: Accepts `name`, `username`, `password`, `email`, `phone`, `address`. Encrypts password using BCrypt and inserts record into `users` table via `UserDAO.registerUser()`.
  * `action=login`: Validates credentials via `UserDAO.loginUser()`. If valid, stores `loggedUser` and `role` in `HttpSession`.
  * **Role-Based Redirect**: If `role == 'admin'`, redirects to `/admin/dashboard` (triggering analytics Servlet). If `role == 'customer'`, redirects to `/jsp/customer/home.jsp`.
  * `action=logout`: Invalidates `HttpSession` and redirects to login view.

---

### 2. `RestaurantServlet.java`
* **URL Mapping**: `/restaurant`
* **Responsibility**: Handles restaurant discovery, listing, and individual restaurant detail views.
* **Key Logic & Flow**:
  * `action=list`: Calls `RestaurantDAO.getAllRestaurants()`, filters active Bangladeshi restaurants (e.g., Kacchi Bhai, Sultan's Dine, Star Kabab), attaches the list to request scope as `${restaurants}`, and forwards to `restaurantList.jsp`.
  * `action=details`: Accepts `restaurantId`, fetches restaurant profile and its menu items via `MenuDAO.getMenuItemsByRestaurantId()`, fetches customer reviews via `ReviewDAO.getReviewsByRestaurantId()`, and forwards to `restaurantDetails.jsp`.

---

### 3. `CartServlet.java`
* **URL Mapping**: `/cart`
* **Responsibility**: Manages the customer's active shopping cart session.
* **Key Logic & Flow**:
  * `action=add`: Accepts `menuItemId` and `quantity`. Retrieves or initializes `Cart` in `HttpSession`. Adds item or increments quantity.
  * `action=update`: Updates item quantity in the cart.
  * `action=delete`: Removes an item from the cart.
  * **Price & Tax Calculations**: Computes `subtotal`, `deliveryFee` (৳20), `platformFee` (৳5), `tax` (3%), and `grandTotal` in Bangladeshi Taka (৳). Forwards to `cart.jsp`.

---

### 4. `CheckoutServlet.java`
* **URL Mapping**: `/checkout`
* **Responsibility**: Processes order placement, creates order database records, and clears shopping cart.
* **Key Logic & Flow**:
  * `doGet()`: Renders order summary, selected delivery address, and payment options on `checkout.jsp`.
  * `doPost()`: Accepts `addressId`, `paymentMethod`. Creates a new `Order` entity with status `PENDING`. Saves order via `OrderDAO.createOrder()`. Saves itemized records via `OrderItemDAO.addOrderItems()`. Clears active cart session. Redirects to `/orderSuccess?orderId=X`.

---

### 5. `OrderHistoryServlet.java`
* **URL Mapping**: `/orderHistory`
* **Responsibility**: Displays past orders placed by the logged-in customer.
* **Key Logic & Flow**:
  * Obtains `userId` from `sessionScope.loggedUser`.
  * Calls `OrderDAO.getOrdersByUserId(userId)`.
  * Maps order items and restaurant profiles per order.
  * Forwards order list with status badges (`PENDING`, `PREPARING`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`) to `orderHistory.jsp`.

---

### 6. `ReviewServlet.java`
* **URL Mapping**: `/review`
* **Responsibility**: Handles customer star rating (1–5 Stars) and feedback comment submissions.
* **Key Logic & Flow**:
  * Accepts `restaurantId`, `rating` (1 to 5), and `reviewText`.
  * Validates customer session.
  * Inserts review record via `ReviewDAO.addReview(review)`.
  * **Automated Rating Update**: Invokes `ReviewDAO.updateRestaurantAverageRating(restaurantId)` to automatically calculate the new average rating across all reviews and update the `restaurants` table.
  * Redirects back to `/restaurant?action=details&id=X`.

---

### 7. `AddressServlet.java`
* **URL Mapping**: `/address`
* **Responsibility**: Manages customer delivery addresses (Add, Edit, Delete).
* **Key Logic & Flow**: Accepts `street`, `city`, `zip`, `landmark`. Persists address linked to `userId` in `addresses` table via `AddressDAO`.

---

### 8. `OrderSummaryServlet.java` & `PaymentServlet.java` & `OrderSuccessServlet.java`
* **URL Mappings**: `/orderSummary`, `/payment`, `/orderSuccess`
* **Responsibility**: Secondary checkout workflow controllers handling order confirmation steps, payment gateway simulation (`bKash`, `Nagad`, `Card`, `COD`), and invoice rendering.

---

## 🛡️ Part B: Administrator Controllers (Admin Portal)

### 12. `AdminDashboardServlet.java`
* **URL Mapping**: `/admin/dashboard`
* **Responsibility**: Central controller powering the Admin Analytics Dashboard.
* **Key Logic & Flow**:
  * Intercepts admin navigation requests.
  * Executes live SQL aggregations:
    * `totalRevenue`: Sum of all non-cancelled order amounts (`OrderDAO.getTotalRevenue()`).
    * `totalOrders`: Count of all platform orders (`OrderDAO.getAllOrders().size()`).
    * `activeRestaurants`: Count of active restaurants (`RestaurantDAO.getAllRestaurants().size()`).
    * `totalUsers`: Count of registered accounts (`UserDAO.getAllUsers().size()`).
  * Attaches all 4 metrics to request scope and forwards to `/jsp/admin/dashboard.jsp`.

---

### 13. `AdminOrderServlet.java`
* **URL Mapping**: `/admin/orders`
* **Responsibility**: Administrator order management and live status dispatching.
* **Key Logic & Flow**:
  * `action=list`: Fetches all platform orders across all users and restaurants via `OrderDAO.getAllOrders()`. Maps user names and restaurant names. Forwards to `orderListAdmin.jsp`.
  * `action=updateStatus`: Accepts `orderId` and `status` (`PENDING`, `PREPARING`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`). Updates order status in MySQL via `OrderDAO.updateOrderStatus()`.

---

### 14. `AdminUserServlet.java`
* **URL Mapping**: `/admin/users`
* **Responsibility**: User account oversight and role management.
* **Key Logic & Flow**:
  * `action=list`: Fetches all registered users via `UserDAO.getAllUsers()`. Forwards to `userListAdmin.jsp`.
  * `action=changeRole`: Accepts `userId` and `role` (`customer`, `admin`, `delivery`). Updates user role in MySQL.
  * `action=delete`: Deletes a user account from the platform.

---

### 15. `AdminReviewServlet.java`
* **URL Mapping**: `/admin/reviews`
* **Responsibility**: Review moderation and platform rating monitoring.
* **Key Logic & Flow**: Fetches all customer reviews across restaurants via `ReviewDAO.getAllReviews()`. Allows administrators to review customer feedback and moderate inappropriate reviews.

---

### 16 & 17. `AdminRestaurantServlet.java` & `AdminMenuServlet.java`
* **URL Mappings**: `/admin/restaurants`, `/admin/menu`
* **Responsibility**: Full CRUD controllers for managing restaurant profiles and dishes.
* **Key Logic & Flow**: Allows admins to add new Bangladeshi restaurants, edit cuisine/address details, add new dishes, update pricing in Taka (৳), and toggle dish availability.

---

## 📌 Summary Matrix of All 17 Controllers

| # | Servlet Name | URL Mapping | Access Level | Primary Function |
| :---: | :--- | :--- | :---: | :--- |
| **1** | `UserServlet` | `/user` | Guest / All | Authentication, Register, Login, Logout |
| **2** | `RestaurantServlet` | `/restaurant` | Customer | Browse Bangladeshi restaurants & details |
| **3** | `CartServlet` | `/cart` | Customer | Manage cart items, Taka (৳) total calculations |
| **4** | `CheckoutServlet` | `/checkout` | Customer | Process order placement & save to MySQL |
| **5** | `OrderHistoryServlet` | `/orderHistory` | Customer | Display customer order history & status |
| **6** | `ReviewServlet` | `/review` | Customer | Submit 1–5 star ratings & review comments |
| **7** | `AddressServlet` | `/address` | Customer | Add and manage delivery addresses |
| **8** | `OrderSummaryServlet` | `/orderSummary` | Customer | Render pre-checkout itemized invoice |
| **9** | `PaymentServlet` | `/payment` | Customer | Process payment methods (bKash/COD/Card) |
| **10** | `OrderSuccessServlet` | `/orderSuccess` | Customer | Render order confirmation page |
| **11** | `MenuServlet` | `/menu` | Customer | Fetch menu items per restaurant |
| **12** | `AdminDashboardServlet` | `/admin/dashboard` | Admin Only | Calculate live Revenue (৳), Orders, Users |
| **13** | `AdminOrderServlet` | `/admin/orders` | Admin Only | View all platform orders & update delivery status |
| **14** | `AdminUserServlet` | `/admin/users` | Admin Only | Manage user accounts & elevate roles |
| **15** | `AdminReviewServlet` | `/admin/reviews` | Admin Only | Moderate customer ratings & reviews |
| **16** | `AdminRestaurantServlet` | `/admin/restaurants` | Admin Only | Add, edit, and delete restaurants |
| **17** | `AdminMenuServlet` | `/admin/menu` | Admin Only | Add, edit, and delete restaurant dishes |

---

*Document generated for FoodXpress Java EE Web Application.*
