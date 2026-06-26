<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Capacity | Admin Dashboard</title>
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
        .filter-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .table-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            margin-bottom: 50px;
        }
        .table-custom th {
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
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
            <h1 class="hero-title">Tour Capacity <span>Management</span></h1>
            <p class="hero-subtitle">View schedules, monitor capacity allocation, and release additional slots</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">

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

        <!-- Tour Selection Panel -->
        <section class="filter-panel">
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-route me-2 text-primary"></i>Select Tour Package</h4>
            <form method="GET" action="${pageContext.request.contextPath}/admin/capacity">
                <div class="row g-3 align-items-end">
                    <div class="col-md-9">
                        <label class="form-label text-muted small fw-bold">Select Tour</label>
                        <select name="tourId" class="form-select rounded-3" required>
                            <option value="">-- Choose a tour --</option>
                            <c:forEach var="t" items="${tours}">
                                <option value="${t.tourId}" ${selectedTourId == t.tourId ? 'selected' : ''}>
                                    ID: #${t.tourId} - ${t.tourName} (${t.status})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 rounded-3 text-white py-2">
                            <i class="fa-solid fa-calendar-check me-2"></i>View Schedule
                        </button>
                    </div>
                </div>
            </form>
        </section>

        <!-- Schedules Table List -->
        <c:if var="hasSelectedTour" test="${not empty selectedTour}">
            <section class="table-panel">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
                    <div>
                        <span class="text-muted small d-block">MANAGING CAPACITY FOR</span>
                        <h4 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>${selectedTour.tourName}</h4>
                    </div>
                    <span class="badge bg-primary rounded-pill py-2 px-3 align-self-start">${schedules.size()} Schedule(s)</span>
                </div>

                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Sched ID</th>
                                <th>Departure Date</th>
                                <th>Return Date</th>
                                <th>Price</th>
                                <th class="text-center">Total Capacity</th>
                                <th class="text-center">Booked</th>
                                <th class="text-center">Available</th>
                                <th>Status</th>
                                <th style="width: 150px;" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty schedules}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="fa-regular fa-calendar display-4 mb-3 d-block text-secondary"></i>
                                            No schedules found for this tour.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="s" items="${schedules}">
                                        <tr>
                                            <td><span class="text-muted small fw-bold">#${s.scheduleId}</span></td>
                                            <td class="fw-semibold"><fmt:formatDate value="${s.departureDate}" pattern="dd MMM yyyy"/></td>
                                            <td><fmt:formatDate value="${s.returnDate}" pattern="dd MMM yyyy"/></td>
                                            <td class="fw-bold text-primary">
                                                <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </td>
                                            <td class="text-center fw-bold text-dark">${s.totalSlots}</td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">${s.totalSlots - s.availableSlots}</span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${s.availableSlots <= 3 && s.availableSlots > 0}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">${s.availableSlots} left</span>
                                                    </c:when>
                                                    <c:when test="${s.availableSlots == 0}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">0 left</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">${s.availableSlots} left</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${'Open'.equalsIgnoreCase(s.status)}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Open</span>
                                                    </c:when>
                                                    <c:when test="${'Full'.equalsIgnoreCase(s.status)}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-ban me-1"></i>Full</span>
                                                    </c:when>
                                                    <c:when test="${'Cancelled'.equalsIgnoreCase(s.status)}">
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-xmark me-1"></i>Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info-subtle text-info border border-info px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-info me-1"></i>${s.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${'Cancelled'.equalsIgnoreCase(s.status) || 'Completed'.equalsIgnoreCase(s.status)}">
                                                        <button class="btn btn-outline-secondary btn-sm rounded-pill px-3" disabled title="Cannot release slots for Cancelled/Completed schedules">
                                                            <i class="fa-solid fa-plus me-1"></i>Release Slots
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                                onclick="openReleaseModal(${s.scheduleId}, '<fmt:formatDate value="${s.departureDate}" pattern="dd MMM yyyy"/>', ${s.totalSlots}, ${s.availableSlots})">
                                                            <i class="fa-solid fa-plus me-1"></i>Release Slots
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </c:if>
    </main>

    <!-- Release Slots Modal -->
    <div class="modal fade" id="releaseSlotsModal" tabindex="-1" aria-labelledby="releaseSlotsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="releaseSlotsModalLabel"><i class="fa-solid fa-circle-plus text-primary me-2"></i>Release Additional Slots</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/capacity">
                    <input type="hidden" name="action" value="release">
                    <input type="hidden" id="modalScheduleId" name="scheduleId">
                    <input type="hidden" name="tourId" value="${selectedTourId}">
                    
                    <div class="modal-body py-4">
                        <div class="mb-3 bg-light p-3 rounded-3">
                            <div class="row g-2">
                                <div class="col-6">
                                    <span class="text-muted small d-block">DEPARTURE DATE</span>
                                    <span class="fw-bold text-dark" id="modalDepartureDate">--</span>
                                </div>
                                <div class="col-6">
                                    <span class="text-muted small d-block">CURRENT CAPACITY (Avail/Total)</span>
                                    <span class="fw-bold text-dark" id="modalCurrentCapacity">--</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="slotsToRelease" class="form-label text-muted small fw-bold">Number of slots to add/release</label>
                            <input type="number" class="form-control rounded-3" id="slotsToRelease" name="slotsToRelease" min="1" required placeholder="e.g. 5">
                            <div class="form-text">This will increase both the Total Capacity and Available Slots by the entered amount.</div>
                        </div>
                    </div>
                    
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 rounded-pill text-white">Release Slots</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 50px;">
        &copy; 2026 T-Booking Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function openReleaseModal(scheduleId, departureDate, currentTotal, currentAvailable) {
            document.getElementById('modalScheduleId').value = scheduleId;
            document.getElementById('modalDepartureDate').innerText = departureDate;
            document.getElementById('modalCurrentCapacity').innerText = currentAvailable + ' / ' + currentTotal;
            document.getElementById('slotsToRelease').value = '';
            
            var myModal = new bootstrap.Modal(document.getElementById('releaseSlotsModal'));
            myModal.show();
        }
    </script>
</body>
</html>
