<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Details | T-Booking</title>
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
                        <a href="${pageContext.request.contextPath}/booking" class="btn btn-outline-secondary rounded-pill me-3 px-3 py-2">
                            <i class="fa-solid fa-arrow-left me-1"></i>Back to List
                        </a>
                        <h4 class="mb-0 text-muted">Booking Detail #B${booking.bookingId}</h4>
                    </div>

                    <!-- Glassmorphism Card -->
                    <div class="card glass-card border-0 p-4 p-md-5">
                        
                        <!-- Top header status bar -->
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-4 border-bottom flex-wrap gap-3">
                            <div>
                                <h3 class="mb-1" style="font-weight: 700; color: var(--text-main);">
                                    <c:out value="${tour.tourName}" />
                                </h3>
                                <p class="text-muted mb-0">
                                    <i class="fa-regular fa-calendar me-2"></i>Booked Date: 
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${booking.status == 'Pending'}">
                                        <span class="badge bg-warning text-dark px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-clock me-1"></i>Pending Review</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'Approved' || booking.status == 'Confirmed'}">
                                        <span class="badge bg-success text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-circle-check me-1"></i>Booking Confirmed</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'Cancelled'}">
                                        <span class="badge bg-danger text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;"><i class="fa-regular fa-circle-xmark me-1"></i>Booking Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary text-white px-4 py-3 rounded-pill" style="font-size: 0.95rem; font-weight: 600;">${booking.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row g-4">
                            <!-- Left Section: Details -->
                            <div class="col-md-7">
                                <!-- Tour Details card -->
                                <div class="p-4 rounded-4 bg-white bg-opacity-50 border mb-4">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-solid fa-map-location-dot text-primary me-2"></i>Tour Information</h5>
                                    <table class="table table-borderless align-middle mb-0">
                                        <tr>
                                            <td class="text-muted ps-0" style="width: 35%;">Departure Point</td>
                                            <td class="fw-bold"><c:out value="${tour.departureLocation}" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Departure Date</td>
                                            <td class="fw-bold"><fmt:formatDate value="${schedule.departureDate}" pattern="dd/MM/yyyy" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Return Date</td>
                                            <td class="fw-bold"><fmt:formatDate value="${schedule.returnDate}" pattern="dd/MM/yyyy" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Duration</td>
                                            <td class="fw-bold">${tour.durationDays} Days</td>
                                        </tr>
                                    </table>
                                </div>

                                <!-- Contact Info card -->
                                <div class="p-4 rounded-4 bg-white bg-opacity-50 border">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-regular fa-user text-primary me-2"></i>Contact & Guests</h5>
                                    <table class="table table-borderless align-middle mb-0">
                                        <tr>
                                            <td class="text-muted ps-0" style="width: 35%;">Lead Contact Name</td>
                                            <td class="fw-bold"><c:out value="${booking.contactName}" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Contact Phone</td>
                                            <td class="fw-bold"><c:out value="${booking.contactPhone}" /></td>
                                        </tr>
                                        <tr>
                                            <td class="text-muted ps-0">Number of Guests</td>
                                            <td class="fw-bold">
                                                <span class="badge rounded-pill bg-light text-dark px-3 py-2 border">
                                                    ${booking.numberOfPeople} <i class="fa-solid fa-users ms-1 text-muted"></i>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <!-- Right Section: Price & Payments -->
                            <div class="col-md-5">
                                <!-- Summary Price Breakdown card -->
                                <div class="p-4 rounded-4 bg-light border mb-4">
                                    <h5 class="mb-3" style="font-weight: 700;"><i class="fa-solid fa-receipt text-primary me-2"></i>Price Breakdown</h5>
                                    
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Price per person</span>
                                        <span class="fw-bold"><fmt:formatNumber value="${schedule.price}" pattern="#,##0 ₫" /></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Total guests</span>
                                        <span class="fw-bold">x ${booking.numberOfPeople}</span>
                                    </div>

                                    <c:if test="${not empty voucher}">
                                        <div class="d-flex justify-content-between mb-2 text-success">
                                            <span>Voucher Code (${voucher.voucherCode})</span>
                                            <span>-${voucher.discountPercent}%</span>
                                        </div>
                                    </c:if>
                                    
                                    <hr>

                                    <div class="d-flex justify-content-between mb-3">
                                        <span class="h6 mb-0" style="font-weight: 700;">Total Amount</span>
                                        <span class="h5 mb-0 text-primary" style="font-weight: 800;">
                                            <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0 ₫" />
                                        </span>
                                    </div>

                                    <div class="d-flex justify-content-between mb-1" style="font-size: 0.9rem;">
                                        <span class="text-muted">Required Deposit</span>
                                        <span class="fw-bold text-dark"><fmt:formatNumber value="${booking.depositAmount}" pattern="#,##0 ₫" /></span>
                                    </div>
                                </div>

                                 <!-- Actions for Pending Booking -->
                                 <c:if test="${booking.status == 'Pending'}">
                                     <div class="d-flex flex-column gap-2 w-100">
                                         <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.bookingId}" class="btn btn-success w-100 rounded-pill py-3 px-4 shadow-sm text-white text-center fw-bold">
                                             <i class="fa-solid fa-credit-card me-2"></i>Pay Now
                                         </a>
                                         <form action="${pageContext.request.contextPath}/booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking? This will restore the available slots.');" class="w-100">
                                             <input type="hidden" name="action" value="cancel">
                                             <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                             <button type="submit" class="btn btn-outline-danger w-100 rounded-pill py-3 px-4 shadow-sm">
                                                 <i class="fa-regular fa-circle-xmark me-2"></i>Cancel Booking
                                             </button>
                                         </form>
                                     </div>
                                 </c:if>
                            </div>
                        </div>

                        <!-- Bottom Section: Transactions History -->
                        <div class="mt-5 p-4 rounded-4 bg-white bg-opacity-50 border">
                            <h5 class="mb-4" style="font-weight: 700;"><i class="fa-solid fa-money-bill-transfer text-primary me-2"></i>Payment History</h5>
                            <c:choose>
                                <c:when test="${empty payments}">
                                    <div class="text-center py-4">
                                        <p class="text-muted mb-0">No payment logs found for this booking yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table align-middle mb-0">
                                            <thead>
                                                <tr class="text-muted">
                                                    <th>Transaction Code</th>
                                                    <th>Payment Date</th>
                                                    <th>Method</th>
                                                    <th>Type</th>
                                                    <th class="text-end">Amount</th>
                                                    <th class="text-center">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="p" items="${payments}">
                                                    <tr>
                                                        <td class="fw-bold">${p.transactionCode}</td>
                                                        <td><fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                        <td>${p.paymentMethod}</td>
                                                        <td>
                                                            <span class="badge rounded-pill bg-light text-dark px-3 py-1 border">${p.paymentType}</span>
                                                        </td>
                                                        <td class="text-end fw-bold text-success">
                                                            <fmt:formatNumber value="${p.amount}" pattern="#,##0 ₫" />
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${p.paymentStatus == 'Success' || p.paymentStatus == 'COMPLETED'}">
                                                                    <span class="badge bg-success text-white px-2 py-1.5 rounded-pill"><i class="fa-regular fa-circle-check me-1"></i>Completed</span>
                                                                </c:when>
                                                                <c:when test="${p.paymentStatus == 'Pending'}">
                                                                    <span class="badge bg-warning text-dark px-2 py-1.5 rounded-pill"><i class="fa-regular fa-clock me-1"></i>Pending</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary text-white px-2 py-1.5 rounded-pill">${p.paymentStatus}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
