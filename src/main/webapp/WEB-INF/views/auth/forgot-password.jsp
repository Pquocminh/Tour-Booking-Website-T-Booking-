<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | T-Booking</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 0;
            background: radial-gradient(circle at top right, rgba(99, 102, 241, 0.1) 0%, transparent 60%);
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: 24px;
            box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.05);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            transition: all 0.4s ease;
        }
        
        .login-logo {
            font-weight: 800;
            font-size: 2rem;
            background: linear-gradient(135deg, #4f46e5 0%, #0ea5e9 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 30px;
            display: block;
            text-decoration: none;
        }
        
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #4f46e5;
        }
        
        .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.15);
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
            
            <h3 class="text-center font-weight-bold mb-2" style="font-weight: 700; color: #0f172a;">Forgot Password</h3>
            <p class="text-center text-muted mb-4" style="font-size: 0.9rem;">
                Enter your email address below, and we will send you a 6-digit OTP verification code to reset your password.
            </p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                </div>
            </c:if>
            
            <!-- Email Submission Form -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <div class="form-floating mb-4">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                    <label for="email">Email Address</label>
                </div>
                
                <button type="submit" class="btn tour-btn w-100 py-3 font-weight-semibold" style="border-radius: 14px;">
                    Send Reset OTP
                </button>
            </form>
            
            <p class="text-center text-muted mt-4 mb-0" style="font-size: 0.85rem;">
                Remember your password? <a href="${pageContext.request.contextPath}/login" class="text-primary font-weight-semibold">Sign In</a>
            </p>
        </div>
    </div>

</body>
</html>
