<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Discount Policies | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .hero-section {
            padding: 80px 0 50px 0;
            text-align: center;
        }
        .policy-card {
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            transition: all 0.3s ease;
            height: 100%;
        }
        .policy-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.05);
        }
        .icon-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        .bg-indigo-light {
            background-color: rgba(79, 70, 229, 0.1);
            color: #4f46e5;
        }
        .bg-sky-light {
            background-color: rgba(14, 165, 233, 0.1);
            color: #0ea5e9;
        }
        .bg-amber-light {
            background-color: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
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

    <!-- Dashboard Header Banner -->
    <header class="hero-section">
        <div class="container">
            <h1 class="hero-title">Manage <span>Discount Policies</span></h1>
            <p class="hero-subtitle">Configure system-wide booking discounts, group rates, and payment deposit requirements.</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mb-5">

        <!-- Notification Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success border-0 rounded-3 mb-4" role="alert" style="background-color: #f0fdf4; color: #15803d; font-size: 0.9rem;">
                <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/admin/discount-policies">
            <input type="hidden" name="action" value="updatePolicies">
            
            <div class="row g-4">
                <!-- UC 1: Configure Discount Rules -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-indigo-light">
                            <i class="fa-solid fa-percent"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Discount Rules</h4>
                        <p class="text-muted small mb-4">Set up general rules to automatically discount bookings exceeding a specific price threshold.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Booking Amount (đ)</label>
                            <input type="number" step="1000" min="0" name="discountMinAmount" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.discount_min_amount : '1000000.00'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Discount Rate (%)</label>
                            <input type="number" min="0" max="100" name="discountPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.discount_percent : '5'}" required>
                        </div>
                    </div>
                </div>

                <!-- UC 2: Configure Deposit Policy -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-sky-light">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Deposit Policy</h4>
                        <p class="text-muted small mb-4">Specify the minimum down-payment percentage required for customers to reserve slots on a tour.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Deposit Percentage (%)</label>
                            <input type="number" min="1" max="100" name="depositPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.deposit_percent : '20'}" required>
                            <div class="form-text small text-muted">A setting of 100% requires payment in full upon booking.</div>
                        </div>
                    </div>
                </div>

                <!-- UC 3: Configure Group Booking Discount -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-amber-light">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Group Booking Discount</h4>
                        <p class="text-muted small mb-4">Reward large parties by setting a discount threshold based on the number of people in the booking.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Group Size (People)</label>
                            <input type="number" min="1" name="groupMinPeople" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.group_min_people : '5'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Group Discount (%)</label>
                            <input type="number" min="0" max="100" name="groupDiscountPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.group_discount_percent : '10'}" required>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Button Bar -->
            <div class="d-flex justify-content-end gap-3 mt-5">
                <button type="reset" class="btn btn-outline-secondary px-4 py-2 rounded-pill">
                    <i class="fa-solid fa-rotate-left me-2"></i>Reset Form
                </button>
                <button type="submit" class="btn btn-primary text-white px-5 py-2 rounded-pill">
                    <i class="fa-solid fa-save me-2"></i>Save Policies
                </button>
            </div>
        </form>
    </main>

    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 100px;">
        &copy; 2026 T-Booking Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
