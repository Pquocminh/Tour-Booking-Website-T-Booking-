<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | T-Booking</title>
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

                    <!-- Glassmorphism Card -->
                    <div class="card glass-card border-0 p-4 p-md-5">
                        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                            <h2 class="section-title mb-0">
                                <i class="fa-solid fa-receipt text-primary me-2"></i>My Bookings
                            </h2>
                            <a href="${pageContext.request.contextPath}/tours" class="btn btn-primary rounded-pill px-4">
                                <i class="fa-solid fa-plus me-2"></i>Book New Tour
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty bookings}">
                                <div class="text-center py-5">
                                    <div class="mb-4">
                                        <i class="fa-regular fa-folder-open text-muted" style="font-size: 4rem;"></i>
                                    </div>
                                    <h4 class="text-muted">No Bookings Found</h4>
                                    <p class="text-muted mb-4">You haven't booked any tours yet. Start exploring our exciting packages now!</p>
                                    <a href="${pageContext.request.contextPath}/tours" class="btn btn-outline-primary rounded-pill px-4">Browse Tours</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table align-middle" style="border-collapse: separate; border-spacing: 0 10px;">
                                        <thead>
                                            <tr class="text-muted" style="border-bottom: 2px solid rgba(0,0,0,0.05);">
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600;">ID</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600;">Tour Name</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600;">Booking Date</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600;">Departure Date</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600; text-align: center;">Guests</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600; text-align: right;">Total Price</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600; text-align: center;">Status</th>
                                                <th scope="col" style="padding-bottom: 12px; font-weight: 600; text-align: center;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${bookings}">
                                                <tr style="background: rgba(255,255,255,0.4); border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); transition: transform 0.2s, box-shadow 0.2s;">
                                                    <td style="padding: 16px; font-weight: 600; border-top-left-radius: 12px; border-bottom-left-radius: 12px; border: none;">
                                                        #B${b.bookingId}
                                                    </td>
                                                    <td style="padding: 16px; font-weight: 500; color: var(--text-main); border: none;">
                                                        <c:out value="${b.tourName}" />
                                                    </td>
                                                    <td style="padding: 16px; color: #666; border: none;">
                                                        <fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td style="padding: 16px; color: #666; border: none;">
                                                        <fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td style="padding: 16px; text-align: center; border: none;">
                                                        <span class="badge rounded-pill bg-light text-dark px-3 py-2 border">
                                                            ${b.numberOfPeople} <i class="fa-solid fa-users ms-1 text-muted"></i>
                                                        </span>
                                                    </td>
                                                    <td style="padding: 16px; text-align: right; font-weight: 700; color: var(--primary); border: none;">
                                                        <fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="$" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 16px; text-align: center; border: none;">
                                                        <c:choose>
                                                            <c:when test="${b.status == 'Pending'}">
                                                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill"><i class="fa-regular fa-clock me-1"></i>Pending</span>
                                                            </c:when>
                                                            <c:when test="${b.status == 'Approved' || b.status == 'Confirmed'}">
                                                                <span class="badge bg-success text-white px-3 py-2 rounded-pill"><i class="fa-regular fa-circle-check me-1"></i>Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${b.status == 'Cancelled'}">
                                                                <span class="badge bg-danger text-white px-3 py-2 rounded-pill"><i class="fa-regular fa-circle-xmark me-1"></i>Cancelled</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary text-white px-3 py-2 rounded-pill">${b.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 16px; text-align: center; border-top-right-radius: 12px; border-bottom-right-radius: 12px; border: none; white-space: nowrap;">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <a href="${pageContext.request.contextPath}/booking?action=detail&bookingId=${b.bookingId}" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                                <i class="fa-regular fa-eye me-1"></i>View
                                                            </a>
                                                            <c:if test="${b.status == 'Pending'}">
                                                                <a href="${pageContext.request.contextPath}/payment?bookingId=${b.bookingId}" class="btn btn-sm btn-success rounded-pill px-3 text-white">
                                                                    <i class="fa-solid fa-credit-card me-1"></i>Pay Now
                                                                </a>
                                                                <form action="${pageContext.request.contextPath}/booking" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking? This will restore the available slots.');" style="display:inline;">
                                                                    <input type="hidden" name="action" value="cancel">
                                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                                                        <i class="fa-regular fa-circle-xmark me-1"></i>Cancel
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
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
    </main>

    <!-- Bootstrap Bundle with Popper JS -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
