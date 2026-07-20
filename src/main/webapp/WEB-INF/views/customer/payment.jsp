<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment | T-Booking</title>
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
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/booking"><i class="fa-solid fa-receipt me-2 text-white"></i>My Bookings</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bills"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i>My Bills</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-regular fa-star me-2 text-primary"></i>My Reviews</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-danger"></i>My Wishlist</a></li>
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
    <main class="profile-container py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <!-- Glassmorphism Card -->
                    <div class="glass-card p-5 rounded-4 shadow-lg border">
                        <div class="text-center mb-5">
                            <h2 class="fw-bold text-primary mb-2"><i class="fa-solid fa-credit-card me-2"></i>Offline Payment Confirmation</h2>
                            <p class="text-muted">Please transfer the deposit or full amount to the bank account below and confirm your payment.</p>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                                <i class="fa-solid fa-circle-xmark me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Booking Details Summary -->
                        <div class="p-4 rounded-4 bg-white bg-opacity-50 border mb-4">
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-circle-info text-primary me-2"></i>Booking Summary</h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Booking ID</span>
                                    <span class="fw-bold">#${booking.bookingId}</span>
                                </div>
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Number of Guests</span>
                                    <span class="fw-bold">${booking.numberOfPeople} People</span>
                                </div>
                                <c:if test="${not empty appliedVoucher}">
                                    <div class="col-md-6">
                                        <span class="text-muted d-block">Applied Voucher</span>
                                        <span class="fw-bold text-success">${appliedVoucher.voucherCode} (${appliedVoucher.discountPercent}%)</span>
                                    </div>
                                    <div class="col-md-6">
                                        <span class="text-muted d-block">Discount Amount</span>
                                        <span class="fw-bold text-success">
                                            -<fmt:formatNumber value="${discountAmount}" pattern="#,##0 ₫" />
                                        </span>
                                    </div>
                                </c:if>
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Total Price</span>
                                    <span class="fw-bold text-danger" style="font-size: 1.2rem;">
                                        <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0 ₫" />
                                    </span>
                                </div>
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Deposit Required</span>
                                    <span class="fw-bold text-primary" style="font-size: 1.2rem;">
                                        <fmt:formatNumber value="${booking.depositAmount}" pattern="#,##0 ₫" />
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Voucher Code Form -->
                        <div class="p-4 rounded-4 bg-white bg-opacity-50 border mb-4">
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-tag text-primary me-2"></i>Apply Voucher</h5>
                            <form action="${pageContext.request.contextPath}/payment" method="post">
                                <input type="hidden" name="action" value="applyVoucher">
                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                <div class="input-group">
                                    <input type="text" name="voucherCode" class="form-control rounded-start-pill ps-3" placeholder="Enter voucher code" value="${appliedVoucher != null ? appliedVoucher.voucherCode : ''}" required>
                                    <button class="btn btn-primary rounded-end-pill px-4" type="submit">Apply</button>
                                </div>
                            </form>
                        </div>

                        <!-- Bank Information -->
                        <div class="p-4 rounded-4 bg-light border mb-5">
                            <h5 class="fw-bold mb-3 text-success"><i class="fa-solid fa-building-columns me-2"></i>Company Bank Account Details</h5>
                            <div class="row g-3">
                                <div class="col-12">
                                    <span class="text-muted d-block">Bank Name</span>
                                    <span class="fw-bold" style="font-size: 1.1rem;">VIETCOMBANK (Joint Stock Commercial Bank for Foreign Trade of Vietnam)</span>
                                </div>
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Account Holder</span>
                                    <span class="fw-bold text-uppercase">T-BOOKING CO. LTD</span>
                                </div>
                                <div class="col-md-6">
                                    <span class="text-muted d-block">Account Number</span>
                                    <span class="fw-bold" style="font-size: 1.2rem; letter-spacing: 1px;">1023 4567 8900</span>
                                </div>
                                <div class="col-12">
                                    <span class="text-muted d-block">Transfer Content Pattern</span>
                                    <span class="fw-bold text-primary" style="font-size: 1.1rem; border-bottom: 2px dashed var(--primary); padding-bottom: 2px;">
                                        T-Booking #${booking.bookingId} Payment
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Form Confirmation -->
                        <form action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg rounded-pill">
                                    <i class="fa-solid fa-circle-check me-2"></i>Confirm I Have Transferred
                                </button>
                                <a href="${pageContext.request.contextPath}/booking" class="btn btn-link text-muted mt-2">
                                    Cancel and Return to Bookings
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap Bundle with Popper JS -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
