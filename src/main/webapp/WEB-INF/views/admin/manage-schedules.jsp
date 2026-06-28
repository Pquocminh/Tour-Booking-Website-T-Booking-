<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tour Schedules | Staff Dashboard</title>
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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="max-height: 380px; overflow-y: auto; border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-white"></i>Manage Schedules</a></li>
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

    <!-- Dashboard Header Banner -->
    <header class="hero-section">
        <div class="container">
            <h1 class="hero-title">Tour Schedule <span>Management</span></h1>
            <p class="hero-subtitle">View, update details, or cancel tour schedules in the system</p>
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

        <!-- Tour Filter Panel -->
        <section class="filter-panel">
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-route me-2 text-primary"></i>Filter Schedules by Tour</h4>
            <form method="GET" action="${pageContext.request.contextPath}/admin/schedules">
                <div class="row g-3 align-items-end">
                    <div class="col-md-9">
                        <label class="form-label text-muted small fw-bold">Select Tour</label>
                        <select name="tourId" class="form-select rounded-3">
                            <option value="">-- All Tours --</option>
                            <c:forEach var="t" items="${tours}">
                                <option value="${t.tourId}" ${selectedTourId == t.tourId ? 'selected' : ''}>
                                    ID: #${t.tourId} - ${t.tourName} (${t.status})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 rounded-3 text-white py-2">
                            <i class="fa-solid fa-filter me-2"></i>Apply Filter
                        </button>
                    </div>
                </div>
            </form>
        </section>

        <!-- Schedules Table List -->
        <section class="table-panel">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
                <div>
                    <h4 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Schedules List</h4>
                </div>
                <span class="badge bg-primary rounded-pill py-2 px-3 align-self-start">${schedules.size()} Schedule(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">Sched ID</th>
                            <th>Tour Name</th>
                            <th>Departure Date</th>
                            <th>Return Date</th>
                            <th>Price</th>
                            <th class="text-center">Booked / Total Capacity</th>
                            <th>Status</th>
                            <th style="width: 220px;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty schedules}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-calendar display-4 mb-3 d-block text-secondary"></i>
                                        No schedules found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${schedules}">
                                    <fmt:formatDate value="${s.departureDate}" pattern="yyyy-MM-dd" var="depDateStr"/>
                                    <fmt:formatDate value="${s.returnDate}" pattern="yyyy-MM-dd" var="retDateStr"/>
                                    <c:set var="booked" value="${s.totalSlots - s.availableSlots}"/>
                                    <tr>
                                        <td><span class="text-muted small fw-bold">#${s.scheduleId}</span></td>
                                        <td class="fw-semibold text-dark text-truncate" style="max-width: 200px;" title="${s.tourName}">${s.tourName}</td>
                                        <td><fmt:formatDate value="${s.departureDate}" pattern="dd MMM yyyy"/></td>
                                        <td><fmt:formatDate value="${s.returnDate}" pattern="dd MMM yyyy"/></td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center fw-semibold">
                                            <span class="badge bg-light text-dark border me-1">${booked}</span> / <span class="fw-bold text-dark">${s.totalSlots}</span>
                                            <div class="text-muted small mt-1">(${s.availableSlots} slots left)</div>
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
                                            <div class="d-flex justify-content-center gap-2">
                                                <c:choose>
                                                    <c:when test="${'Cancelled'.equalsIgnoreCase(s.status) || 'Completed'.equalsIgnoreCase(s.status)}">
                                                        <button class="btn btn-outline-secondary btn-sm rounded-pill px-3" disabled title="Cannot edit Cancelled or Completed schedule">
                                                            <i class="fa-solid fa-edit me-1"></i>Edit
                                                        </button>
                                                        <button class="btn btn-outline-secondary btn-sm rounded-pill px-3" disabled title="Already Cancelled or Completed">
                                                            <i class="fa-solid fa-ban me-1"></i>Cancel
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                                onclick="openEditModal(${s.scheduleId}, '${s.tourName.replace("'", "\\'")}', '${depDateStr}', '${retDateStr}', ${s.price}, ${s.totalSlots}, ${booked}, '${s.status}')">
                                                            <i class="fa-solid fa-edit me-1"></i>Edit
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-sm rounded-pill px-3" 
                                                                onclick="confirmCancel(${s.scheduleId})">
                                                            <i class="fa-solid fa-ban me-1"></i>Cancel
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <!-- Hidden Form for Cancellation -->
    <form id="cancelForm" method="POST" action="${pageContext.request.contextPath}/admin/schedules">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" id="cancelScheduleId" name="scheduleId">
        <input type="hidden" name="tourId" value="${selectedTourId}">
    </form>

    <!-- Update Schedule Modal -->
    <div class="modal fade" id="updateScheduleModal" tabindex="-1" aria-labelledby="updateScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="updateScheduleModalLabel"><i class="fa-solid fa-calendar-check text-primary me-2"></i>Update Tour Schedule</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/schedules">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editScheduleId" name="scheduleId">
                    <input type="hidden" name="tourId" value="${selectedTourId}">
                    
                    <div class="modal-body py-4">
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Tour Package</label>
                            <input type="text" class="form-control rounded-3 bg-light" id="editTourName" readonly disabled>
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="editDepartureDate" class="form-label text-muted small fw-bold">Departure Date</label>
                                <input type="date" class="form-control rounded-3" id="editDepartureDate" name="departureDate" required onchange="validateDates()">
                            </div>
                            <div class="col-md-6">
                                <label for="editReturnDate" class="form-label text-muted small fw-bold">Return Date</label>
                                <input type="date" class="form-control rounded-3" id="editReturnDate" name="returnDate" required onchange="validateDates()">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="editPrice" class="form-label text-muted small fw-bold">Price (đ)</label>
                            <input type="number" class="form-control rounded-3" id="editPrice" name="price" min="0" step="1000" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="editTotalSlots" class="form-label text-muted small fw-bold">Total Capacity</label>
                                <input type="number" class="form-control rounded-3" id="editTotalSlots" name="totalSlots" min="1" required>
                                <div class="form-text text-primary small" id="editBookedSlotsInfo">Booked slots: 0</div>
                            </div>
                            <div class="col-md-6">
                                <label for="editStatus" class="form-label text-muted small fw-bold">Status</label>
                                <select name="status" id="editStatus" class="form-select rounded-3">
                                    <option value="Open">Open</option>
                                    <option value="Full">Full</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <div class="alert alert-danger d-none border-0 py-2 small rounded-3" id="modalErrorAlert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>Departure date cannot be after return date.
                        </div>
                    </div>
                    
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 rounded-pill text-white" id="submitUpdateBtn">Save Changes</button>
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
        function openEditModal(scheduleId, tourName, departureDate, returnDate, price, totalSlots, bookedSlots, status) {
            document.getElementById('editScheduleId').value = scheduleId;
            document.getElementById('editTourName').value = tourName;
            document.getElementById('editDepartureDate').value = departureDate;
            document.getElementById('editReturnDate').value = returnDate;
            document.getElementById('editPrice').value = price;
            
            // Set min constraint on Total Slots to prevent dropping below booked slots
            var totalSlotsInput = document.getElementById('editTotalSlots');
            totalSlotsInput.value = totalSlots;
            totalSlotsInput.min = bookedSlots;
            document.getElementById('editBookedSlotsInfo').innerText = "Already booked: " + bookedSlots;

            // Pre-select status
            document.getElementById('editStatus').value = status;
            
            // Hide error alert initially
            document.getElementById('modalErrorAlert').classList.add('d-none');
            document.getElementById('submitUpdateBtn').disabled = false;
            
            var myModal = new bootstrap.Modal(document.getElementById('updateScheduleModal'));
            myModal.show();
        }

        function confirmCancel(scheduleId) {
            if (confirm("Are you sure you want to cancel Tour Schedule #" + scheduleId + "? This action cannot be undone.")) {
                document.getElementById('cancelScheduleId').value = scheduleId;
                document.getElementById('cancelForm').submit();
            }
        }

        function validateDates() {
            var depDateVal = document.getElementById('editDepartureDate').value;
            var retDateVal = document.getElementById('editReturnDate').value;
            var errorAlert = document.getElementById('modalErrorAlert');
            var submitBtn = document.getElementById('submitUpdateBtn');

            if (depDateVal && retDateVal) {
                var depDate = new Date(depDateVal);
                var retDate = new Date(retDateVal);
                
                if (depDate > retDate) {
                    errorAlert.classList.remove('d-none');
                    submitBtn.disabled = true;
                } else {
                    errorAlert.classList.add('d-none');
                    submitBtn.disabled = false;
                }
            }
        }
    </script>
</body>
</html>
