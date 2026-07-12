<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Detail | T-Booking</title>
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/booking"><i class="fa-solid fa-receipt me-2 text-primary"></i>My Bookings</a></li>
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/bills"><i class="fa-solid fa-file-invoice-dollar me-2 text-white"></i>My Bills</a></li>
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

    <!-- Content Section -->
    <main class="profile-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    
                    <div class="d-flex align-items-center mb-4">
                        <a href="${pageContext.request.contextPath}/bills" class="btn btn-outline-secondary rounded-pill me-3 px-3 py-2">
                            <i class="fa-solid fa-arrow-left me-1"></i>Back to Bills
                        </a>
                        <h4 class="mb-0 text-muted">Bill Detail #BILL${bill.bookingId}</h4>
                    </div>

                    <!-- Glassmorphism Card -->
                    <div class="card glass-card border-0 p-4 p-md-5">
                        
                        <!-- Top Header Status Bar -->
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-4 border-bottom flex-wrap gap-3">
                            <div>
                                <h3 class="mb-1" style="font-weight: 700; color: var(--text-main);">
                                    <c:out value="${bill.tourName}" />
                                </h3>
                                <p class="text-muted mb-0">
                                    <i class="fa-regular fa-calendar me-2"></i>Booking Date: 
                                    <fmt:formatDate value="${bill.bookingDate}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${bill.status == 'Pending'}">
                                        <span class="badge bg-warning text-dark px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-clock me-1"></i>Pending Review</span>
                                    </c:when>
                                    <c:when test="${bill.status == 'Approved' || bill.status == 'Confirmed' || bill.status == 'Paid'}">
                                        <span class="badge bg-success text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-circle-check me-1"></i>${bill.status}</span>
                                    </c:when>
                                    <c:when test="${bill.status == 'Cancelled'}">
                                        <span class="badge bg-danger text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-circle-xmark me-1"></i>Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;">${bill.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Left Section: Details -->
                            <div class="col-md-7">
                                <!-- Tour Details Card -->
                                <div class="p-4 rounded-4 bg-white bg-opacity-50 border mb-4">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-solid fa-map-location-dot text-primary me-2"></i>Tour & Schedule Info</h5>
                                    <table class="table table-borderless align-middle mb-0">
                                        <tr>
                                            <td class="text-muted ps-0" style="width: 35%;">Departure Date</td>
                                            <td class="fw-bold"><fmt:formatDate value="${bill.departureDate}" pattern="dd/MM/yyyy" /></td>
                                        </tr>
                                    </table>
                                </div>

                                <!-- Contact Info Card -->
                                <div class="p-4 rounded-4 bg-white bg-opacity-50 border">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-regular fa-user text-primary me-2"></i>Customer & Contact Details</h5>
                                    <table class="table table-borderless align-middle mb-0">
                                        <tr>
                                            <td class="text-muted ps-0" style="width: 35%;">Contact Name</td>
                                            <td class="fw-bold"><c:out value="${bill.contactName}" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Contact Phone</td>
                                            <td class="fw-bold"><c:out value="${bill.contactPhone}" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Number of Guests</td>
                                            <td class="fw-bold">
                                                <span class="badge rounded-pill bg-light text-dark px-3 py-2 border">
                                                    ${bill.numberOfPeople} <i class="fa-solid fa-users ms-1 text-muted"></i>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <!-- Right Section: Price & Summary -->
                            <div class="col-md-5">
                                <!-- Summary Price Breakdown Card -->
                                <div class="p-4 rounded-4 bg-light border mb-4">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-solid fa-receipt text-primary me-2"></i>Invoice Summary</h5>
                                    
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Total Guests</span>
                                        <span class="fw-bold">x ${bill.numberOfPeople}</span>
                                    </div>
                                    
                                    <hr>

                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="h6 mb-0" style="font-weight: 700;">Total Price</span>
                                        <span class="h5 mb-0 text-primary" style="font-weight: 800;">
                                            <fmt:formatNumber value="${bill.totalPrice}" type="currency" currencySymbol="$" />
                                        </span>
                                    </div>

                                    <div class="d-flex justify-content-between mb-1" style="font-size: 0.9rem;">
                                        <span class="text-muted">Paid/Deposit Amount</span>
                                        <span class="fw-bold text-success"><fmt:formatNumber value="${bill.depositAmount}" type="currency" currencySymbol="$" /></span>
                                    </div>
                                </div>

                                <!-- Actions for Pending payment -->
                                <c:if test="${bill.status == 'Pending'}">
                                    <div class="d-flex flex-column gap-2 w-100">
                                        <a href="${pageContext.request.contextPath}/payment?bookingId=${bill.bookingId}" class="btn btn-success w-100 rounded-pill py-3 px-4 shadow-sm text-white text-center fw-bold">
                                            <i class="fa-solid fa-credit-card me-2"></i>Pay Now
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap Bundle with Popper JS -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
