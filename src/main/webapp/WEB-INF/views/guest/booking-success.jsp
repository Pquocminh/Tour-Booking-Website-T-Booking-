<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Success | T-Booking</title>
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
                    <c:if test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown ms-lg-3">
                            <a class="nav-link dropdown-toggle btn btn-outline-primary rounded-pill px-4 py-2" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-regular fa-user me-1"></i>Hi, ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Logout</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5 text-center">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="glass-card p-5 border-success shadow-lg" style="border-top: 5px solid #198754;">
                    <div class="mb-4 text-success">
                        <i class="fa-solid fa-circle-check" style="font-size: 5rem;"></i>
                    </div>
                    <h2 class="fw-bold mb-3">Booking Successful!</h2>
                    <p class="text-secondary lead mb-4">
                        Thank you for booking with T-Booking. Your tour reservation is currently <strong class="text-warning">Pending</strong>.
                        We have recorded your booking and will process it shortly.
                    </p>
                    <p class="mb-4">
                        Please proceed to your profile to view your booking details or continue exploring our amazing tours.
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/tours" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold">
                            <i class="fa-solid fa-compass me-2"></i>Explore Tours
                        </a>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary rounded-pill px-4 py-2 fw-bold">
                            <i class="fa-solid fa-user me-2"></i>View My Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer-custom py-4 mt-auto">
        <div class="container text-center">
            <p class="mb-0 text-white-50">&copy; 2026 T-Booking. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
