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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="max-height: 380px; overflow-y: auto; border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/booking"><i class="fa-solid fa-receipt me-2 text-success"></i>My Bookings</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bills"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i>My Bills</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-regular fa-star me-2 text-primary"></i>My Reviews</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-danger"></i>My Wishlist</a></li>
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

                <!-- Reviews Section -->
                <div class="glass-card p-4 mt-4 mb-4">
                    <h4 class="details-section-title"><i class="fa-regular fa-star me-2 text-warning"></i>Customer Reviews</h4>
                    
                    <c:if test="${not empty reviews}">
                        <div class="d-flex align-items-center mb-4 p-3 rounded-4" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
                            <div class="display-4 fw-bold me-3 text-dark">
                                <fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/>
                            </div>
                            <div>
                                <div class="text-warning fs-5 mb-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa-solid fa-star ${i <= averageRating ? '' : (i - 0.5 <= averageRating ? 'fa-star-half-stroke' : 'fa-regular')}"></i>
                                    </c:forEach>
                                </div>
                                <span class="text-muted small fw-medium">Based on ${reviews.size()} review(s)</span>
                            </div>
                        </div>
                    </c:if>
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="p-3 text-center text-muted">
                                <i class="fa-regular fa-comment-dots display-6 mb-2 text-light"></i>
                                <p>No reviews yet for this tour. Be the first to leave a review!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="review-list mt-3">
                                <c:forEach var="r" items="${reviews}">
                                    <div class="review-item p-3 mb-3 border rounded shadow-sm bg-white">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h6 class="fw-bold mb-0 text-primary">${r.customerName}</h6>
                                            <div class="text-warning small">
                                                <c:forEach begin="1" end="${r.rating}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${r.rating + 1}" end="5">
                                                    <i class="fa-regular fa-star"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <p class="mb-2 text-secondary">${r.comment}</p>
                                        <div class="text-muted small mb-2">
                                            <i class="fa-regular fa-calendar-check me-1"></i>Reviewed on <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/>
                                            <span class="ms-3"><i class="fa-solid fa-plane-departure me-1"></i>Travelled on <fmt:formatDate value="${r.departureDate}" pattern="dd/MM/yyyy"/></span>
                                        </div>
                                        
                                        <c:if test="${not empty r.staffResponse}">
                                            <div class="mt-2 p-2 bg-light border-start border-3 border-primary rounded">
                                                <div class="fw-bold text-primary mb-1" style="font-size: 0.85rem;"><i class="fa-solid fa-reply me-1"></i>Our Response:</div>
                                                <p class="mb-0 text-secondary" style="font-size: 0.9rem;">${r.staffResponse}</p>
                                            </div>
                                        </c:if>
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
                            <fmt:formatNumber value="${tour.basePrice}" pattern="#,##0 ₫"/>
                        </h2>
                    </div>
                    
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger border-0 rounded-3 mb-3 small" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.85rem;">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i>${sessionScope.errorMessage}
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>
                    <form action="${pageContext.request.contextPath}/booking" method="POST" class="mt-4" onsubmit="return validateBookingForm(event)">
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
                                    <select class="form-select custom-select" id="departureDate" name="scheduleId" required onchange="updateMaxSlots(); calculateTotalPrice()">
                                        <c:forEach var="sch" items="${tour.schedules}">
                                            <option value="${sch.scheduleId}" data-price="${sch.price}" data-available="${sch.availableSlots}">
                                                <fmt:formatDate value="${sch.departureDate}" pattern="dd/MM/yyyy"/> 
                                                - <fmt:formatNumber value="${sch.price}" pattern="#,##0 ₫"/> (${sch.availableSlots} left)
                                                <c:if test="${scheduleRefundableMap[sch.scheduleId]}">
                                                    [Non-refundable on cancellation]
                                                </c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty tour.schedules}">
                                        <div class="mt-2">
                                            <c:forEach var="sch" items="${tour.schedules}">
                                                <c:if test="${scheduleRefundableMap[sch.scheduleId]}">
                                                    <div class="text-danger small mt-1" style="font-size: 0.82rem; line-height: 1.4;">
                                                        <i class="fa-solid fa-circle-exclamation me-1"></i>
                                                        Schedule on <fmt:formatDate value="${sch.departureDate}" pattern="dd/MM/yyyy"/>: Non-refundable on cancellation (departure is less than ${cancellationWindowDays} days away).
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="mb-3">
                            <label for="numberOfPeople" class="form-label fw-bold text-main">
                                <i class="fa-solid fa-users me-1 text-primary"></i>Number of Travelers
                            </label>
                            <div class="input-group" style="max-width: 150px;">
                                <button class="btn btn-outline-primary" type="button" onclick="decrementTravelers()"><i class="fa-solid fa-minus"></i></button>
                                <input type="text" class="form-control text-center fw-bold text-primary" id="numberOfPeople" name="numberOfPeople" value="1" style="background-color: white;" oninput="hideTravelersError(); calculateTotalPrice()" autocomplete="off">
                                <button class="btn btn-outline-primary" type="button" onclick="incrementTravelers()"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <div id="travelersError" class="text-danger small mt-2 fw-bold" style="display: none;"></div>
                        </div>

                        <div class="mb-3 p-3 bg-light rounded border border-primary-subtle">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold">Total Price:</span>
                                <span class="fs-4 fw-bold text-primary" id="totalPriceDisplay">
                                    0 đ
                                </span>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-3 fw-bold mt-3 btn-book-now" 
                                ${empty tour.schedules ? 'disabled' : ''}>
                            <i class="fa-solid fa-cart-shopping me-2"></i>Book Now
                        </button>
                    </form>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.user && sessionScope.user.role == 'Customer'}">
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="mt-2">
                                <input type="hidden" name="tourId" value="${tour.tourId}">
                                <input type="hidden" name="redirect" value="detail">
                                <c:choose>
                                    <c:when test="${isInWishlist}">
                                        <input type="hidden" name="action" value="remove">
                                        <button type="submit" class="btn btn-danger w-100 rounded-pill py-2 fw-semibold">
                                            <i class="fa-solid fa-heart me-2"></i>Remove from Wishlist
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="add">
                                        <button type="submit" class="btn btn-outline-danger w-100 rounded-pill py-2 fw-semibold">
                                            <i class="fa-regular fa-heart me-2"></i>Add to Wishlist
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </c:when>
                        <c:when test="${empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-danger w-100 rounded-pill py-2 fw-semibold mt-2">
                                <i class="fa-regular fa-heart me-2"></i>Add to Wishlist
                            </a>
                        </c:when>
                    </c:choose>
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
                        <i class="fa-solid fa-map-pin me-1 text-primary"></i>${tour.destination.province} | Region: 
                        <c:choose>
                            <c:when test="${tour.destination.region == 'Miền Bắc' || tour.destination.region == 'North'}">North</c:when>
                            <c:when test="${tour.destination.region == 'Miền Trung' || tour.destination.region == 'Central'}">Central</c:when>
                            <c:when test="${tour.destination.region == 'Miền Nam' || tour.destination.region == 'South'}">South</c:when>
                            <c:otherwise>${tour.destination.region}</c:otherwise>
                        </c:choose>
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
    <script>
        function showTravelersError(msg) {
            const errorDiv = document.getElementById("travelersError");
            if (errorDiv) {
                errorDiv.innerHTML = '<i class="fa-solid fa-circle-exclamation me-1"></i>' + msg;
                errorDiv.style.display = "block";
            }
            const input = document.getElementById("numberOfPeople");
            if (input) {
                input.classList.add("is-invalid");
            }
        }

        function hideTravelersError() {
            const errorDiv = document.getElementById("travelersError");
            if (errorDiv) {
                errorDiv.innerText = "";
                errorDiv.style.display = "none";
            }
            const input = document.getElementById("numberOfPeople");
            if (input) {
                input.classList.remove("is-invalid");
            }
        }

        function validateBookingForm(event) {
            hideTravelersError();
            const input = document.getElementById("numberOfPeople");
            if (!input) return true;
            
            const rawVal = input.value.trim();

            // Business Rule 1: Passenger count requirement - cannot be empty
            if (rawVal === "") {
                showTravelersError("Please enter the number of travelers.");
                if (event) event.preventDefault();
                return false;
            }

            const normalizedVal = rawVal.replace(',', '.');

            // Business Rule 2: Numerical input validation - non-numeric characters prohibited
            if (isNaN(normalizedVal) || !/^-?\d+(\.\d+)?$/.test(normalizedVal)) {
                showTravelersError("Invalid character detected. Please enter digits only.");
                if (event) event.preventDefault();
                return false;
            }

            // Business Rule 3: Whole number restriction - fractional traveler counts invalid
            if (normalizedVal.includes('.')) {
                showTravelersError("Decimal values are not allowed. Please enter a whole number.");
                if (event) event.preventDefault();
                return false;
            }

            const val = parseInt(normalizedVal, 10);

            // Business Rule 4: Minimum capacity enforcement - booking requires >= 1 traveler
            if (val <= 0) {
                showTravelersError("Number of travelers must be at least 1.");
                if (event) event.preventDefault();
                return false;
            }

            // Business Rule 5: Schedule availability constraint - cannot exceed inventory capacity
            const selectElement = document.getElementById("departureDate");
            if (selectElement && selectElement.options.length > 0) {
                const selectedOption = selectElement.options[selectElement.selectedIndex];
                const max = parseInt(selectedOption.getAttribute("data-available") || "0", 10);
                if (val > max) {
                    showTravelersError("Not enough capacity! Only " + max + " slot(s) remaining for this schedule.");
                    if (event) event.preventDefault();
                    return false;
                }
            }

            return true;
        }

        function updateMaxSlots() {
            // Keep user input as typed to allow validation on form submit
        }
        
        function incrementTravelers() {
            hideTravelersError();
            const input = document.getElementById("numberOfPeople");
            const selectElement = document.getElementById("departureDate");
            if (!selectElement || selectElement.options.length === 0) return;
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const max = parseInt(selectedOption.getAttribute("data-available") || 1);
            let val = parseInt(input.value || 0, 10);
            if (isNaN(val)) val = 0;
            if (val < max) {
                input.value = val + 1;
                calculateTotalPrice();
            }
        }
        
        function decrementTravelers() {
            hideTravelersError();
            const input = document.getElementById("numberOfPeople");
            let val = parseInt(input.value || 0, 10);
            if (isNaN(val)) val = 1;
            if (val > 1) {
                input.value = val - 1;
                calculateTotalPrice();
            }
        }

        function calculateTotalPrice() {
            const priceDisplay = document.getElementById("totalPriceDisplay");
            if (!priceDisplay) return;

            const formatZero = () => {
                priceDisplay.innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(0);
            };

            const selectElement = document.getElementById("departureDate");
            if (!selectElement || selectElement.options.length === 0) {
                formatZero();
                return;
            }
            
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const price = parseFloat(selectedOption.getAttribute("data-price") || 0);
            const maxAvailable = parseInt(selectedOption.getAttribute("data-available") || "0", 10);
            
            const numPeopleElement = document.getElementById("numberOfPeople");
            if (!numPeopleElement) {
                formatZero();
                return;
            }

            const rawVal = numPeopleElement.value.trim();

            // Business Rule: If input is invalid (empty, non-digit, decimal, <= 0, or exceeds capacity), total price is 0
            if (rawVal === "") {
                formatZero();
                return;
            }

            const normalizedVal = rawVal.replace(',', '.');

            if (isNaN(normalizedVal) || !/^-?\d+(\.\d+)?$/.test(normalizedVal) || normalizedVal.includes('.')) {
                formatZero();
                return;
            }

            const numPeople = parseInt(normalizedVal, 10);

            if (numPeople <= 0 || numPeople > maxAvailable) {
                formatZero();
                return;
            }
            
            const total = price * numPeople;
            const formattedTotal = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(total);
            priceDisplay.innerText = formattedTotal;
        }

        // Initialize total price on page load
        document.addEventListener("DOMContentLoaded", function() {
            calculateTotalPrice();
        });
    </script>
</body>
</html>
