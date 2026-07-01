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
    
    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #e0eafc 0%, #cfdef3 100%);
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.8);
            --primary-blue: #3b82f6;
            --text-dark: #1e293b;
            --text-gray: #64748b;
        }

        body {
            background: var(--bg-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }

        .app-container {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 40px;
            width: 100%;
            max-width: 1600px;
            min-height: 90vh;
            display: flex;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0,0,0,0.05);
        }

        /* --- Sidebar --- */
        .sidebar {
            width: 260px;
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(255, 255, 255, 0.8);
            background: rgba(255, 255, 255, 0.95);
        }
        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary-blue);
            margin-bottom: 40px;
            padding-left: 10px;
            display: flex;
            align-items: center;
            text-decoration: none;
        }
        .logo i { margin-right: 10px; }
        
        .nav-item-custom {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--text-gray);
            font-weight: 600;
            border-radius: 15px;
            margin-bottom: 8px;
            text-decoration: none;
            transition: all 0.3s;
        }
        .nav-item-custom i {
            width: 24px;
            font-size: 1.1rem;
            margin-right: 10px;
        }
        .nav-item-custom:hover {
            color: var(--primary-blue);
            background: rgba(255,255,255,0.5);
        }
        .nav-item-custom.active {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 10px 20px rgba(59, 130, 246, 0.3);
        }
        

        /* --- Main Content Area --- */
        .main-content {
            flex: 1;
            padding: 30px 40px;
            overflow-y: auto;
        }

        /* Header */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .top-header h2 {
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
        }
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .search-bar {
            background: white;
            border-radius: 20px;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            width: 300px;
        }
        .search-bar input {
            border: none;
            outline: none;
            background: transparent;
            width: 100%;
            margin-left: 10px;
            color: var(--text-gray);
        }
        .profile-btn {
            background: white;
            padding: 8px 15px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            font-weight: 600;
            color: var(--text-dark);
            text-decoration: none;
        }
        .profile-btn img {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
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
            <a href="${pageContext.request.contextPath}/admin/promotions" class="nav-item-custom ${param.activeMenu == 'promotions' ? 'active' : ''}">
                <i class="fa-solid fa-percent"></i> Promotions
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
