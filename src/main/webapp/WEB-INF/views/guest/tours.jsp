<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tour Packages | T-Booking</title>
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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="max-height: 380px; overflow-y: auto; border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-primary"></i>My Wishlist</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Schedules</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/promotions"><i class="fa-solid fa-percent me-2 text-primary"></i>Manage Promotions</a></li>
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

    <!-- Hero Section with Search -->
    <header class="hero-section">
        <div class="container">
            <span class="hero-badge">Vietnam's Leading Tour Booking Service</span>
            <h1 class="hero-title">Explore The World With <span>T-Booking</span></h1>
            <p class="hero-subtitle">
                Experience journeys filled with laughter, valuable knowledge, and the most memorable moments with family and friends.
            </p>

            <!-- Search Form -->
            <div class="search-form-wrapper mt-4">
                <form method="GET" action="${pageContext.request.contextPath}/tours" class="search-form">
                    <div class="input-group input-group-lg shadow-lg rounded-pill">
                        <span class="input-group-text border-0 bg-white" style="border-radius: 50px 0 0 50px;">
                            <i class="fa-solid fa-magnifying-glass text-primary"></i>
                        </span>
                        <input type="text" name="search" class="form-control border-0" placeholder="Search tours, destinations, categories..."
                               value="${not empty searchKeyword ? searchKeyword : ''}" style="border-radius: 0 50px 50px 0;">
                        <button type="submit" class="btn btn-primary px-4" style="border-radius: 0 50px 50px 0;">
                            <i class="fa-solid fa-search me-1"></i>Search
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </header>

    <!-- Tours Grid Section -->
    <main class="container my-5" id="tours-list">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="section-title mb-1">
                    <c:choose>
                        <c:when test="${isSearchResult}">
                            Search Results for "<span class="text-primary">${searchKeyword}</span>"
                        </c:when>
                        <c:otherwise>
                            Available Tour Packages
                        </c:otherwise>
                    </c:choose>
                </h2>
                <p class="text-muted">
                    <c:choose>
                        <c:when test="${isSearchResult}">
                            Found ${tours.size()} matching tour(s)
                        </c:when>
                        <c:otherwise>
                            Select your next amazing destination
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div>
                <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">
                    ${tours.size()} Tour<c:if test="${tours.size() != 1}">s</c:if>
                </span>
            </div>
        </div>

        <div class="row">
            <c:choose>
                <c:when test="${empty tours}">
                    <div class="col-12 text-center py-5">
                        <i class="fa-regular fa-face-frown display-1 text-muted mb-3"></i>
                        <h3>
                            <c:choose>
                                <c:when test="${isSearchResult}">
                                    No tours found matching your search.
                                </c:when>
                                <c:otherwise>
                                    No active tours are available at the moment.
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${isSearchResult}">
                                    Try using different keywords or <a href="${pageContext.request.contextPath}/tours" class="text-primary">browse all tours</a>.
                                </c:when>
                                <c:otherwise>
                                    Please check back later or contact support.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="t" items="${tours}">
                        <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                            <div class="tour-card">
                                <div class="tour-img-wrapper">
                                    <span class="tour-category-tag">
                                        <i class="fa-solid fa-tag me-1"></i>${t.category.categoryName}
                                    </span>
                                    <!-- Fallback image in case the local one does not exist -->
                                    <img src="${not empty t.thumbnailUrl ? pageContext.request.contextPath.concat(t.thumbnailUrl) : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop'}"
                                         alt="${t.tourName}"
                                         class="tour-img"
                                         onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop'">

                                    <span class="tour-duration-tag">
                                        <i class="fa-regular fa-clock me-1"></i>
                                        <c:choose>
                                            <c:when test="${t.durationDays > 1}">
                                                ${t.durationDays} Days ${t.durationDays - 1} Nights
                                            </c:when>
                                            <c:otherwise>
                                                ${t.durationDays} Day
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="tour-card-body">
                                    <div class="tour-location">
                                        <i class="fa-solid fa-location-dot"></i>
                                        Departure: ${t.departureLocation}
                                    </div>
                                    <h3 class="tour-title" title="${t.tourName}">${t.tourName}</h3>
                                    <div class="tour-destination" style="font-size: 0.9rem; color: #6c757d;">
                                        <i class="fa-solid fa-map-pin"></i>
                                        <c:if test="${not empty t.destination.destinationName}">
                                            ${t.destination.destinationName}
                                        </c:if>
                                    </div>
                                    <p class="tour-desc">${t.description}</p>
                                    <div class="tour-card-footer">
                                        <div class="tour-price-wrapper">
                                            <span class="tour-price-label">From</span>
                                            <span class="tour-price">
                                                <fmt:formatNumber value="${t.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/tour-detail?id=${t.tourId}" class="btn tour-btn">
                                            Details <i class="fa-solid fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Footer -->
    <footer class="text-center text-lg-start">
        <div class="container p-4">
            <div class="row">
                <div class="col-lg-6 col-md-12 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white font-weight-bold mb-3">T-Booking Tour Website</h5>
                    <p class="text-muted">
                        We are proud to offer our customers discovery tours, unique international experiences, and professional corporate visits.
                    </p>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white mb-3">Quick Links</h5>
                    <ul class="list-unstyled mb-0">
                        <li><a href="${pageContext.request.contextPath}/tours">Tour Packages</a></li>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Support Contact</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white mb-3">Contact Us</h5>
                    <ul class="list-unstyled text-muted">
                        <li><i class="fa-solid fa-phone me-2"></i>0374099505</li>
                        <li><i class="fa-solid fa-envelope me-2"></i>pquocminh2005@gmail.com</li>
                        <li><i class="fa-solid fa-map-marker-alt me-2"></i>Can Tho, Vietnam</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="text-center p-3 border-top border-secondary text-muted">
            &copy; 2026 T-Booking. All rights reserved.
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>

