<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} | T-Booking Admin</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js (optional, but good to have globally for dashboard) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

    <div class="app-container">
        
        <!-- Left Sidebar -->
        <div class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo">
                <i class="fa-solid fa-plane-departure"></i> T-Booking
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item-custom ${param.activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-border-all"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/tours" class="nav-item-custom ${param.activeMenu == 'tours' ? 'active' : ''}">
                <i class="fa-solid fa-map-location-dot"></i> Manage Tours
            </a>
            <c:if test="${sessionScope.user.role == 'Admin'}">
                <a href="${pageContext.request.contextPath}/admin/categories" class="nav-item-custom ${param.activeMenu == 'categories' ? 'active' : ''}">
                    <i class="fa-solid fa-tags"></i> Categories
                </a>
                <a href="${pageContext.request.contextPath}/admin/destinations" class="nav-item-custom ${param.activeMenu == 'destinations' ? 'active' : ''}">
                    <i class="fa-solid fa-location-dot"></i> Destinations
                </a>
                <a href="${pageContext.request.contextPath}/admin/accounts" class="nav-item-custom ${param.activeMenu == 'accounts' ? 'active' : ''}">
                    <i class="fa-solid fa-user-gear"></i> Manage Accounts
                </a>
                <a href="${pageContext.request.contextPath}/admin/discount-policies" class="nav-item-custom ${param.activeMenu == 'discount-policies' ? 'active' : ''}">
                    <i class="fa-solid fa-hand-holding-dollar"></i> Deposit Policy
                </a>
                <a href="${pageContext.request.contextPath}/admin/promotions" class="nav-item-custom ${param.activeMenu == 'promotions' ? 'active' : ''}">
                    <i class="fa-solid fa-percent"></i> Promotions
                </a>
                <a href="${pageContext.request.contextPath}/admin/vouchers" class="nav-item-custom ${param.activeMenu == 'vouchers' ? 'active' : ''}">
                    <i class="fa-solid fa-tags"></i> Vouchers
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/staff/reviews" class="nav-item-custom ${param.activeMenu == 'reviews' ? 'active' : ''}">
                <i class="fa-solid fa-star"></i> Reviews
            </a>
            <a href="${pageContext.request.contextPath}/admin/capacity" class="nav-item-custom ${param.activeMenu == 'capacity' ? 'active' : ''}">
                <i class="fa-solid fa-users"></i> Capacity
            </a>
            <a href="${pageContext.request.contextPath}/admin/schedules" class="nav-item-custom ${param.activeMenu == 'schedules' ? 'active' : ''}">
                <i class="fa-solid fa-calendar"></i> Schedules
            </a>
            <a href="${pageContext.request.contextPath}/admin/bookings" class="nav-item-custom ${param.activeMenu == 'bookings' ? 'active' : ''}">
                <i class="fa-solid fa-list-check"></i> Bookings
            </a>
            

            
            <a href="${pageContext.request.contextPath}/logout" class="nav-item-custom mt-4 text-danger">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Log Out
            </a>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            
            <!-- Top Header -->
            <div class="top-header">
                <h2>${param.pageTitle}</h2>
                <div class="header-right">
                    <div class="search-bar">
                        <i class="fa-solid fa-search text-gray"></i>
                        <input type="text" placeholder="Search...">
                        <div style="background: var(--primary-blue); color: white; width: 30px; height: 30px; border-radius: 10px; display: flex; align-items: center; justify-content: center; cursor: pointer;">
                            <i class="fa-solid fa-search"></i>
                        </div>
                    </div>
                    <div class="dropdown">
                        <a href="#" class="profile-btn text-decoration-none" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=random" alt="Avatar">
                            ${sessionScope.user.username}
                            <i class="fa-solid fa-chevron-down ms-2" style="font-size: 0.8rem; color: var(--text-gray);"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm rounded-4 mt-2">
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/profile"><i class="fa-regular fa-user me-2 text-muted"></i> Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Log Out</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Dynamic Content Starts Here -->

