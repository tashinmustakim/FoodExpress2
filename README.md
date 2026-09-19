# 🍔 FoodXpress — Full-Stack Online Food Delivery & Management System

**FoodXpress** is a modern, enterprise-grade Java EE web application for online food delivery, restaurant discovery, order tracking, real-time administrative analytics, and customer review moderation.

---

## 🚀 Key Features Overview

### 👤 Customer Experience
* 🔐 **Authentication & Security**: Account registration, secure login, password encryption, and session management.
* 🍴 **Restaurant Discovery**: Browse curated restaurants with cuisine filtering, address details, and live star ratings.
* 🛒 **Interactive Shopping Cart**: Dynamic cart session management with real-time subtotal, tax, delivery fee, and grand total calculations.
* 💳 **Checkout & Order Placement**: Streamlined order placement with delivery address assignment and instant invoice generation.
* 📦 **Order Tracking & History**: Itemized order history log with live delivery status badges (`PENDING`, `PREPARING`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`).
* ⭐ **Customer Ratings & Reviews**: Submit 1–5 star ratings and written feedback per restaurant with automated average rating recalculation.

### 🛡️ Admin Management & Analytics
* 📊 **Live Analytics Dashboard**: Real-time business overview tracking **Total Revenue (₹)**, **Total Orders**, **Active Restaurants**, and **Registered Users**.
* 🏪 **Restaurant Management**: Add new restaurants, update cuisine/address/image details, and remove listings.
* 📜 **Menu Management**: Manage restaurant menus, update dish pricing, and toggle item availability.
* 🚚 **Live Order Dispatching**: View all platform orders and update live delivery status in real-time.
* 👥 **User Role Management**: View registered accounts, elevate user permissions (`customer`, `delivery`, `admin`), and moderate platform access.
* 💬 **Review Moderation**: View customer feedback and monitor platform rating standards.

---

## 🏗️ Architecture & Technology Stack

FoodXpress is built following the **Model-View-Controller (MVC)** architectural design pattern:

```text
       ┌─────────────────────────────────────────────────────────┐
       │                       Browser UI                        │
       └────────────────────────────┬────────────────────────────┘
                                    │ HTTP Requests / JSP Responses
       ┌────────────────────────────▼────────────────────────────┐
       │               Controller Layer (Java Servlets)          │
       │   UserServlet, RestaurantServlet, AdminDashboardServlet...  │
       └────────────────────────────┬────────────────────────────┘
                                    │ Invokes DAO Methods
       ┌────────────────────────────▼────────────────────────────┐
       │                 Data Access Layer (DAOs)                │
       │     UserDAO, RestaurantDAO, OrderDAO, ReviewDAO...      │
       └────────────────────────────┬────────────────────────────┘
                                    │ JDBC Queries (SQL)
       ┌────────────────────────────▼────────────────────────────┐
       │                 Database Layer (MySQL 8.0)              │
       │                   food_delivery_app                     │
       └─────────────────────────────────────────────────────────┘
```

### 🛠️ Tech Stack:
* **Backend**: Java EE 8 (Servlets, JSTL 1.2), Apache Maven
* **Frontend**: HTML5, Vanilla CSS3 (Custom Glassmorphism & Micro-animations), JSP (JavaServer Pages)
* **Database**: MySQL 8.0 with JDBC Driver (`mysql-connector-j`)
* **Application Server**: Embedded Eclipse Jetty 10 / Apache Tomcat 9+
* **Security**: `AuthFilter` (Role-based HTTP Access Control Filter)

---

## 🗄️ Database Schema & Entities

The underlying MySQL database `food_delivery_app` consists of 7 normalized tables:
* `users` — Account profiles, hashed credentials, contact info, and roles (`admin`, `customer`, `delivery`).
* `restaurants` — Restaurant profile, cuisine type, address, image URL, and average rating.
* `menu` — Dish name, description, price, rating, image URL, and restaurant mapping.
* `orders` — Order metadata, total amount, status, user ID, and restaurant ID.
* `order_items` — Itemized order details, quantity, and item pricing.
* `cart` / `cart_item` — Session shopping cart state.
* `reviews` — Customer review text, star rating (1–5), user ID, restaurant ID, and timestamp.

---

## 📁 Repository Directory Structure

```text
FoodExpress/
├── README.md                              <-- Project Documentation
├── pom.xml                                <-- Maven Project Object Model
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── app/
        │           ├── models/            <-- Entity Models (User, Restaurant, Order, Review...)
        │           ├── dao/               <-- DAO Interfaces
        │           ├── dao_implementation/ <-- SQL DAO Implementations
        │           ├── security/          <-- AuthFilter Security Layer
        │           ├── util/              <-- DBConnection Singleton
        │           └── controllers/       <-- Web Servlets (Customer & Admin Controllers)
        └── webapp/
            ├── assets/                    <-- Stylesheets, Images, App Logos
            └── jsp/
                ├── customer/              <-- Customer JSPs (home, cart, checkout, reviews...)
                ├── admin/                 <-- Admin JSPs (dashboard, order control, user list...)
                └── shared/                <-- Header, Footer & Navigation partials
```

---

## 🚀 Setup & Execution Guide

### 1. Prerequisites
* **Java Development Kit (JDK)**: Version 11 or higher (JDK 17/21 recommended)
* **Apache Maven**: Version 3.8+
* **MySQL Server**: Version 8.0+ running on port `3306`

### 2. Database Initialization
Execute the SQL script in your MySQL client to initialize the database:
```sql
CREATE DATABASE IF NOT EXISTS food_delivery_app;
USE food_delivery_app;
-- Create tables (users, restaurants, menu, orders, order_items, reviews)
```

### 3. Build & Run Application
Navigate to the root directory and run the embedded Jetty dev server:
```bash
mvn clean compile jetty:run
```

### 4. Access Application
Open your browser and navigate to:
```text
http://localhost:8085/FoodApp/
```

* **Customer Credentials**: Register a new account or log in.
* **Admin Credentials**: `username: admin`, `password: password123`

---

## 📜 License
This project is open-source and created for academic, educational, and portfolio purposes.
