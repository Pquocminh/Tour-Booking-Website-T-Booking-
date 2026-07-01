<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | T-Booking</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .wishlist-container {
            padding: 40px 0 80px 0;
            background: radial-gradient(circle at top right, rgba(99, 102, 241, 0.06) 0%, transparent 60%);
        }
        
        .wishlist-card {
            position: relative;
        }
        
        /* Shifting category tag so it does not overlap checkbox */
        .wishlist-card .tour-category-tag {
            left: 50px;
        }

        /* Checkbox Styling */
        .wishlist-checkbox-wrapper {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 10;
        }

        .wishlist-checkbox {
            width: 24px;
            height: 24px;
            border-radius: 6px;
            border: 2px solid #fff;
            background-color: rgba(255, 255, 255, 0.85);
            cursor: pointer;
            transition: var(--transition-smooth);
            box-shadow: var(--shadow-sm);
            appearance: none;
            -webkit-appearance: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .wishlist-checkbox:checked {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        .wishlist-checkbox:checked::after {
            content: "\f00c";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            color: white;
            font-size: 11px;
        }

        .wishlist-checkbox:hover {
            transform: scale(1.05);
            background-color: #fff;
        }

        /* Single removal button */
        .wishlist-remove-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 10;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid var(--border-color);
            color: #ef4444;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition-smooth);
            box-shadow: var(--shadow-sm);
        }

        .wishlist-remove-btn:hover {
            background: #ef4444;
            color: #fff;
            transform: scale(1.1);
            box-shadow: 0 4px 10px rgba(239, 68, 68, 0.25);
        }

        /* Selection action bar */
        .select-actions-bar {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            transition: var(--transition-smooth);
        }

        .empty-wishlist-card {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 60px 40px;
            box-shadow: var(--shadow-sm);
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
                                    <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/wishlist"><i class="fa-solid fa-heart me-2 text-white"></i>My Wishlist</a></li>
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

    <!-- Main Content -->
    <main class="wishlist-container">
        <div class="container">
            
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/tours" class="text-primary"><i class="fa-solid fa-house me-1"></i>Tours</a></li>
                    <li class="breadcrumb-item active" aria-current="page">My Wishlist</li>
                </ol>
            </nav>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="hero-title text-start mb-1">My <span>Wishlist</span></h1>
                    <p class="text-muted mb-0">View or manage your saved tours for future booking reference.</p>
                </div>
                <c:if test="${not empty wishlistTours}">
                    <div>
                        <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">
                            ${wishlistTours.size()} Saved Tour<c:if test="${wishlistTours.size() != 1}">s</c:if>
                        </span>
                    </div>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${empty wishlistTours}">
                    <!-- Empty State View -->
                    <div class="row justify-content-center my-5">
                        <div class="col-md-7 text-center">
                            <div class="empty-wishlist-card">
                                <div class="mb-4">
                                    <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-light text-primary" style="width: 100px; height: 100px; font-size: 3rem; background: rgba(79, 70, 229, 0.05) !important;">
                                        <i class="fa-regular fa-heart"></i>
                                    </span>
                                </div>
                                <h3 class="fw-bold mb-3">Your Wishlist is Empty</h3>
                                <p class="text-muted mb-4 max-width-500 mx-auto">
                                    Browse our selection of unique discovery tours, historic itineraries, and corporate experiences to save your favorites here.
                                </p>
                                <a href="${pageContext.request.contextPath}/tours" class="btn btn-primary btn-lg rounded-pill px-5 shadow-sm">
                                    <i class="fa-solid fa-magnifying-glass me-2"></i>Explore Tours
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <!-- Wishlist Active View -->
                    <!-- Toolbar for Batch Deletion -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="select-actions-bar p-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input class="form-check-input me-2" type="checkbox" id="selectAll" style="width: 20px; height: 20px; cursor: pointer;">
                                    <label class="form-check-label fw-semibold" for="selectAll" style="cursor: pointer; user-select: none;">
                                        Select All
                                    </label>
                                </div>
                                <div id="selectActionsBar" class="align-items-center gap-3 d-none">
                                    <span class="text-muted fw-semibold">
                                        Selected: <span id="selectedCount" class="text-primary fw-bold">0</span>
                                    </span>
                                    <button type="button" class="btn btn-danger btn-sm rounded-pill px-3 py-2" onclick="deleteSelected()">
                                        <i class="fa-solid fa-trash-can me-1"></i> Remove Selected
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Wishlist Items Form Grid -->
                    <form id="wishlistForm" method="POST" action="${pageContext.request.contextPath}/wishlist">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/wishlist">
                        
                        <div class="row">
                            <c:forEach var="t" items="${wishlistTours}">
                                <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                                    <div class="tour-card wishlist-card">
                                        
                                        <!-- Custom Checkbox Selector -->
                                        <div class="wishlist-checkbox-wrapper">
                                            <input type="checkbox" name="tourId" value="${t.tourId}" class="wishlist-checkbox" title="Select for removal">
                                        </div>

                                        <!-- Quick delete single item -->
                                        <button type="button" class="wishlist-remove-btn" onclick="deleteSingle(${t.tourId})" title="Remove from Wishlist">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>

                                        <!-- Tour Image & Duration -->
                                        <div class="tour-img-wrapper">
                                            <span class="tour-category-tag">
                                                <i class="fa-solid fa-tag me-1"></i>${t.category.categoryName}
                                            </span>
                                            <img src="${not empty t.thumbnailUrl ? pageContext.request.contextPath.concat(t.thumbnailUrl) : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop'}"
                                                 alt="${t.tourName}"
                                                 class="tour-img"
                                                 onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=800&auto=format&fit=crop'">

                                            <span class="tour-duration-tag">
                                                <i class="fa-regular fa-clock me-1"></i>
                                                <c:choose>
                                                    <c:when test="${t.durationDays > 1}">
                                                        ${t.durationDays} Days ${t.durationDays - 1} Nights
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${t.durationDays} Day
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <!-- Tour Card Details -->
                                        <div class="tour-card-body">
                                            <div class="tour-location">
                                                <i class="fa-solid fa-location-dot"></i>
                                                Departure: ${t.departureLocation}
                                            </div>
                                            <h3 class="tour-title" title="${t.tourName}">${t.tourName}</h3>
                                            <div class="tour-destination" style="font-size: 0.9rem; color: #6c757d; margin-bottom: 8px;">
                                                <i class="fa-solid fa-map-pin"></i>
                                                <c:if test="${not empty t.destination.destinationName}">
                                                    ${t.destination.destinationName}
                                                </c:if>
                                            </div>
                                            <p class="tour-desc">${t.description}</p>
                                            <div class="tour-card-footer">
                                                <div class="tour-price-wrapper">
                                                    <span class="tour-price-label">From</span>
                                                    <span class="tour-price">
                                                        <fmt:formatNumber value="${t.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                    </span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/tour-detail?id=${t.tourId}" class="btn tour-btn">
                                                    Details <i class="fa-solid fa-arrow-right ms-1"></i>
                                                </a>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
            
        </div>
    </main>

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
        // Single removal logic
        function deleteSingle(tourId) {
            if (confirm('Are you sure you want to remove this tour from your wishlist?')) {
                const form = document.getElementById('wishlistForm');
                // Uncheck all other checkboxes to submit only the target tourId
                document.querySelectorAll('.wishlist-checkbox').forEach(cb => cb.checked = false);
                const targetCheckbox = document.querySelector(`.wishlist-checkbox[value="${tourId}"]`);
                if (targetCheckbox) {
                    targetCheckbox.checked = true;
                }
                form.submit();
            }
        }

        // Multi-select batch deletion logic
        function deleteSelected() {
            const checkedBoxes = document.querySelectorAll('.wishlist-checkbox:checked');
            if (checkedBoxes.length === 0) {
                alert('Please select at least one tour to remove.');
                return;
            }
            if (confirm('Are you sure you want to remove ' + checkedBoxes.length + ' selected tour(s) from your wishlist?')) {
                document.getElementById('wishlistForm').submit();
            }
        }

        // Action bar management
        document.addEventListener('DOMContentLoaded', function() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.wishlist-checkbox');
            const selectedCountSpan = document.getElementById('selectedCount');
            const selectActionsBar = document.getElementById('selectActionsBar');

            function updateActionsBar() {
                const checkedCount = document.querySelectorAll('.wishlist-checkbox:checked').length;
                if (checkedCount > 0) {
                    selectedCountSpan.textContent = checkedCount;
                    selectActionsBar.classList.remove('d-none');
                    selectActionsBar.classList.add('d-flex');
                } else {
                    selectActionsBar.classList.remove('d-flex');
                    selectActionsBar.classList.add('d-none');
                }
                
                // Update Select All checkbox state
                if (selectAllCheckbox) {
                    if (checkedCount === checkboxes.length && checkboxes.length > 0) {
                        selectAllCheckbox.checked = true;
                        selectAllCheckbox.indeterminate = false;
                    } else if (checkedCount === 0) {
                        selectAllCheckbox.checked = false;
                        selectAllCheckbox.indeterminate = false;
                    } else {
                        selectAllCheckbox.checked = false;
                        selectAllCheckbox.indeterminate = true;
                    }
                }
            }

            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function() {
                    checkboxes.forEach(cb => cb.checked = selectAllCheckbox.checked);
                    updateActionsBar();
                });
            }

            checkboxes.forEach(cb => {
                cb.addEventListener('change', updateActionsBar);
            });
            
            // Set initial state
            updateActionsBar();
        });
    </script>
</body>
</html>
