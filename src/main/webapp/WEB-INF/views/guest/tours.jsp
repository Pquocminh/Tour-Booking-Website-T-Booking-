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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2">
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/booking"><i class="fa-solid fa-receipt me-2 text-success"></i>My Bookings</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bills"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i>My Bills</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-regular fa-star me-2 text-primary"></i>My Reviews</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-danger"></i>My Wishlist</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-map-location-dot me-2 text-primary"></i>Manage Tours</a></li>
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

    <!-- Hero Section with Search -->
    <header class="hero-section">
        <div class="container">
            <span class="hero-badge">Vietnam's Leading Tour Booking Service</span>
            <h1 class="hero-title">Explore The World With <span>T-Booking</span></h1>
            <p class="hero-subtitle">
                Experience journeys filled with laughter, valuable knowledge, and the most memorable moments with family and friends.
            </p>

            <!-- Active Promotions Banner -->
            <c:if test="${not empty activePromotions}">
                <div class="promo-vouchers-container">
                    <!-- Display up to 3 promotions horizontally -->
                    <c:forEach var="promo" items="${activePromotions}" end="2">
                        <div class="promo-voucher" onclick="document.getElementById('tours-list').scrollIntoView({behavior: 'smooth'})" title="Scroll down to view tours">
                            <div class="promo-title"><i class="fa-solid fa-fire text-danger me-2"></i>${promo.promotionName}</div>
                            <div class="promo-discount">
                                Up to <span>${promo.discountPercent}% OFF</span>
                            </div>
                            <div class="promo-dates">
                                From <fmt:formatDate value="${promo.startDate}" pattern="dd/MM/yyyy"/> to <fmt:formatDate value="${promo.endDate}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Search Form -->
            <div class="search-form-wrapper mt-4">
                <form method="GET" action="${pageContext.request.contextPath}/tours#tours-list" class="search-form">
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

    <!-- Tours Grid & Filter Section -->
    <main class="container my-5" id="tours-list">
        <div class="row">
            <!-- Filter Sidebar (Left Column) -->
            <aside class="col-lg-3 col-md-4 mb-4">
                <div class="filter-card card shadow-sm border-0 rounded-4 p-4 sticky-top" style="top: 100px; z-index: 10;">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold mb-0 text-primary fs-5">
                            <i class="fa-solid fa-sliders me-2"></i>Filter Tours
                        </h4>
                        <c:if test="${hasActiveFilters}">
                            <a href="${pageContext.request.contextPath}/tours#tours-list" class="text-danger small fw-semibold text-decoration-none" title="Reset all filters">
                                <i class="fa-solid fa-rotate-left me-1"></i>Reset
                            </a>
                        </c:if>
                    </div>
                    <hr class="my-2">

                    <form method="GET" action="${pageContext.request.contextPath}/tours#tours-list" id="filter-form">
                        <!-- Server Validation Errors Display -->
                        <c:if test="${not empty filterErrors}">
                            <div class="alert alert-danger alert-dismissible fade show p-2 small mb-3" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i>
                                <ul class="mb-0 ps-3">
                                    <c:forEach var="err" items="${filterErrors}">
                                        <li>${err}</li>
                                    </c:forEach>
                                </ul>
                                <button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Search Keyword -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Keyword</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="fa-solid fa-magnifying-glass text-muted"></i>
                                </span>
                                <input type="text" name="search" class="form-control border-start-0 bg-light" placeholder="Tour name, place..." value="${searchKeyword}">
                            </div>
                        </div>

                        <!-- Category Filter -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Category</label>
                            <select name="category" class="form-select bg-light">
                                <option value="">All Categories</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}" ${categoryFilter == cat.categoryId ? 'selected' : ''}>
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Destination Filter -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Destination</label>
                            <select name="destination" class="form-select bg-light">
                                <option value="">All Destinations</option>
                                <c:forEach var="dest" items="${destinations}">
                                    <option value="${dest.destinationId}" ${destinationFilter == dest.destinationId ? 'selected' : ''}>
                                        ${dest.destinationName} (${dest.province})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Price Range Filter -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Price Range (VND)</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="text" name="minPrice" id="minPrice" class="form-control form-control-sm bg-light" placeholder="Min (e.g. 1,000)" value="${not empty param.minPrice ? param.minPrice : (not empty minPriceFilter ? minPriceFilter : '')}">
                                </div>
                                <div class="col-6">
                                    <input type="text" name="maxPrice" id="maxPrice" class="form-control form-control-sm bg-light" placeholder="Max (e.g. 1,234)" value="${not empty param.maxPrice ? param.maxPrice : (not empty maxPriceFilter ? maxPriceFilter : '')}">
                                </div>
                            </div>
                        </div>

                        <!-- Duration Filter -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Duration (Days)</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" name="minDuration" id="minDuration" class="form-control form-control-sm bg-light" placeholder="Min (>=1)" min="1" step="1" value="${minDurationFilter}">
                                </div>
                                <div class="col-6">
                                    <input type="number" name="maxDuration" id="maxDuration" class="form-control form-control-sm bg-light" placeholder="Max" min="1" step="1" value="${maxDurationFilter}">
                                </div>
                            </div>
                        </div>

                        <!-- Sort By Filter -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted">Sort By</label>
                            <select name="sortBy" class="form-select bg-light">
                                <option value="newest" ${empty sortByFilter || sortByFilter == 'newest' ? 'selected' : ''}>Newest</option>
                                <option value="price_asc" ${sortByFilter == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                                <option value="price_desc" ${sortByFilter == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                                <option value="duration_asc" ${sortByFilter == 'duration_asc' ? 'selected' : ''}>Duration: Shortest</option>
                                <option value="duration_desc" ${sortByFilter == 'duration_desc' ? 'selected' : ''}>Duration: Longest</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 font-weight-bold shadow-sm">
                            <i class="fa-solid fa-filter me-1"></i>Apply Filters
                        </button>
                    </form>
                </div>
            </aside>

            <!-- Tour List Grid (Right Column) -->
            <section class="col-lg-9 col-md-8">
                <!-- Header / Filter Badges -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2 class="section-title mb-1">
                            <c:choose>
                                <c:when test="${hasActiveFilters}">
                                    Filtered Tour Results
                                </c:when>
                                <c:otherwise>
                                    Available Tour Packages
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="text-muted small mb-0">
                            Found <strong class="text-primary">${not empty totalTours ? totalTours : 0}</strong> tour(s) matching your criteria
                        </p>
                    </div>
                    <div>
                        <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">
                            ${not empty totalTours ? totalTours : 0} Tour<c:if test="${totalTours != 1}">s</c:if>
                        </span>
                    </div>
                </div>

                <!-- Active Filter Badges -->
                <c:if test="${hasActiveFilters}">
                    <div class="active-filters-wrapper mb-3 d-flex flex-wrap gap-2 align-items-center">
                        <span class="small text-muted me-1"><i class="fa-solid fa-tags me-1"></i>Active Filters:</span>
                        <c:if test="${not empty searchKeyword}">
                            <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-normal">
                                Keyword: "${searchKeyword}"
                            </span>
                        </c:if>
                        <c:if test="${not empty categoryFilter}">
                            <c:forEach var="cat" items="${categories}">
                                <c:if test="${cat.categoryId == categoryFilter}">
                                    <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-normal">
                                        Category: ${cat.categoryName}
                                    </span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty destinationFilter}">
                            <c:forEach var="dest" items="${destinations}">
                                <c:if test="${dest.destinationId == destinationFilter}">
                                    <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-normal">
                                        Destination: ${dest.destinationName}
                                    </span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty minPriceFilter || not empty maxPriceFilter}">
                            <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-normal">
                                Price: <fmt:formatNumber value="${minPriceFilter}" pattern="#,##0"/> - <fmt:formatNumber value="${maxPriceFilter}" pattern="#,##0"/> ₫
                            </span>
                        </c:if>
                        <c:if test="${not empty minDurationFilter || not empty maxDurationFilter}">
                            <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-normal">
                                Duration: ${minDurationFilter} - ${maxDurationFilter} Days
                            </span>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/tours#tours-list" class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-2 text-decoration-none">
                            <i class="fa-solid fa-times me-1"></i>Clear All
                        </a>
                    </div>
                </c:if>

                <!-- Tour Cards Grid -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty tours}">
                            <div class="col-12 text-center py-5">
                                <i class="fa-regular fa-face-frown display-1 text-muted mb-3"></i>
                                <h3>No tours found matching your search.</h3>
                                <p class="text-muted">
                                    Try adjusting your filter criteria or <a href="${pageContext.request.contextPath}/tours#tours-list" class="text-primary fw-semibold">view all tours</a>.
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="t" items="${tours}">
                                <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                                    <div class="tour-card h-100 shadow-sm border-0 rounded-4 overflow-hidden d-flex flex-column bg-white">
                                        <div class="tour-img-wrapper position-relative">
                                            <span class="tour-category-tag position-absolute top-0 start-0 m-3 badge bg-primary">
                                                <i class="fa-solid fa-tag me-1"></i>${t.category.categoryName}
                                            </span>
                                            <c:choose>
                                                <c:when test="${not empty t.thumbnailUrl}">
                                                    <c:choose>
                                                        <c:when test="${t.thumbnailUrl.startsWith('http')}">
                                                            <c:set var="imgSrc" value="${t.thumbnailUrl}" />
                                                        </c:when>
                                                        <c:when test="${t.thumbnailUrl.startsWith('/')}">
                                                            <c:set var="imgSrc" value="${pageContext.request.contextPath}${t.thumbnailUrl}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="imgSrc" value="${pageContext.request.contextPath}/${t.thumbnailUrl}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="imgSrc" value="https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop" />
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="${imgSrc}"
                                                 alt="${t.tourName}"
                                                 class="tour-img w-100"
                                                 style="height: 200px; object-fit: cover;"
                                                 onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop'">

                                            <span class="tour-duration-tag position-absolute bottom-0 end-0 m-3 badge bg-dark bg-opacity-75">
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
                                        <div class="tour-card-body p-3 d-flex flex-column flex-grow-1">
                                            <div class="tour-location text-muted small mb-1">
                                                <i class="fa-solid fa-location-dot text-primary me-1"></i>
                                                Departure: ${t.departureLocation}
                                            </div>
                                            <h3 class="tour-title h6 fw-bold mb-2 text-truncate" title="${t.tourName}">${t.tourName}</h3>
                                            <div class="tour-destination small text-muted mb-2">
                                                <i class="fa-solid fa-map-pin me-1"></i>
                                                <c:if test="${not empty t.destination.destinationName}">
                                                    ${t.destination.destinationName}
                                                </c:if>
                                            </div>
                                            <p class="tour-desc text-muted small flex-grow-1 line-clamp-2">${t.description}</p>
                                            <div class="tour-card-footer d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                                                <div class="tour-price-wrapper">
                                                    <span class="tour-price-label d-block text-muted small" style="font-size: 0.75rem;">From</span>
                                                    <span class="tour-price text-primary fw-bold fs-5">
                                                        <fmt:formatNumber value="${t.basePrice}" pattern="#,##0 ₫"/>
                                                    </span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/tour-detail?id=${t.tourId}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                    View Details <i class="fa-solid fa-arrow-right ms-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination Bar -->
                <c:if test="${not empty totalPages and totalPages >= 1}">
                    <c:set var="urlParams" value="" />
                    <c:if test="${not empty searchKeyword}"><c:set var="urlParams" value="${urlParams}&search=${searchKeyword}" /></c:if>
                    <c:if test="${not empty categoryFilter}"><c:set var="urlParams" value="${urlParams}&category=${categoryFilter}" /></c:if>
                    <c:if test="${not empty destinationFilter}"><c:set var="urlParams" value="${urlParams}&destination=${destinationFilter}" /></c:if>
                    <c:if test="${not empty minPriceFilter}"><c:set var="urlParams" value="${urlParams}&minPrice=${minPriceFilter}" /></c:if>
                    <c:if test="${not empty maxPriceFilter}"><c:set var="urlParams" value="${urlParams}&maxPrice=${maxPriceFilter}" /></c:if>
                    <c:if test="${not empty minDurationFilter}"><c:set var="urlParams" value="${urlParams}&minDuration=${minDurationFilter}" /></c:if>
                    <c:if test="${not empty maxDurationFilter}"><c:set var="urlParams" value="${urlParams}&maxDuration=${maxDurationFilter}" /></c:if>
                    <c:if test="${not empty sortByFilter}"><c:set var="urlParams" value="${urlParams}&sortBy=${sortByFilter}" /></c:if>

                    <nav aria-label="Public tours list pagination" class="d-flex justify-content-center mt-4">
                        <ul class="pagination custom-pagination mb-0" style="display: flex !important; list-style: none !important; padding-left: 0 !important; margin: 0 !important;">
                            <!-- Previous Button -->
                            <c:choose>
                                <c:when test="${currentPage <= 1}">
                                    <li class="page-item disabled" style="list-style: none !important;">
                                        <a class="page-link" href="javascript:void(0);" tabindex="-1" aria-disabled="true">Previous</a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item" style="list-style: none !important;">
                                        <a class="page-link" href="${pageContext.request.contextPath}/tours?page=${currentPage - 1}${urlParams}#tours-list">Previous</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>

                            <!-- Page Numbers -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <li class="page-item active" style="list-style: none !important;">
                                            <a class="page-link" href="javascript:void(0);">${i}</a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item" style="list-style: none !important;">
                                            <a class="page-link" href="${pageContext.request.contextPath}/tours?page=${i}${urlParams}#tours-list">${i}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Next Button -->
                            <c:choose>
                                <c:when test="${currentPage >= totalPages}">
                                    <li class="page-item disabled" style="list-style: none !important;">
                                        <a class="page-link" href="javascript:void(0);" tabindex="-1" aria-disabled="true">Next</a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item" style="list-style: none !important;">
                                        <a class="page-link" href="${pageContext.request.contextPath}/tours?page=${currentPage + 1}${urlParams}#tours-list">Next</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </nav>
                </c:if>
            </section>
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
    <script src="${pageContext.request.contextPath}/assets/js/security.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var filterForm = document.getElementById('filter-form');
        
        function validatePriceInput(val, fieldName) {
            if (!val) return null;
            var trimmed = val.trim();
            if (trimmed === '') return null;

            if (trimmed.indexOf(',') !== -1) {
                var commaRegex = /^\d{1,3}(,\d{3})+$/;
                if (!commaRegex.test(trimmed)) {
                    alert(fieldName + ': If comma is used, it must be followed by exactly 3 digits (e.g. 1,000 or 1,234).');
                    return false;
                }
            } else if (trimmed.indexOf('.') !== -1) {
                var dotRegex = /^\d{1,3}(\.\d{3})+$/;
                if (!dotRegex.test(trimmed)) {
                    alert(fieldName + ': If dot separator is used, it must be followed by exactly 3 digits (e.g. 1.000 or 1.234).');
                    return false;
                }
            } else {
                var digitsRegex = /^\d+$/;
                if (!digitsRegex.test(trimmed)) {
                    alert(fieldName + ' must contain digits only.');
                    return false;
                }
            }

            var cleanVal = trimmed.replace(/[,.]/g, '');
            var num = parseFloat(cleanVal);
            if (isNaN(num) || num < 1000) {
                alert(fieldName + ' must be at least 1,000 VND.');
                return false;
            }
            return num;
        }

        if (filterForm) {
            filterForm.addEventListener('submit', function(e) {
                var minPriceStr = document.getElementById('minPrice').value;
                var maxPriceStr = document.getElementById('maxPrice').value;
                var minDurVal = document.getElementById('minDuration').value.trim();
                var maxDurVal = document.getElementById('maxDuration').value.trim();

                var parsedMinP = validatePriceInput(minPriceStr, 'Minimum price');
                if (parsedMinP === false) {
                    e.preventDefault();
                    return false;
                }

                var parsedMaxP = validatePriceInput(maxPriceStr, 'Maximum price');
                if (parsedMaxP === false) {
                    e.preventDefault();
                    return false;
                }

                // Validate Min Price <= Max Price
                if (parsedMinP !== null && parsedMaxP !== null && parsedMinP > parsedMaxP) {
                    alert('Minimum price cannot be greater than maximum price.');
                    e.preventDefault();
                    return false;
                }

                // Validate Min Duration
                if (minDurVal !== '') {
                    var minD = parseInt(minDurVal, 10);
                    if (isNaN(minD) || minD < 1) {
                        alert('Minimum duration must be a valid positive integer (at least 1 day).');
                        e.preventDefault();
                        return false;
                    }
                }

                // Validate Max Duration
                if (maxDurVal !== '') {
                    var maxD = parseInt(maxDurVal, 10);
                    if (isNaN(maxD) || maxD < 1) {
                        alert('Maximum duration must be a valid positive integer (at least 1 day).');
                        e.preventDefault();
                        return false;
                    }
                }

                // Validate Min Duration <= Max Duration
                if (minDurVal !== '' && maxDurVal !== '' && !isNaN(minDurVal) && !isNaN(maxDurVal)) {
                    if (parseInt(minDurVal, 10) > parseInt(maxDurVal, 10)) {
                        alert('Minimum duration cannot be greater than maximum duration.');
                        e.preventDefault();
                        return false;
                    }
                }
            });
        }

        // Auto smooth scroll to #tours-list if filtering/searching or changing page
        if (window.location.hash === '#tours-list' || ${hasActiveFilters} || ${not empty param.page}) {
            var toursSection = document.getElementById('tours-list');
            if (toursSection) {
                setTimeout(function() {
                    toursSection.scrollIntoView({ behavior: 'smooth' });
                }, 100);
            }
        }
    });
    </script>
</body>
</html>

