<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Promotion | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .hero-section {
            padding: 80px 0 50px 0;
            text-align: center;
        }
        .form-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .tour-list-scroll {
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 12px;
            background: #ffffff;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/tours">
                <i class="fa-solid fa-plane-departure me-2"></i>T-Booking
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tours">Tours</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About Us</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item dropdown ms-lg-3">
                                <a class="nav-link dropdown-toggle btn btn-outline-primary rounded-pill px-4 py-2" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fa-regular fa-user me-1"></i>Hi, ${sessionScope.user.fullName}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="max-height: 380px; overflow-y: auto; border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Schedules</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/promotions"><i class="fa-solid fa-percent me-2 text-primary"></i>Manage Promotions</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/discount-policies"><i class="fa-solid fa-hand-holding-dollar me-2 text-primary"></i>Discount Policies</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item ms-lg-3">
                                <a class="btn btn-outline-primary rounded-pill px-4" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Dashboard Header Banner -->
    <header class="hero-section">
        <div class="container">
            <h1 class="hero-title">Edit <span>Promotion</span></h1>
            <p class="hero-subtitle">Update promotional details and select applicable tour packages</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">

        <!-- Notification Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Edit Promotion Form -->
        <section class="form-panel col-lg-8 mx-auto">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);">
                    <i class="fa-solid fa-pen-to-square me-2 text-warning"></i>Promotion Details
                </h4>
                <span class="badge bg-warning text-dark rounded-pill py-2 px-3">ID: #${promotion.promotionId}</span>
            </div>
            
            <form method="POST" action="${pageContext.request.contextPath}/admin/promotions">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${promotion.promotionId}">
                
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Promotion Name</label>
                        <input type="text" name="promotionName" class="form-control rounded-3" value="${promotion.promotionName}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Discount Percent (%)</label>
                        <input type="number" name="discountPercent" class="form-control rounded-3" min="1" max="100" value="${promotion.discountPercent}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" ${'Active'.equalsIgnoreCase(promotion.status) ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${'Inactive'.equalsIgnoreCase(promotion.status) ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Start Date</label>
                        <input type="date" name="startDate" class="form-control rounded-3" value="${promotion.startDate}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">End Date</label>
                        <input type="date" name="endDate" class="form-control rounded-3" value="${promotion.endDate}" required>
                    </div>
                    
                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Apply to Tours</label>
                        <div class="tour-list-scroll">
                            <c:choose>
                                <c:when test="${empty tours}">
                                    <p class="text-muted small mb-0">No active tours available to apply promotions.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="tour" items="${tours}">
                                        <!-- Check if tour is currently mapped to this promotion -->
                                        <c:set var="isMapped" value="false" />
                                        <c:forEach var="mappedId" items="${mappedTourIds}">
                                            <c:if test="${mappedId == tour.tourId}">
                                                <c:set var="isMapped" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="checkbox" name="tourIds" value="${tour.tourId}" id="tour_${tour.tourId}" ${isMapped ? 'checked' : ''}>
                                            <label class="form-check-label small" for="tour_${tour.tourId}">
                                                <span class="text-primary fw-bold">[#${tour.tourId}]</span> ${tour.tourName} 
                                                <span class="text-muted">(${tour.durationDays} Days, <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>)</span>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary px-4 rounded-3">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-warning px-4 rounded-3 text-dark fw-semibold">
                        Update Promotion
                    </button>
                </div>
            </form>
        </section>
    </main>

    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 50px;">
        &copy; 2026 T-Booking Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
