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
    
    <style>
        .profile-container {
            padding: 60px 0 80px 0;
            background: radial-gradient(circle at top right, rgba(99, 102, 241, 0.08) 0%, transparent 60%);
        }
        
        .profile-header-card {
            text-align: center;
            padding: 30px 20px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 250, 252, 0.9) 100%);
            border-radius: 20px;
            border: 1px solid var(--border-color);
        }
        
        .profile-avatar-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            font-size: 2.2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px auto;
            box-shadow: 0 8px 20px rgba(79, 70, 229, 0.15);
        }
        
        .info-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 3px;
        }
        
        .info-value {
            font-weight: 600;
            color: var(--text-main);
            font-size: 0.95rem;
        }

        .border-color {
            border-color: rgba(226, 232, 240, 0.8) !important;
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-primary"></i>My Wishlist</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Schedules</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/promotions"><i class="fa-solid fa-percent me-2 text-primary"></i>Manage Promotions</a></li>
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
                                    <p class="text-muted mb-3" style="font-size: 0.85rem;">@${sessionScope.user.username}</p>
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
                                                        <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd MMMM yyyy"/>
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
                                                <div class="info-value mt-1" style="font-size: 1.1rem;">@${sessionScope.user.username}</div>
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
          <form action="${pageContext.request.contextPath}/profile" method="POST">
              <div class="modal-body p-4">
                  <input type="hidden" name="action" value="updateProfile">
                  
                  <div class="mb-3">
                      <label for="fullName" class="form-label font-weight-semibold">Full Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control form-control-lg" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                  </div>
                  
                  <div class="mb-3">
                      <label for="email" class="form-label font-weight-semibold">Email Address <span class="text-danger">*</span></label>
                      <input type="email" class="form-control form-control-lg" id="email" name="email" value="${sessionScope.user.email}" required>
                  </div>
                  
                  <div class="mb-3">
                      <label for="phone" class="form-label font-weight-semibold">Phone Number</label>
                      <input type="text" class="form-control form-control-lg" id="phone" name="phone" value="${sessionScope.user.phone}">
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
          <form action="${pageContext.request.contextPath}/profile" method="POST">
              <div class="modal-body p-4">
                  <input type="hidden" name="action" value="changePassword">
                  
                  <div class="mb-3">
                      <label for="oldPassword" class="form-label font-weight-semibold">Current Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="oldPassword" name="oldPassword" required>
                  </div>
                  
                  <div class="mb-3">
                      <label for="newPassword" class="form-label font-weight-semibold">New Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="newPassword" name="newPassword" required>
                  </div>
                  
                  <div class="mb-3">
                      <label for="confirmPassword" class="form-label font-weight-semibold">Confirm New Password <span class="text-danger">*</span></label>
                      <input type="password" class="form-control form-control-lg" id="confirmPassword" name="confirmPassword" required>
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
</body>
</html>
