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

            <!-- Client Error Display -->
            <div id="clientRegisterError" class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="display: none; background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-circle-exclamation me-2"></i><span id="clientRegisterErrorText" class="fw-semibold"></span>
            </div>
            
            <form action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return validateForm()" novalidate>
                <!-- Full Name -->
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" 
                           value="${not empty registeredAccount ? registeredAccount.fullName : ''}">
                    <label for="fullName">Full Name</label>
                </div>
                
                <!-- Email -->
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email Address" 
                           value="${not empty registeredAccount ? registeredAccount.email : ''}">
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
                           value="${not empty registeredAccount ? registeredAccount.username : ''}">
                    <label for="username">Username</label>
                </div>
                
                <!-- Password -->
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                    <label for="password">Password</label>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-floating mb-4">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password">
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
        function showRegisterError(msg) {
            const errBox = document.getElementById('clientRegisterError');
            const errText = document.getElementById('clientRegisterErrorText');
            if (errBox && errText) {
                errText.innerText = msg;
                errBox.style.display = 'block';
                errBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

        function validateForm() {
            const fullName = document.getElementById("fullName").value.trim();
            if (!fullName) {
                showRegisterError("Please enter your Full Name.");
                document.getElementById("fullName").focus();
                return false;
            }
            const nameRegex = /^[\p{L}\s]+$/u;
            if (!nameRegex.test(fullName)) {
                showRegisterError("Full Name cannot contain numbers or special characters!");
                document.getElementById("fullName").focus();
                return false;
            }

            const email = document.getElementById("email").value.trim();
            if (!email) {
                showRegisterError("Please enter your Email Address.");
                document.getElementById("email").focus();
                return false;
            }
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showRegisterError("Please enter a valid Email Address.");
                document.getElementById("email").focus();
                return false;
            }

            const phone = document.getElementById("phone").value.trim();
            if (phone && !/^\d{9,11}$/.test(phone)) {
                showRegisterError("Phone Number must contain 9 to 11 digits only.");
                document.getElementById("phone").focus();
                return false;
            }

            const username = document.getElementById("username").value.trim();
            if (!username) {
                showRegisterError("Please enter a Username.");
                document.getElementById("username").focus();
                return false;
            }
            const userRegex = /^[a-zA-Z0-9_]{3,30}$/;
            if (!userRegex.test(username)) {
                showRegisterError("Username must be 3 to 30 characters long and contain only letters, numbers, or underscores.");
                document.getElementById("username").focus();
                return false;
            }

            const password = document.getElementById("password").value;
            if (!password) {
                showRegisterError("Please enter a Password.");
                document.getElementById("password").focus();
                return false;
            }
            const passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
            if (!passRegex.test(password)) {
                showRegisterError("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.");
                document.getElementById("password").focus();
                return false;
            }

            const confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                showRegisterError("Passwords do not match!");
                document.getElementById("confirmPassword").focus();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>

