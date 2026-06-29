<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion Details | Admin Dashboard</title>
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
        .detail-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .table-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            margin-bottom: 50px;
        }
        .table-custom th {
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
        }
        .info-label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            font-weight: 600;
        }
        .info-value {
            font-size: 1.1rem;
            color: var(--text-main);
            font-weight: 500;
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
                                          <c:if test="${sessionScope.user.role == 'Admin'}">
                                              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                          </c:if>
                                          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/staff/reviews"><i class="fa-solid fa-star me-2 text-primary"></i>Manage Reviews</a></li>
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
            <h1 class="hero-title">Promotion <span>Details</span></h1>
            <p class="hero-subtitle">Detailed information and mapped tours for the selected promotion</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">

        <!-- Back Button -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-2"></i>Back to Promotions
            </a>
        </div>

        <!-- Notification Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Promotion Main Info Card -->
        <section class="detail-panel">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-percent me-2 text-primary"></i>General Information</h4>
                <c:choose>
                    <c:when test="${'Active'.equalsIgnoreCase(promotion.status)}">
                        <span class="badge bg-success-subtle text-success border border-success px-4 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger-subtle text-danger border border-danger px-4 py-2 rounded-pill"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="row g-4">
                <div class="col-md-3">
                    <span class="info-label d-block mb-1">Promotion ID</span>
                    <span class="info-value">#${promotion.promotionId}</span>
                </div>
                <div class="col-md-5">
                    <span class="info-label d-block mb-1">Promotion Name</span>
                    <span class="info-value text-dark fw-semibold">${promotion.promotionName}</span>
                </div>
                <div class="col-md-4">
                    <span class="info-label d-block mb-1">Discount Rate</span>
                    <span class="info-value text-primary fw-bold" style="font-size: 1.3rem;">${promotion.discountPercent}% OFF</span>
                </div>
                <div class="col-md-6 border-top pt-3">
                    <span class="info-label d-block mb-1"><i class="fa-regular fa-calendar-check me-1"></i>Start Date</span>
                    <span class="info-value"><fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd" /></span>
                </div>
                <div class="col-md-6 border-top pt-3">
                    <span class="info-label d-block mb-1"><i class="fa-regular fa-calendar-xmark me-1"></i>End Date</span>
                    <span class="info-value"><fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd" /></span>
                </div>
            </div>
        </section>

        <!-- Applying Tours Section -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-plane-departure me-2 text-primary"></i>Applied Tours</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${tours.size()} Tour(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 100px;">Tour ID</th>
                            <th>Tour Name</th>
                            <th>Category</th>
                            <th>Destination</th>
                            <th>Duration</th>
                            <th>Base Price</th>
                            <th style="width: 120px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty tours}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-circle-info display-4 mb-3 d-block text-secondary"></i>
                                        This promotion is not applied to any tour package.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="tour" items="${tours}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${tour.tourId}</td>
                                        <td class="fw-semibold text-dark">${tour.tourName}</td>
                                        <td><span class="badge bg-light text-primary border border-primary">${tour.category.categoryName}</span></td>
                                        <td>${tour.destination.destinationName}</td>
                                        <td>${tour.durationDays} Days</td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Active'.equalsIgnoreCase(tour.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
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
