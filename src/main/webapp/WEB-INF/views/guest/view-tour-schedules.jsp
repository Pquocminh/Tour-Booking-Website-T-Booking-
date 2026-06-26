<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tour Schedules - ${tour.tourName} | T-Booking</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/tours">Tours</a>
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

    <!-- Details Hero Section -->
    <header class="details-hero" style="background-image: linear-gradient(rgba(15, 23, 42, 0.6), rgba(15, 23, 42, 0.8)), url('${not empty tour.thumbnailUrl ? pageContext.request.contextPath.concat(tour.thumbnailUrl) : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1600&auto=format&fit=crop'}');">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/tours" class="text-white-50">Tours</a></li>
                    <li class="breadcrumb-item active text-white" aria-current="page">${tour.tourName}</li>
                </ol>
            </nav>
            <span class="badge bg-primary px-3 py-2 mb-3 rounded-pill">
                <i class="fa-solid fa-tag me-1"></i>${tour.category.categoryName}
            </span>
            <h1 class="display-5 fw-bold text-white mb-3">${tour.tourName}</h1>
            <div class="d-flex flex-wrap gap-4 text-white">
                <div>
                    <i class="fa-regular fa-clock me-1 text-primary"></i>
                    <strong>Duration:</strong> ${tour.durationDays} Days ${tour.durationDays > 1 ? tour.durationDays - 1 : 0} Nights
                </div>
                <div>
                    <i class="fa-solid fa-location-dot me-1 text-primary"></i>
                    <strong>Departure:</strong> ${tour.departureLocation}
                </div>
                <div>
                    <i class="fa-solid fa-plane-arrival me-1 text-primary"></i>
                    <strong>Destination:</strong> ${tour.destination.destinationName}
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="container my-5">
        <div class="row">
            <!-- Left Column: Schedules Table -->
            <div class="col-lg-8 col-md-12 mb-4">
                <div class="glass-card p-4">
                    <h4 class="details-section-title"><i class="fa-regular fa-calendar-days me-2 text-primary"></i>Departure Schedules</h4>
                    <p class="text-muted mb-4">Select your preferred departure date and start booking your adventure.</p>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Departure Date</th>
                                    <th>Return Date</th>
                                    <th>Price</th>
                                    <th>Seats Left</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty schedules}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="fa-solid fa-circle-exclamation display-6 mb-3 d-block text-warning"></i>
                                                No upcoming schedules available for this tour package.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sch" items="${schedules}">
                                            <tr>
                                                <td class="fw-semibold">
                                                    <i class="fa-regular fa-calendar me-1 text-primary"></i>
                                                    <fmt:formatDate value="${sch.departureDate}" pattern="dd MMM yyyy"/>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${sch.returnDate}" pattern="dd MMM yyyy"/>
                                                </td>
                                                <td class="fw-bold text-primary">
                                                    <fmt:formatNumber value="${sch.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td>
                                                    <span class="badge ${sch.availableSlots > 5 ? 'bg-success' : 'bg-danger'} px-2 py-1">
                                                        ${sch.availableSlots} seats left
                                                    </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary rounded-pill px-3" onclick="handleBooking()">
                                                        Book Now
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right Column: Sidebar (Quick details) -->
            <div class="col-lg-4 col-md-12">
                <div class="glass-card p-4 mb-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-circle-info me-2 text-primary"></i>Tour Overview</h5>
                    <p class="text-secondary-emphasis" style="font-size: 0.9rem; line-height: 1.6;">${tour.description}</p>
                </div>
                
                <div class="glass-card p-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-earth-americas me-2 text-primary"></i>Destination Info</h5>
                    <c:if test="${not empty tour.destination.imageUrl}">
                        <div class="overflow-hidden rounded-3 mb-3">
                            <img src="${pageContext.request.contextPath.concat(tour.destination.imageUrl)}" 
                                 class="img-fluid w-100 object-fit-cover" 
                                 style="height: 180px;" 
                                 alt="${tour.destination.destinationName}"
                                 onerror="this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop'">
                        </div>
                    </c:if>
                    <h6 class="fw-bold text-main mb-1">${tour.destination.destinationName}</h6>
                    <p class="text-muted mb-2" style="font-size: 0.85rem;">
                        <i class="fa-solid fa-map-pin me-1 text-primary"></i>${tour.destination.province} | Region: ${tour.destination.region}
                    </p>
                    <p class="text-secondary-emphasis" style="font-size: 0.9rem; line-height: 1.5;">${tour.destination.description}</p>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer-custom py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 text-white-50">&copy; 2026 T-Booking. All rights reserved. Design with passion in Vietnam.</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleBooking() {
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    alert('Booking feature coming soon!');
                </c:when>
                <c:otherwise>
                    alert('Please login to book this tour');
                    window.location.href = '${pageContext.request.contextPath}/login';
                </c:otherwise>
            </c:choose>
        }
    </script>
</body>
</html>
