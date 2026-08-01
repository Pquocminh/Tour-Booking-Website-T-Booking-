<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | T-Booking</title>
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
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-white"></i>My Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/booking"><i class="fa-solid fa-receipt me-2 text-success"></i>My Bookings</a></li>
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

    <!-- Profile Content Section -->
    <main class="profile-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <!-- Glassmorphism Card -->
                    <div class="card glass-card border-0 p-4 p-md-5">
                        
                        <h2 class="section-title mb-4">
                            <i class="fa-regular fa-address-card text-primary me-2"></i>My Profile
                        </h2>
                        
                        <!-- Alerts -->
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                                <i class="fa-regular fa-circle-check me-2"></i>${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <div class="row g-4">
                            <!-- Left Sidebar: Profile Summary (Read-Only) -->
                            <div class="col-md-4">
                                <div class="profile-header-card">
                                    <div class="profile-avatar-circle">
                                        <i class="fa-regular fa-user"></i>
                                    </div>
                                    <h4 class="mb-1" style="font-weight: 700; color: var(--text-main);">${sessionScope.user.fullName}</h4>
                                    <p class="text-muted mb-3" style="font-size: 0.85rem;">${sessionScope.user.username}</p>
                                    <span class="badge rounded-pill px-3 py-2" style="background-color: rgba(79, 70, 229, 0.08); color: var(--primary); border: 1px solid rgba(79, 70, 229, 0.15);">
                                        Role: ${sessionScope.user.role}
                                    </span>
                                    
                                    <hr class="my-4 border-color">
                                    
                                    <div class="text-start">
                                        <div class="mb-3">
                                            <div class="info-label"><i class="fa-regular fa-calendar-check me-1"></i>Joined Date</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty sessionScope.user.createdAt}">
                                                        <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="info-label"><i class="fa-regular fa-circle-check me-1"></i>Account Status</div>
                                            <div class="info-value text-success">${sessionScope.user.status}</div>
                                        </div>
                                    </div>
                                    
                                    <hr class="my-4 border-color">
                                    <a href="${pageContext.request.contextPath}/customer/reviews" class="btn btn-outline-primary w-100 rounded-pill"><i class="fa-regular fa-star me-2"></i>My Reviews</a>
                                </div>
                            </div>
                            
                            <!-- Right Pane: Profile Details (Read-Only) -->
                            <div class="col-md-8">
                                <div class="p-3 bg-white bg-opacity-50 rounded-4 border border-color h-100 p-md-4">
                                    <h5 class="mb-4" style="font-weight: 700; color: var(--text-main);">Personal Information</h5>
                                    
                                    <div class="row g-3">
                                        <!-- Full Name -->
                                        <div class="col-12 col-sm-6">
                                            <div class="p-3 bg-white rounded-3 border border-color shadow-sm h-100">
                                                <div class="info-label"><i class="fa-solid fa-id-card me-1 text-primary"></i>Full Name</div>
                                                <div class="info-value mt-1" style="font-size: 1.1rem;">${sessionScope.user.fullName}</div>
                                            </div>
                                        </div>
                                        
                                        <!-- Email Address -->
                                        <div class="col-12 col-sm-6">
                                            <div class="p-3 bg-white rounded-3 border border-color shadow-sm h-100">
                                                <div class="info-label"><i class="fa-regular fa-envelope me-1 text-primary"></i>Email Address</div>
                                                <div class="info-value mt-1" style="font-size: 1.1rem; word-break: break-all;">${sessionScope.user.email}</div>
                                            </div>
                                        </div>
                                        
                                        <!-- Phone Number -->
                                        <div class="col-12 col-sm-6">
                                            <div class="p-3 bg-white rounded-3 border border-color shadow-sm h-100">
                                                <div class="info-label"><i class="fa-solid fa-phone me-1 text-primary"></i>Phone Number</div>
                                                <div class="info-value mt-1" style="font-size: 1.1rem;">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user.phone && sessionScope.user.phone != ''}">
                                                            ${sessionScope.user.phone}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted font-weight-normal" style="font-size: 0.95rem;">Not Provided</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Username -->
                                        <div class="col-12 col-sm-6">
                                            <div class="p-3 bg-white rounded-3 border border-color shadow-sm h-100">
                                                <div class="info-label"><i class="fa-regular fa-user me-1 text-primary"></i>Username</div>
                                                <div class="info-value mt-1" style="font-size: 1.1rem;">${sessionScope.user.username}</div>
                                            </div>
                                        </div>

                                        <!-- Address -->
                                        <div class="col-12">
                                            <div class="p-3 bg-white rounded-3 border border-color shadow-sm h-100">
                                                <div class="info-label"><i class="fa-solid fa-map-location-dot me-1 text-primary"></i>Address</div>
                                                <div class="info-value mt-1" style="font-size: 1.1rem;">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user.address && sessionScope.user.address != ''}">
                                                            ${sessionScope.user.address}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted font-weight-normal" style="font-size: 0.95rem;">Not Provided</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex flex-wrap justify-content-between align-items-center mt-5 gap-3">
                                        <div class="d-flex gap-2">
                                            <button type="button" class="btn btn-primary px-4 py-2 font-weight-semibold" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                                <i class="fa-solid fa-pen-to-square me-1"></i> Edit Profile
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary px-4 py-2 font-weight-semibold bg-white" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                                <i class="fa-solid fa-key me-1"></i> Change Password
                                            </button>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/tours" class="btn tour-btn px-4 py-2 font-weight-semibold">
                                            Back to Tours <i class="fa-solid fa-chevron-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
          <div class="modal-header bg-primary text-white" style="border-radius: var(--bs-border-radius-xl) var(--bs-border-radius-xl) 0 0;">
            <h5 class="modal-title" id="editProfileModalLabel"><i class="fa-solid fa-user-pen me-2"></i>Edit Profile</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/profile" method="POST" id="editProfileForm" novalidate>
              <div class="modal-body p-4">
                  <div id="clientProfileError" class="alert alert-danger border-0 rounded-3 mb-3" role="alert" style="display: none; background-color: #fef2f2; color: #b91c1c; font-size: 0.85rem;">
                      <i class="fa-solid fa-circle-exclamation me-2"></i><span id="clientProfileErrorText" class="fw-semibold"></span>
                  </div>
                  <input type="hidden" name="action" value="updateProfile">
                  
                  <div class="mb-3">
                      <label for="fullName" class="form-label font-weight-semibold">Full Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control form-control-lg" id="fullName" name="fullName" value="${sessionScope.user.fullName}">
                      <div class="form-text text-muted" style="font-size: 0.8rem;">Must contain only letters & spaces (auto-capitalizes first letters).</div>
                  </div>
                  
                  <div class="mb-3">
                      <label for="email" class="form-label font-weight-semibold">Email Address <span class="text-danger">*</span></label>
                      <input type="email" class="form-control form-control-lg" id="email" name="email" value="${sessionScope.user.email}">
                      <div class="form-text text-muted" style="font-size: 0.8rem;">Must end with @gmail.com</div>
                  </div>
                  
                  <div class="mb-3">
                      <label for="phone" class="form-label font-weight-semibold">Phone Number <span class="text-danger">*</span></label>
                      <input type="text" class="form-control form-control-lg" id="phone" name="phone" value="${sessionScope.user.phone}">
                      <div class="form-text text-muted" style="font-size: 0.8rem;">Must contain 9-11 digits only (no characters or special symbols).</div>
                  </div>
                  
                  <div class="mb-3">
                      <label for="address" class="form-label font-weight-semibold">Address</label>
                      <textarea class="form-control" id="address" name="address" rows="3">${sessionScope.user.address}</textarea>
                  </div>
              </div>
              <div class="modal-footer border-0 p-4 pt-0">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                  <button type="submit" class="btn btn-primary px-4">Save Changes</button>
              </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
          <div class="modal-header bg-dark text-white" style="border-radius: var(--bs-border-radius-xl) var(--bs-border-radius-xl) 0 0;">
            <h5 class="modal-title" id="changePasswordModalLabel"><i class="fa-solid fa-lock me-2"></i>Change Password</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/profile" method="POST" id="changePasswordForm" novalidate>
              <div class="modal-body p-4">
                  <div id="clientPassError" class="alert alert-danger border-0 rounded-3 mb-3" role="alert" style="display: none; background-color: #fef2f2; color: #b91c1c; font-size: 0.85rem;">
                      <i class="fa-solid fa-circle-exclamation me-2"></i><span id="clientPassErrorText" class="fw-semibold"></span>
                  </div>
                  <input type="hidden" name="action" value="changePassword">
                  
                  <div class="mb-3">
                      <label for="oldPassword" class="form-label font-weight-semibold">Current Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="oldPassword" name="oldPassword">
                  </div>
                  
                  <div class="mb-3">
                      <label for="newPassword" class="form-label font-weight-semibold">New Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="newPassword" name="newPassword">
                  </div>
                  
                  <div class="mb-3">
                      <label for="confirmPassword" class="form-label font-weight-semibold">Confirm New Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="confirmPassword" name="confirmPassword">
                  </div>
              </div>
              <div class="modal-footer border-0 p-4 pt-0">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                  <button type="submit" class="btn btn-dark px-4">Update Password</button>
              </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="text-center text-lg-start">
        <div class="container p-4">
            <div class="row">
                <div class="col-lg-6 col-md-12 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white font-weight-bold mb-3">T-Booking Tour Website</h5>
                    <p class="text-muted">
                        We are proud to offer our customers discovery tours, unique international experiences, and professional corporate visits.
                    </p>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white mb-3">Quick Links</h5>
                    <ul class="list-unstyled mb-0">
                        <li><a href="${pageContext.request.contextPath}/tours">Tour Packages</a></li>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Support Contact</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5 class="text-uppercase text-white mb-3">Contact Us</h5>
                    <ul class="list-unstyled text-muted">
                        <li><i class="fa-solid fa-phone me-2"></i>0374099505</li>
                        <li><i class="fa-solid fa-envelope me-2"></i>pquocminh2005@gmail.com</li>
                        <li><i class="fa-solid fa-map-marker-alt me-2"></i>Can Tho, Vietnam</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="text-center p-3 border-top border-secondary text-muted">
            &copy; 2026 T-Booking. All rights reserved.
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        function showProfileError(msg) {
            const errBox = document.getElementById('clientProfileError');
            const errText = document.getElementById('clientProfileErrorText');
            if (errBox && errText) {
                errText.innerText = msg;
                errBox.style.display = 'block';
                errBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

        function showPassError(msg) {
            const errBox = document.getElementById('clientPassError');
            const errText = document.getElementById('clientPassErrorText');
            if (errBox && errText) {
                errText.innerText = msg;
                errBox.style.display = 'block';
                errBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const editForm = document.getElementById('editProfileForm');
            if (editForm) {
                editForm.addEventListener('submit', function(e) {
                    const fullNameInput = document.getElementById('fullName');
                    const emailInput = document.getElementById('email');
                    const phoneInput = document.getElementById('phone');

                    const fullNameVal = fullNameInput ? fullNameInput.value.trim() : '';
                    const emailVal = emailInput ? emailInput.value.trim() : '';
                    const phoneVal = phoneInput ? phoneInput.value.trim() : '';

                    const nameRegex = /^[\p{L}\s]+$/u;
                    if (!fullNameVal || !nameRegex.test(fullNameVal)) {
                        showProfileError('Full Name cannot be empty and cannot contain numbers or special characters.');
                        if (fullNameInput) fullNameInput.focus();
                        e.preventDefault();
                        return false;
                    }

                    const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/i;
                    if (!emailVal || !emailRegex.test(emailVal)) {
                        showProfileError('Email address must end with @gmail.com.');
                        if (emailInput) emailInput.focus();
                        e.preventDefault();
                        return false;
                    }

                    const phoneRegex = /^\d{9,11}$/;
                    if (!phoneVal || !phoneRegex.test(phoneVal)) {
                        showProfileError('Phone Number cannot be empty and must contain 9 to 11 digits only.');
                        if (phoneInput) phoneInput.focus();
                        e.preventDefault();
                        return false;
                    }
                });
            }

            const passForm = document.getElementById('changePasswordForm');
            if (passForm) {
                passForm.addEventListener('submit', function(e) {
                    const oldPass = document.getElementById('oldPassword').value;
                    const newPass = document.getElementById('newPassword').value;
                    const confirmPass = document.getElementById('confirmPassword').value;

                    if (!oldPass) {
                        showPassError('Please enter your Current Password.');
                        document.getElementById('oldPassword').focus();
                        e.preventDefault();
                        return false;
                    }
                    if (!newPass) {
                        showPassError('Please enter your New Password.');
                        document.getElementById('newPassword').focus();
                        e.preventDefault();
                        return false;
                    }
                    const passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
                    if (!passRegex.test(newPass)) {
                        showPassError('New Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.');
                        document.getElementById('newPassword').focus();
                        e.preventDefault();
                        return false;
                    }
                    if (newPass !== confirmPass) {
                        showPassError('Confirm Password does not match New Password!');
                        document.getElementById('confirmPassword').focus();
                        e.preventDefault();
                        return false;
                    }
                });
            }
        });
    </script>
</body>
</html>

