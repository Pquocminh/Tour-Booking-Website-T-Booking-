<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP | T-Booking</title>
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
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tours">Tours</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="login-container">
        <div class="login-card">
            <a href="${pageContext.request.contextPath}/tours" class="login-logo">
                <i class="fa-solid fa-plane-departure me-2"></i>T-Booking
            </a>
            
            <h3 class="text-center font-weight-bold mb-2" style="font-weight: 700; color: #0f172a;">Verify OTP</h3>
            <p class="text-center text-muted mb-4" style="font-size: 0.9rem;">
                We sent a 6-digit verification code to <br/><strong class="text-dark">${sessionScope.resetEmail}</strong>.<br/>
                It is valid for <strong>5 minutes</strong>.
            </p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                </div>
            </c:if>
            
            <!-- OTP Verification Form -->
            <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
                <div class="mb-4">
                    <label for="otp" class="form-label text-muted d-block text-center mb-2" style="font-size: 0.85rem;">Verification Code</label>
                    <input type="text" class="form-control form-control-lg otp-input" id="otp" name="otp" 
                           placeholder="000000" maxlength="6" pattern="[0-9]{6}" required autocomplete="off">
                    <div class="form-text text-center mt-2">Enter 6 numeric digits.</div>
                </div>
                
                <button type="submit" class="btn tour-btn w-100 py-3 font-weight-semibold" style="border-radius: 14px;">
                    Verify Code
                </button>
            </form>
            
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-primary text-decoration-none font-weight-semibold" style="font-size: 0.85rem;">
                    <i class="fa-solid fa-arrow-left me-1"></i> Request a new code
                </a>
            </div>
        </div>
    </div>

</body>
</html>

