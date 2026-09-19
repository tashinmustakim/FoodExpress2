<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Admin Dashboard"/>

<%@ include file="../shared/head.jspf" %>
<%@ include file="../shared/header.jspf" %>

<style>
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
    margin-bottom: 32px;
  }
  .stat-card {
    background: white;
    padding: 20px 24px;
    border-radius: 14px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.04);
    border: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    gap: 16px;
  }
  .stat-icon {
    font-size: 2.2rem;
    width: 56px;
    height: 56px;
    border-radius: 12px;
    background: #fff3e0;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .stat-val {
    font-size: 1.6rem;
    font-weight: 800;
    color: var(--dark-text);
    line-height: 1.2;
  }
  .stat-label {
    font-size: 0.85rem;
    color: var(--light-text);
    font-weight: 500;
    margin-top: 2px;
  }
</style>

<main class="main-content">
  <div class="container">

    <h2 class="page-title mb-4">
      Welcome, Admin 👋
    </h2>

    <!-- ================= ANALYTICS & STATS CARDS ================= -->
    <div class="stats-grid">
      
      <div class="stat-card">
        <div class="stat-icon" style="background: #e8f5e9; color: var(--accent-green);">💰</div>
        <div>
          <div class="stat-val">₹ <fmt:formatNumber value="${empty totalRevenue ? 0 : totalRevenue}" pattern="#,##0.00"/></div>
          <div class="stat-label">Total Revenue</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #e3f2fd; color: #0288d1;">📦</div>
        <div>
          <div class="stat-val">${empty totalOrders ? 0 : totalOrders}</div>
          <div class="stat-label">Total Orders</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #fff3e0; color: var(--primary);">🏪</div>
        <div>
          <div class="stat-val">${empty activeRestaurants ? 0 : activeRestaurants}</div>
          <div class="stat-label">Active Restaurants</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon" style="background: #f3e5f5; color: #8e24aa;">👥</div>
        <div>
          <div class="stat-val">${empty totalUsers ? 0 : totalUsers}</div>
          <div class="stat-label">Registered Users</div>
        </div>
      </div>

    </div>

    <!-- ================= FEATURE MANAGEMENT CARDS ================= -->
    <h3 style="margin-bottom: 16px; color: var(--dark-text); font-size: 1.2rem;">Quick Management Tools</h3>

    <div class="grid-3">

      <a class="card" href="${pageContext.request.contextPath}/admin/restaurants">
        <h3>🏪 Manage Restaurants</h3>
        <p class="card__text">Add, edit, or remove platform restaurants</p>
      </a>

      <a class="card" href="${pageContext.request.contextPath}/admin/menu">
        <h3>📋 Manage Menus</h3>
        <p class="card__text">View and update restaurant menu items</p>
      </a>

      <a class="card" href="${pageContext.request.contextPath}/admin/orders">
        <h3>📦 Manage Orders</h3>
        <p class="card__text">View all orders, update status, and track delivery</p>
      </a>

      <a class="card" href="${pageContext.request.contextPath}/admin/users">
        <h3>👥 Manage Users</h3>
        <p class="card__text">View users, change roles, and manage access</p>
      </a>

      <a class="card" href="${pageContext.request.contextPath}/admin/reviews">
        <h3>💬 Customer Reviews</h3>
        <p class="card__text">View, filter, and moderate customer ratings and feedback</p>
      </a>

    </div>

  </div>
</main>

<%@ include file="../shared/footer.jspf" %>
