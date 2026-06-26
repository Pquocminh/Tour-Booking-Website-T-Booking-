<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Tour Schedules | Admin Dashboard</title>
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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
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
            <h1 class="hero-title">Tour <span>Schedules</span></h1>
            <p class="hero-subtitle">Viewing schedules for: <strong>${tour.tourName}</strong></p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-outline-secondary px-4 rounded-pill">
                <i class="fa-solid fa-arrow-left me-2"></i>Back to Tours
            </a>
        </div>

        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Schedules List</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${schedules.size()} Schedule(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Schedule ID</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Price</th>
                            <th>Available Slots</th>
                            <th>Total Slots</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty schedules}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                        No schedules found for this tour.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sch" items="${schedules}">
                                    <tr>
                                        <td><span class="text-muted small">ID: #${sch.scheduleId}</span></td>
                                        <td class="fw-semibold">
                                            <fmt:formatDate value="${sch.departureDate}" pattern="dd MMM yyyy"/>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${sch.returnDate}" pattern="dd MMM yyyy"/>
                                        </td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${sch.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td>${sch.availableSlots} seats</td>
                                        <td>${sch.totalSlots} seats</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Open'.equalsIgnoreCase(sch.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Open</span>
                                                </c:when>
                                                <c:when test="${'Full'.equalsIgnoreCase(sch.status)}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-2 rounded-pill"><i class="fa-solid fa-triangle-exclamation me-1"></i>Full</span>
                                                </c:when>
                                                <c:when test="${'Cancelled'.equalsIgnoreCase(sch.status)}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-xmark me-1"></i>Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-2 rounded-pill"><i class="fa-solid fa-clock me-1"></i>${sch.status}</span>
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
