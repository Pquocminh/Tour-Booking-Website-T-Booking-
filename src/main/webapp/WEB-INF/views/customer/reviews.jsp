<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews | T-Booking</title>
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
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-regular fa-star me-2 text-white"></i>My Reviews</a></li>
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

    <!-- Content Section -->
    <main class="profile-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <!-- Glassmorphism Card -->
                    <div class="card glass-card border-0 p-4 p-md-5">
                        
                        <h2 class="section-title mb-4">
                            <i class="fa-regular fa-star text-primary me-2"></i>My Reviews & Ratings
                        </h2>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                                <i class="fa-regular fa-circle-check me-2"></i>${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>

                        <ul class="nav nav-pills mb-4" id="reviewTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active rounded-pill px-4 me-2" id="reviewed-tab" data-bs-toggle="tab" data-bs-target="#reviewed" type="button" role="tab" aria-controls="reviewed" aria-selected="true">
                                    <i class="fa-regular fa-comment-dots me-2"></i>Reviewed Tours (${reviews.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link rounded-pill px-4" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="false">
                                    <i class="fa-regular fa-clock me-2"></i>Pending Reviews (${unreviewedBookings.size()})
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="reviewTabContent">
                            <!-- Reviewed Tours Tab -->
                            <div class="tab-pane fade show active" id="reviewed" role="tabpanel" aria-labelledby="reviewed-tab">
                                <c:choose>
                                    <c:when test="${empty reviews}">
                                        <div class="text-center py-5">
                                            <div class="mb-3 text-muted"><i class="fa-regular fa-comment-dots fa-3x"></i></div>
                                            <h5 class="text-muted">You haven't reviewed any tours yet.</h5>
                                            <p class="text-muted small">Completed and confirmed trips can be reviewed in the "Pending Reviews" tab.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row g-4">
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="col-12">
                                                    <div class="card review-card border border-color bg-white bg-opacity-50 p-4 rounded-4 shadow-sm">
                                                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-3">
                                                            <div>
                                                                <h5 class="mb-1" style="font-weight: 700; color: var(--text-main);">${review.tourName}</h5>
                                                                <div class="text-muted small">
                                                                    <span class="me-3"><i class="fa-regular fa-calendar-check me-1"></i>Booked: <fmt:formatDate value="${review.bookingDate}" pattern="dd/MM/yyyy"/></span>
                                                                    <span><i class="fa-solid fa-plane-departure me-1"></i>Departure: <fmt:formatDate value="${review.departureDate}" pattern="dd/MM/yyyy"/></span>
                                                                </div>
                                                            </div>
                                                            <div class="mt-2 mt-md-0 text-md-end">
                                                                <div class="mb-1">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <i class="${i <= review.rating ? 'fa-solid' : 'fa-regular'} fa-star text-warning"></i>
                                                                    </c:forEach>
                                                                </div>
                                                                <div class="text-muted small"><i class="fa-regular fa-clock me-1"></i>Reviewed on: <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                                            </div>
                                                        </div>
                                                        <hr class="my-3 border-color">
                                                        <div class="p-3 bg-white rounded-3 mb-3 border border-color">
                                                            <p class="mb-0 text-main" style="white-space: pre-line;">${review.comment}</p>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center">
                                                             <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                                                                 Status: ${review.status}
                                                             </span>
                                                            <form action="${pageContext.request.contextPath}/customer/reviews" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this review?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="reviewId" value="${review.reviewId}">
                                                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-trash me-1"></i>Delete Review</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Pending Reviews Tab -->
                            <div class="tab-pane fade" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                                <c:choose>
                                    <c:when test="${empty unreviewedBookings}">
                                        <div class="text-center py-5">
                                            <div class="mb-3 text-muted"><i class="fa-regular fa-clock fa-3x"></i></div>
                                            <h5 class="text-muted">No pending reviews found.</h5>
                                            <p class="text-muted small">Only confirmed bookings can be reviewed.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row g-4">
                                            <c:forEach var="booking" items="${unreviewedBookings}">
                                                <div class="col-12">
                                                    <div class="card border border-color bg-white bg-opacity-50 p-4 rounded-4 shadow-sm">
                                                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
                                                            <div>
                                                                <h5 class="mb-1" style="font-weight: 700; color: var(--text-main);">${booking.tourName}</h5>
                                                                <div class="text-muted small">
                                                                    <span class="me-3"><i class="fa-regular fa-calendar-check me-1"></i>Booked: <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/></span>
                                                                    <span class="me-3"><i class="fa-solid fa-plane-departure me-1"></i>Departure: <fmt:formatDate value="${booking.departureDate}" pattern="dd/MM/yyyy"/></span>
                                                                    <span><i class="fa-solid fa-wallet me-1"></i>Total Paid: <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫"/></span>
                                                                </div>
                                                            </div>
                                                            <div class="mt-3 mt-md-0">
                                                                <button class="btn btn-primary rounded-pill px-4" onclick="openReviewModal(${booking.bookingId}, '${booking.tourName}')">
                                                                    <i class="fa-regular fa-star me-2"></i>Rate & Review
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Rate & Review Modal -->
    <div class="modal fade" id="rateModal" tabindex="-1" aria-labelledby="rateModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-primary text-white" style="border-radius: var(--bs-border-radius-xl) var(--bs-border-radius-xl) 0 0;">
                    <h5 class="modal-title" id="rateModalLabel"><i class="fa-regular fa-star me-2"></i>Write a Review</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/customer/reviews" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="rate">
                        <input type="hidden" name="bookingId" id="modalBookingId">
                        
                        <div class="mb-3 text-center bg-light p-3 rounded-3">
                            <span class="text-muted small d-block mb-1">Tour Name</span>
                            <span id="modalTourName" class="font-weight-bold text-main" style="font-size: 1.1rem; font-weight: 700;"></span>
                        </div>
                        
                        <div class="mb-4 text-center">
                            <label class="form-label d-block font-weight-semibold mb-2">Your Rating <span class="text-danger">*</span></label>
                            <div class="star-rating d-inline-flex justify-content-center gap-2">
                                <i class="fa-regular fa-star fa-2x text-warning cursor-pointer" data-value="1"></i>
                                <i class="fa-regular fa-star fa-2x text-warning cursor-pointer" data-value="2"></i>
                                <i class="fa-regular fa-star fa-2x text-warning cursor-pointer" data-value="3"></i>
                                <i class="fa-regular fa-star fa-2x text-warning cursor-pointer" data-value="4"></i>
                                <i class="fa-regular fa-star fa-2x text-warning cursor-pointer" data-value="5"></i>
                            </div>
                            <input type="hidden" name="rating" id="ratingInput" value="5">
                        </div>
                        
                        <div class="mb-3">
                            <label for="comment" class="form-label font-weight-semibold">Your Review / Comment <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="comment" name="comment" rows="4" placeholder="How was your experience? Share details about the guide, places, and transportation..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Submit Review</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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

    <!-- Custom Script for Stars and Modal -->
    <script>
        function openReviewModal(bookingId, tourName) {
            document.getElementById('modalBookingId').value = bookingId;
            document.getElementById('modalTourName').innerText = tourName;
            
            // Reset to 5 stars
            setRating(5);
            document.getElementById('comment').value = '';
            
            var myModal = new bootstrap.Modal(document.getElementById('rateModal'));
            myModal.show();
        }

        function setRating(rating) {
            document.getElementById('ratingInput').value = rating;
            const stars = document.querySelectorAll('.star-rating i');
            stars.forEach(star => {
                const val = parseInt(star.getAttribute('data-value'));
                if (val <= rating) {
                    star.classList.remove('fa-regular');
                    star.classList.add('fa-solid');
                } else {
                    star.classList.remove('fa-solid');
                    star.classList.add('fa-regular');
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star-rating i');
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.getAttribute('data-value'));
                    setRating(rating);
                });
                
                star.addEventListener('mouseover', function() {
                    const rating = parseInt(this.getAttribute('data-value'));
                    stars.forEach(s => {
                        const val = parseInt(s.getAttribute('data-value'));
                        if (val <= rating) {
                            s.classList.remove('fa-regular');
                            s.classList.add('fa-solid');
                        } else {
                            s.classList.remove('fa-solid');
                            s.classList.add('fa-regular');
                        }
                    });
                });
                
                star.addEventListener('mouseout', function() {
                    const currentRating = parseInt(document.getElementById('ratingInput').value);
                    setRating(currentRating);
                });
            });
        });
    </script>
</body>
</html>

