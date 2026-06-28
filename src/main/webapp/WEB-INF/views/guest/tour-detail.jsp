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
    <style>
        .tour-detail-hero {
            height: 500px;
            background-size: cover;
            background-position: center;
            position: relative;
            border-radius: 12px;
            overflow: hidden;
        }
        .tour-detail-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.3);
        }
        .tour-info-badge {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 8px 16px;
            font-size: 0.9rem;
            margin: 5px 5px 0 0;
            display: inline-block;
        }
        .tour-detail-section {
            margin-top: 40px;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 12px;
        }
        .detail-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .price-highlight {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }
        .booking-button {
            width: 100%;
            padding: 15px;
            font-size: 1.1rem;
            border-radius: 50px;
            margin-top: 20px;
        }
        .breadcrumb-custom {
            background: transparent;
            padding: 0;
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

    <main class="container my-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-custom">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/tours" class="text-primary"><i class="fa-solid fa-house me-1"></i>Tours</a></li>
                <li class="breadcrumb-item active" aria-current="page">${tour.tourName}</li>
            </ol>
        </nav>

        <div class="row mt-4">
            <div class="col-lg-8">
                <!-- Tour Hero Image -->
                <div class="tour-detail-hero mb-4" style="background-image: url('${not empty tour.thumbnailUrl ? pageContext.request.contextPath.concat(tour.thumbnailUrl) : "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200&auto=format&fit=crop"}')">
                    <div class="position-absolute bottom-0 start-0 p-4">
                        <div>
                            <span class="tour-info-badge">
                                <i class="fa-solid fa-tag text-primary me-1"></i>${tour.category.categoryName}
                            </span>
                            <span class="tour-info-badge">
                                <i class="fa-regular fa-clock text-primary me-1"></i>
                                <c:choose>
                                    <c:when test="${tour.durationDays > 1}">
                                        ${tour.durationDays} Days ${tour.durationDays - 1} Nights
                                    </c:when>
                                    <c:otherwise>
                                        ${tour.durationDays} Day
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Tour Title Section -->
                <div class="mb-4">
                    <h1 class="display-5 fw-bold mb-3">${tour.tourName}</h1>
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <span class="badge bg-success px-3 py-2">
                            <i class="fa-solid fa-check-circle me-1"></i>Available
                        </span>
                        <span class="text-muted">
                            <i class="fa-solid fa-location-dot me-2"></i>${tour.destination.destinationName}, ${tour.destination.province}
                        </span>
                        <span class="text-muted">
                            <i class="fa-solid fa-location-arrow me-2"></i>Departure: ${tour.departureLocation}
                        </span>
                    </div>
                </div>

                <!-- Tour Description -->
                <div class="tour-detail-section">
                    <h3 class="mb-3">
                        <i class="fa-solid fa-circle-info text-primary me-2"></i>Tour Description
                    </h3>
                    <p class="lead text-muted">${tour.description}</p>
                </div>

                <!-- Destination Information -->
                <div class="tour-detail-section" style="background: white;">
                    <h3 class="mb-3">
                        <i class="fa-solid fa-map text-primary me-2"></i>Destination Details
                    </h3>
                    <div class="detail-card">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <strong>Destination Name:</strong><br>
                                <span class="text-primary">${tour.destination.destinationName}</span>
                            </div>
                            <div class="col-md-6 mb-3">
                                <strong>Province/Region:</strong><br>
                                <span class="text-primary">${tour.destination.province}</span>
                            </div>
                            <div class="col-12">
                                <strong>About the Destination:</strong><br>
                                <p class="text-muted mt-2">${tour.destination.description}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tour Duration & Details -->
                <div class="tour-detail-section" style="background: white;">
                    <h3 class="mb-3">
                        <i class="fa-regular fa-calendar text-primary me-2"></i>Tour Details
                    </h3>
                    <div class="row">
                        <div class="col-md-6 detail-card">
                            <strong>Duration:</strong><br>
                            <span class="text-primary fs-5">
                                <c:choose>
                                    <c:when test="${tour.durationDays > 1}">
                                        ${tour.durationDays} Days / ${tour.durationDays - 1} Nights
                                    </c:when>
                                    <c:otherwise>
                                        1 Day Tour
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="col-md-6 detail-card">
                            <strong>Departure Location:</strong><br>
                            <span class="text-primary fs-5">${tour.departureLocation}</span>
                        </div>
                        <div class="col-md-6 detail-card">
                            <strong>Category:</strong><br>
                            <span class="text-primary fs-5">${tour.category.categoryName}</span>
                        </div>
                        <div class="col-md-6 detail-card">
                            <strong>Tour Status:</strong><br>
                            <span class="badge bg-success fs-6">${tour.status}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Price Card -->
                <div class="price-highlight mb-4">
                    <h3 class="mb-2">Tour Price</h3>
                    <div class="fs-1 fw-bold mb-2">
                        <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                    <p class="small mb-0">Starting price per person</p>
                </div>

                <!-- Quick Info Cards -->
                <div class="card mb-3 border-0 shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title mb-3">
                            <i class="fa-solid fa-lightbulb text-warning me-2"></i>Quick Info
                        </h5>
                        <ul class="list-unstyled">
                            <li class="mb-3">
                                <i class="fa-solid fa-check text-success me-2"></i>
                                <strong>Duration:</strong>
                                <c:choose>
                                    <c:when test="${tour.durationDays > 1}">
                                        ${tour.durationDays} Days
                                    </c:when>
                                    <c:otherwise>
                                        1 Day
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li class="mb-3">
                                <i class="fa-solid fa-location-dot text-danger me-2"></i>
                                <strong>Destination:</strong>
                                <br>
                                <span class="text-muted">${tour.destination.destinationName}</span>
                            </li>
                            <li class="mb-3">
                                <i class="fa-solid fa-tag text-info me-2"></i>
                                <strong>Category:</strong>
                                <br>
                                <span class="text-muted">${tour.category.categoryName}</span>
                            </li>
                            <li>
                                <i class="fa-solid fa-check-circle text-success me-2"></i>
                                <strong>Status:</strong> Available
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Action Buttons -->
                <button class="btn btn-primary booking-button btn-lg rounded-pill" onclick="handleBooking()">
                    <i class="fa-solid fa-calendar-check me-2"></i>Book This Tour
                </button>
                <button class="btn btn-outline-primary booking-button btn-lg rounded-pill">
                    <i class="fa-solid fa-heart me-2"></i>Add to Wishlist
                </button>
                <a href="${pageContext.request.contextPath}/tours" class="btn btn-outline-secondary w-100 mt-2 py-3 rounded-pill">
                    <i class="fa-solid fa-arrow-left me-2"></i>Back to Tours
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="text-center text-lg-start mt-5">
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

