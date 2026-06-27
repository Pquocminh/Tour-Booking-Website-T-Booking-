<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${tour.tourName} | T-Booking</title>
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Schedules</a></li>
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

    <!-- Main Container -->
    <div class="container my-5">
        <div class="row">
            <!-- Left Column: Gallery, Overview, Itinerary -->
            <div class="col-lg-8 col-md-12 mb-4">
                
                <!-- Gallery Section -->
                <c:if test="${not empty tour.imageUrls}">
                    <div class="glass-card p-4 mb-4">
                        <h4 class="details-section-title"><i class="fa-regular fa-images me-2 text-primary"></i>Tour Gallery</h4>
                        <div id="tourGalleryCarousel" class="carousel slide rounded-3 overflow-hidden shadow-sm" data-bs-ride="carousel">
                            <div class="carousel-indicators">
                                <c:forEach var="img" items="${tour.imageUrls}" varStatus="status">
                                    <button type="button" data-bs-target="#tourGalleryCarousel" data-bs-slide-to="${status.index}" class="${status.first ? 'active' : ''}" aria-current="${status.first ? 'true' : 'false'}" aria-label="Slide ${status.index + 1}"></button>
                                </c:forEach>
                            </div>
                            <div class="carousel-inner">
                                <c:forEach var="img" items="${tour.imageUrls}" varStatus="status">
                                    <div class="carousel-item ${status.first ? 'active' : ''}">
                                        <img src="${pageContext.request.contextPath.concat(img)}" 
                                             class="d-block w-100 object-fit-cover" 
                                             style="height: 450px;" 
                                             alt="Tour image ${status.index + 1}"
                                             onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=1200&auto=format&fit=crop'">
                                    </div>
                                </c:forEach>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#tourGalleryCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#tourGalleryCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                </c:if>

                <!-- Overview Section -->
                <div class="glass-card p-4 mb-4">
                    <h4 class="details-section-title"><i class="fa-regular fa-file-lines me-2 text-primary"></i>Tour Overview</h4>
                    <p class="lead-text text-secondary-emphasis" style="white-space: pre-line; line-height: 1.7;">${tour.description}</p>
                </div>

                <!-- Itinerary Section -->
                <div class="glass-card p-4">
                    <h4 class="details-section-title"><i class="fa-regular fa-compass me-2 text-primary"></i>Itinerary Plan</h4>
                    <c:choose>
                        <c:when test="${empty tour.itineraries}">
                            <div class="p-3 text-center text-muted">
                                <i class="fa-solid fa-road-barrier display-6 mb-2"></i>
                                <p>Itinerary is being updated. Please contact us for details.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="itinerary-timeline mt-4">
                                <c:forEach var="iti" items="${tour.itineraries}">
                                    <div class="timeline-item">
                                        <div class="timeline-badge">
                                            <span>Day ${iti.dayNumber}</span>
                                        </div>
                                        <div class="timeline-content card border-0 shadow-sm p-4">
                                            <h5 class="fw-bold mb-2 text-primary">${iti.title}</h5>
                                            <p class="text-muted mb-0" style="white-space: pre-line;">${iti.description}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>

            <!-- Right Column: Booking Sidebar & Destination Card -->
            <div class="col-lg-4 col-md-12">
                
                <!-- Booking Card -->
                <div class="glass-card p-4 mb-4 border-primary shadow-sm">
                    <span class="badge bg-success px-3 py-1 mb-2 rounded-pill">Best Price Guarantee</span>
                    <div class="mb-3">
                        <span class="text-muted" style="font-size: 0.9rem;">Price starts from</span>
                        <h2 class="fw-extrabold text-primary mb-0">
                            <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </h2>
                    </div>
                    
                    <form action="#" method="POST" class="mt-4">
                        <div class="mb-3">
                            <label for="departureDate" class="form-label fw-bold text-main">
                                <i class="fa-regular fa-calendar-days me-1 text-primary"></i>Select Departure Date
                            </label>
                            <c:choose>
                                <c:when test="${empty tour.schedules}">
                                    <div class="alert alert-warning py-2 mb-0" style="font-size: 0.9rem; border-radius: 8px;">
                                        <i class="fa-solid fa-circle-exclamation me-1"></i>No upcoming schedules available.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <select class="form-select custom-select" id="departureDate" name="scheduleId" required>
                                        <c:forEach var="sch" items="${tour.schedules}">
                                            <option value="${sch.scheduleId}">
                                                <fmt:formatDate value="${sch.departureDate}" pattern="dd MMM yyyy"/> 
                                                (Price: <fmt:formatNumber value="${sch.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/> - ${sch.availableSlots} seats left)
                                            </option>
                                        </c:forEach>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-3 fw-bold mt-3 btn-book-now" 
                                ${empty tour.schedules ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-shopping me-2"></i>Book Now
                        </button>
                    </form>
                </div>

                <!-- Destination Card -->
                <div class="glass-card p-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-earth-americas me-2 text-primary"></i>Destination Info</h5>
                    <div class="dest-card-image overflow-hidden rounded-3 mb-3">
                        <img src="${not empty tour.destination.imageUrl ? pageContext.request.contextPath.concat(tour.destination.imageUrl) : 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=400&auto=format&fit=crop'}" 
                             class="img-fluid w-100 object-fit-cover" 
                             style="height: 180px;" 
                             alt="${tour.destination.destinationName}"
                             onerror="this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop'">
                    </div>
                    <h6 class="fw-bold text-main mb-1">${tour.destination.destinationName}</h6>
                    <p class="text-muted mb-2" style="font-size: 0.85rem;">
                        <i class="fa-solid fa-map-pin me-1 text-primary"></i>${tour.destination.province} | Region: ${tour.destination.region}
                    </p>
                    <p class="text-secondary-emphasis" style="font-size: 0.9rem; line-height: 1.5;">${tour.destination.description}</p>
                </div>

            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer-custom py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 text-white-50">&copy; 2026 T-Booking. All rights reserved. Design with passion in Vietnam.</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
