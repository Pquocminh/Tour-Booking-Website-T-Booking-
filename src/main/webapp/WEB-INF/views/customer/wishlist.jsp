<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | T-Booking</title>
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-regular fa-star me-2 text-primary"></i>My Reviews</a></li>
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-white"></i>My Wishlist</a></li>
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
                <div class="col-lg-11">
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-3 mb-4" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-3 mb-4" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <div class="card glass-card border-0 p-4 p-md-5">
                        <div class="d-flex align-items-center mb-4 pb-3 border-bottom border-color">
                            <div class="bg-danger-subtle text-danger rounded-circle p-3 me-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <i class="fa-solid fa-heart fa-2x"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold mb-0">My Wishlist</h3>
                                <p class="text-muted mb-0">Keep track of the tour packages you are interested in.</p>
                            </div>
                        </div>

                        <!-- Wishlist Items -->
                        <c:choose>
                            <c:when test="${empty wishlistTours}">
                                <div class="text-center py-5">
                                    <div class="text-danger mb-4 opacity-50">
                                        <i class="fa-regular fa-heart fa-5x"></i>
                                    </div>
                                    <h4 class="fw-bold text-secondary">Your wishlist is currently empty</h4>
                                    <p class="text-muted mb-4">Explore and find your dream tour destinations!</p>
                                    <a href="${pageContext.request.contextPath}/tours" class="btn btn-primary rounded-pill px-5 py-3 fw-bold">
                                        <i class="fa-solid fa-search me-2"></i>Browse Tours
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Bulk Action Controls -->
                                <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-light rounded-3 border-0">
                                    <div class="form-check ms-2">
                                        <input class="form-check-input" type="checkbox" id="selectAllWishlist" style="width: 20px; height: 20px; cursor: pointer; border: 2px solid #ccc;">
                                        <label class="form-check-label fw-bold text-dark ms-2" for="selectAllWishlist" style="cursor: pointer; user-select: none; padding-top: 2px;">
                                            Select All
                                        </label>
                                    </div>
                                    <button type="button" id="btnRemoveSelected" class="btn btn-danger rounded-pill px-4 py-2 fw-semibold" disabled onclick="removeSelectedTours()">
                                        <i class="fa-solid fa-trash me-2"></i>Remove Selected
                                    </button>
                                </div>

                                <!-- Hidden Form for Bulk Deletion -->
                                <form id="bulkDeleteForm" action="${pageContext.request.contextPath}/wishlist" method="POST" style="display: none;">
                                    <input type="hidden" name="action" value="removeMultiple">
                                    <div id="bulkDeleteInputs"></div>
                                </form>

                                <div class="row g-4">
                                    <c:forEach var="tour" items="${wishlistTours}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card wishlist-card h-100 bg-white shadow-sm border-0">
                                                <!-- Image -->
                                                <div class="wishlist-img-wrapper">
                                                    <!-- Checkbox for item selection -->
                                                    <div class="position-absolute top-0 end-0 m-3" style="z-index: 20;">
                                                        <input class="form-check-input tour-checkbox" type="checkbox" value="${tour.tourId}">
                                                    </div>
                                                    <span class="badge bg-primary wishlist-badge rounded-pill px-3 py-2">
                                                        <i class="fa-solid fa-tag me-1"></i>${tour.category.categoryName}
                                                    </span>
                                                    <img src="${not empty tour.thumbnailUrl ? pageContext.request.contextPath.concat(tour.thumbnailUrl) : 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop'}" 
                                                         alt="${tour.tourName}"
                                                         onerror="this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&auto=format&fit=crop'">
                                                </div>
                                                
                                                <!-- Body -->
                                                <div class="card-body p-4 d-flex flex-column">
                                                    <h5 class="fw-bold text-main mb-3" style="font-size: 1.1rem; line-height: 1.4; height: 3rem; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                                        ${tour.tourName}
                                                    </h5>
                                                    
                                                    <div class="text-muted small mb-3 flex-grow-1">
                                                        <div class="mb-2">
                                                            <i class="fa-regular fa-clock text-primary me-2"></i>
                                                            <span>${tour.durationDays} Days / ${tour.durationDays > 1 ? tour.durationDays - 1 : 0} Nights</span>
                                                        </div>
                                                        <div>
                                                            <i class="fa-solid fa-location-dot text-primary me-2"></i>
                                                            <span>From: ${tour.departureLocation}</span>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="d-flex justify-content-between align-items-center pt-3 border-top border-light">
                                                        <div>
                                                            <span class="text-muted small d-block">Price starts from</span>
                                                            <span class="fs-5 fw-bold text-primary">
                                                                <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Actions -->
                                                <div class="card-footer p-3 bg-light border-0 d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/tour-detail?id=${tour.tourId}" class="btn btn-outline-primary btn-sm rounded-pill flex-grow-1 py-2 fw-semibold">
                                                        <i class="fa-solid fa-circle-info me-1"></i>Details
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-grow-1">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="tourId" value="${tour.tourId}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill w-100 py-2 fw-semibold">
                                                            <i class="fa-solid fa-trash me-1"></i>Remove
                                                        </button>
                                                    </form>
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
    </main>

    <!-- Footer -->
    <footer class="footer-custom py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0 text-white-50">&copy; 2026 T-Booking. All rights reserved. Design with passion in Vietnam.</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    
    <!-- Wishlist Deletion JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const selectAllCheckbox = document.getElementById('selectAllWishlist');
            const tourCheckboxes = document.querySelectorAll('.tour-checkbox');
            const removeSelectedBtn = document.getElementById('btnRemoveSelected');
            
            if (selectAllCheckbox && removeSelectedBtn) {
                // Function to update the state of "Remove Selected" button
                function updateRemoveButtonState() {
                    const checkedCount = document.querySelectorAll('.tour-checkbox:checked').length;
                    removeSelectedBtn.disabled = checkedCount === 0;
                    if (checkedCount === 0) {
                        selectAllCheckbox.checked = false;
                        selectAllCheckbox.indeterminate = false;
                    } else if (checkedCount === tourCheckboxes.length) {
                        selectAllCheckbox.checked = true;
                        selectAllCheckbox.indeterminate = false;
                    } else {
                        selectAllCheckbox.checked = false;
                        selectAllCheckbox.indeterminate = true;
                    }
                }
                
                // Select All click event
                selectAllCheckbox.addEventListener('change', function() {
                    tourCheckboxes.forEach(cb => {
                        cb.checked = selectAllCheckbox.checked;
                    });
                    updateRemoveButtonState();
                });
                
                // Individual checkbox click events
                tourCheckboxes.forEach(cb => {
                    cb.addEventListener('change', updateRemoveButtonState);
                });
            }
        });
        
        function removeSelectedTours() {
            const checkedCheckboxes = document.querySelectorAll('.tour-checkbox:checked');
            if (checkedCheckboxes.length === 0) {
                return;
            }
            
            if (confirm('Are you sure you want to remove the selected ' + checkedCheckboxes.length + ' tour(s) from your wishlist?')) {
                const form = document.getElementById('bulkDeleteForm');
                const inputsContainer = document.getElementById('bulkDeleteInputs');
                inputsContainer.innerHTML = ''; // clear previous inputs
                
                checkedCheckboxes.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'tourIds';
                    input.value = cb.value;
                    inputsContainer.appendChild(input);
                });
                
                form.submit();
            }
        }
    </script>
</body>
</html>

