<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | T-Booking</title>
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
                </ul>
            </div>
        </div>
    </nav>

    <div class="register-container">
        <div class="register-card">
            <a href="${pageContext.request.contextPath}/tours" class="register-logo">
                <i class="fa-solid fa-plane-departure me-2"></i>T-Booking
            </a>
            
            <h3 class="text-center font-weight-bold mb-4" style="font-weight: 700; color: #0f172a;">Create Account</h3>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return validateForm()">
                <!-- Full Name -->
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" 
                           value="${not empty registeredAccount ? registeredAccount.fullName : ''}" required>
                    <label for="fullName">Full Name</label>
                </div>
                
                <!-- Email -->
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email Address" 
                           value="${not empty registeredAccount ? registeredAccount.email : ''}" required>
                    <label for="email">Email Address</label>
                </div>
                
                <!-- Phone -->
                <div class="form-floating mb-3">
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Phone Number" 
                           value="${not empty registeredAccount ? registeredAccount.phone : ''}">
                    <label for="phone">Phone Number (Optional)</label>
                </div>
                
                <!-- Username -->
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" 
                           value="${not empty registeredAccount ? registeredAccount.username : ''}" 
                           pattern="^[a-zA-Z0-9_]{3,30}$" title="Username must be 3-30 characters long and contain only letters, numbers, or underscores" required>
                    <label for="username">Username</label>
                </div>
                
                <!-- Password -->
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" 
                           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required>
                    <label for="password">Password</label>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-floating mb-4">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" minlength="6" required>
                    <label for="confirmPassword">Confirm Password</label>
                </div>
                
                <button type="submit" class="btn tour-btn w-100 py-3 font-weight-semibold" style="border-radius: 14px;">
                    Sign Up
                </button>
            </form>
            
            <p class="text-center text-muted mt-4 mb-0" style="font-size: 0.85rem;">
                Already have an account? <a href="${pageContext.request.contextPath}/login" class="text-primary font-weight-semibold">Sign In</a>
            </p>
        </div>
    </div>

    <script>
        function validateForm() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>

