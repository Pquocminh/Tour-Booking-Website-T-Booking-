<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | T-Booking</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Identity Services SDK -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    
    
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
            
            <h3 class="text-center font-weight-bold mb-4" style="font-weight: 700; color: #0f172a;">Sign In</h3>
            
            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success border-0 rounded-3 mb-4" role="alert" style="background-color: #f0fdf4; color: #15803d; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-check me-2"></i>Registration successful! Please sign in.
                </div>
            </c:if>
            
            <c:if test="${param.resetSuccess == 'true'}">
                <div class="alert alert-success border-0 rounded-3 mb-4" role="alert" style="background-color: #f0fdf4; color: #15803d; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-check me-2"></i>Password reset successfully! Please sign in with your new password.
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                </div>
            </c:if>
            
            <!-- Credentials Sign-In Form -->
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                    <label for="username">Username or Email</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password">Password</label>
                </div>
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div></div>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-primary text-decoration-none" style="font-size: 0.85rem; font-weight: 500;">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn tour-btn w-100 py-3 font-weight-semibold" style="border-radius: 14px;">
                    Sign In
                </button>
            </form>
            
            <div class="divider">or sign in with</div>
            
            <!-- Google Sign-In Integration -->
            <div class="google-btn-wrapper">
                <!-- Replace standard Client ID. For demo/localhost testing, you should enter your own Client ID here -->
                <div id="g_id_onload"
                     data-client_id="1004561404612-co355mg6v00hbc4ilcciq2a16qnnngs9.apps.googleusercontent.com"
                     data-context="signin"
                     data-ux_mode="popup"
                     data-callback="handleCredentialResponse"
                     data-auto_prompt="false">
                </div>
                
                <div class="g_id_signin"
                     data-type="standard"
                     data-shape="pill"
                     data-theme="outline"
                     data-text="signin_with"
                     data-size="large"
                     data-logo_alignment="left"
                     data-width="370">
                </div>
            </div>
            
            <p class="text-center text-muted mt-4 mb-0" style="font-size: 0.85rem;">
                Don't have an account? <a href="${pageContext.request.contextPath}/register" class="text-primary font-weight-semibold">Sign Up</a>
            </p>
            <p class="text-center text-muted mt-2 mb-0" style="font-size: 0.85rem;">
                Back to <a href="${pageContext.request.contextPath}/tours" class="text-primary font-weight-medium">Tours Listing</a>
            </p>
        </div>
    </div>

    <!-- Hidden form to submit Google credentials to servlet -->
    <form id="googleLoginForm" action="${pageContext.request.contextPath}/login-google" method="POST" style="display: none;">
        <input type="hidden" name="credential" id="googleCredential">
    </form>

    <script>
        // Callback function triggered upon successful Google authentication
        function handleCredentialResponse(response) {
            if (response.credential) {
                // Populate the hidden form and submit it to LoginGoogleController
                document.getElementById('googleCredential').value = response.credential;
                document.getElementById('googleLoginForm').submit();
            }
        }
    </script>
</body>
</html>

