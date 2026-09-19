<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="Order Details" />

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/jsp/shared/head.jspf"%>
</head>
<body>

	<%@ include file="/jsp/shared/header.jspf"%>

	<div class="container main-content">
		
		<!-- ================= BACK NAVIGATION ================= -->
		<div class="mb-4">
			<a href="${pageContext.request.contextPath}/orderHistory" 
			   style="color: var(--primary); font-weight: 600; text-decoration: none;">
				← Back to My Orders
			</a>
		</div>

		<!-- ================= ORDER OVERVIEW ================= -->
		<div class="card mb-4">
			<div class="card__body">
				<div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
					<div>
						<h2 style="margin: 0 0 8px 0; color: var(--dark-text);">${restaurant.name}</h2>
						<p style="margin: 0; color: var(--light-text); font-size: 0.9rem;">
							Order #${order.orderId} | 
							<fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
						</p>
					</div>
					<div>
						<!-- STATUS BADGE -->
						<c:choose>
							<c:when test="${order.status eq 'placed'}">
								<span style="background-color: #e8f5e9; color: var(--accent-green); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.95rem;">
									Placed ✅
								</span>
							</c:when>
							<c:when test="${order.status eq 'preparing'}">
								<span style="background-color: #fff3e0; color: var(--primary); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.95rem;">
									Preparing 🧑‍🍳
								</span>
							</c:when>
							<c:when test="${order.status eq 'out_for_delivery'}">
								<span style="background-color: #e3f2fd; color: var(--accent-blue); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.95rem;">
									Out for Delivery 🚴
								</span>
							</c:when>
							<c:when test="${order.status eq 'delivered'}">
								<span style="background-color: #e8f5e9; color: var(--accent-green); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.95rem;">
									Delivered 📦
								</span>
							</c:when>
							<c:when test="${order.status eq 'cancelled'}">
								<span style="background-color: #ffebee; color: var(--accent-red); padding: 8px 16px; border-radius: 20px; font-weight: 600; font-size: 0.95rem;">
									Cancelled ❌
								</span>
							</c:when>
						</c:choose>

						<a href="${pageContext.request.contextPath}/restaurant?action=view&id=${restaurant.restaurantId}" 
						   class="btn btn--primary" 
						   style="margin-left: 12px; font-size: 0.85rem; padding: 8px 14px;">
							⭐ Rate & Review
						</a>
					</div>
				</div>
			</div>
		</div>

		<div class="grid-2">
			<!-- ================= ITEMS ORDERED ================= -->
			<div>
				<div class="card mb-4">
					<div class="card__body">
						<h3 class="mb-4">Items Ordered</h3>
						
						<c:forEach var="item" items="${items}">
							<c:set var="menuItem" value="${menuItemsMap[item.menuItemId]}" />
							<div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid var(--border-color);">
								<div style="display: flex; align-items: center;">
									<c:if test="${not empty menuItem.imageUrl}">
										<img src="${pageContext.request.contextPath}/${menuItem.imageUrl}" 
											 alt="${menuItem.name}" 
											 style="width: 60px; height: 60px; border-radius: 8px; margin-right: 16px; object-fit: cover;">
									</c:if>
									<div>
										<h4 style="margin: 0 0 4px 0; font-size: 1.05rem;">
											${menuItem.name}
										</h4>
										<small style="color: var(--light-text);">
											₹ ${item.priceAtOrder} × ${item.quantity}
										</small>
									</div>
								</div>
								<div style="font-weight: 600;">
									₹ ${item.priceAtOrder * item.quantity}
								</div>
							</div>
						</c:forEach>

						<!-- BILL DETAILS -->
						<div class="mt-4" style="font-size: 0.95rem;">
							<div style="display: flex; justify-content: space-between; margin-bottom: 8px; color: var(--medium-text);">
								<span>Item Total</span>
								<span>₹ ${order.totalAmount}</span>
							</div>
							<div style="display: flex; justify-content: space-between; margin-bottom: 8px; color: var(--medium-text);">
								<span>Delivery Partner Fee</span>
								<span>₹ 0.00</span>
							</div>
							<hr>
							<div style="display: flex; justify-content: space-between; font-weight: 700; font-size: 1.15rem; color: var(--dark-text);">
								<span>Grand Total</span>
								<span>₹ ${order.totalAmount}</span>
							</div>
						</div>

					</div>
				</div>
			</div>

			<!-- ================= DELIVERY & PAYMENT DETAILS ================= -->
			<div>
				<!-- Delivery Address -->
				<div class="card mb-4">
					<div class="card__body">
						<h3 class="mb-3">Delivery Address</h3>
						<c:choose>
							<c:when test="${not empty address}">
								<p style="margin: 0 0 8px 0; font-weight: 600; color: var(--dark-text);">
									${sessionScope.loggedUser.name}
								</p>
								<p style="margin: 0; line-height: 1.5; color: var(--medium-text);">
									${address.street},<br>
									${address.city}, ${address.state} - ${address.zip}<br>
									<c:if test="${not empty address.landmark}">
										<span style="font-size: 0.9rem; color: var(--light-text);">
											<strong>Landmark:</strong> ${address.landmark}
										</span>
									</c:if>
								</p>
							</c:when>
							<c:otherwise>
								<p style="color: var(--light-text); margin: 0;">
									Address details are not available.
								</p>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- Payment Info -->
				<div class="card mb-4">
					<div class="card__body">
						<h3 class="mb-3">Payment Information</h3>
						<div style="line-height: 1.8; color: var(--medium-text);">
							<div>
								<strong>Payment Method:</strong> 
								<span style="text-transform: capitalize;">
									${fn:replace(order.paymentMethod, '_', ' ')}
								</span>
							</div>
							<div>
								<strong>Payment Status:</strong> 
								<c:choose>
									<c:when test="${order.paymentStatus eq 'completed'}">
										<span style="color: var(--accent-green); font-weight: 600;">Paid ✅</span>
									</c:when>
									<c:when test="${order.paymentStatus eq 'pending'}">
										<span style="color: var(--primary); font-weight: 600;">Pending</span>
									</c:when>
									<c:otherwise>
										<span style="color: var(--accent-red); font-weight: 600;">${order.paymentStatus}</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<%@ include file="/jsp/shared/footer.jspf"%>
</body>
</html>