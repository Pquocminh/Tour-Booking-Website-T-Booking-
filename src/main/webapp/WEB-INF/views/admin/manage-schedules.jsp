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
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
            background: #f8fafc;
            padding: 20px;
            border-radius: 15px;
            border: 1px solid #e2e8f0;
        }
        .details-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 0.25rem;
        }
        .details-value {
            font-size: 1rem;
            font-weight: 600;
            color: #0f172a;
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
                            <th style="width: 320px;" class="text-center">Actions</th>
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
                                                <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                        onclick="viewDetails(${s.scheduleId})">
                                                    <i class="fa-solid fa-eye me-1"></i>Detail
                                                </button>
                                                <button class="btn btn-outline-success btn-sm rounded-pill px-3" 
                                                        ${(!'Open'.equalsIgnoreCase(s.status) || s.availableSlots <= 0) ? 'disabled' : ''}
                                                        onclick="openReserveModal(${s.scheduleId}, '${s.tourName.replace("'", "\\'")}', ${s.availableSlots})">
                                                    <i class="fa-solid fa-ticket me-1"></i>Reserve
                                                </button>
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

    <!-- Reserve Slots Modal -->
    <div class="modal fade" id="reserveSlotsModal" tabindex="-1" aria-labelledby="reserveSlotsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="reserveSlotsModalLabel"><i class="fa-solid fa-ticket text-success me-2"></i>Reserve Tour Slots</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/schedules">
                    <input type="hidden" name="action" value="reserve">
                    <input type="hidden" id="reserveScheduleId" name="scheduleId">
                    <input type="hidden" name="tourId" value="${selectedTourId}">
                    
                    <div class="modal-body py-4">
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Tour Package</label>
                            <input type="text" class="form-control rounded-3 bg-light" id="reserveTourName" readonly disabled>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Available Slots</label>
                            <input type="text" class="form-control rounded-3 bg-light" id="reserveAvailableSlotsInfo" readonly disabled>
                        </div>

                        <div class="mb-3">
                            <label for="customerIdentifier" class="form-label text-muted small fw-bold">Customer Username or Email</label>
                            <input type="text" class="form-control rounded-3" id="customerIdentifier" name="customerIdentifier" placeholder="e.g. minhpq" required>
                            <div class="form-text text-muted small">Enter the username or email of a registered customer.</div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="reserveContactName" class="form-label text-muted small fw-bold">Contact Name</label>
                                <input type="text" class="form-control rounded-3" id="reserveContactName" name="contactName" placeholder="e.g. Pham Quoc Minh" required>
                            </div>
                            <div class="col-md-6">
                                <label for="reserveContactPhone" class="form-label text-muted small fw-bold">Contact Phone</label>
                                <input type="text" class="form-control rounded-3" id="reserveContactPhone" name="contactPhone" placeholder="e.g. 0923456789" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="reserveNumSlots" class="form-label text-muted small fw-bold">Number of slots to reserve</label>
                            <input type="number" class="form-control rounded-3" id="reserveNumSlots" name="numberOfPeople" min="1" required placeholder="e.g. 2" oninput="validateReserveSlots()">
                            <div class="alert alert-danger d-none border-0 py-2 small rounded-3 mt-2" id="reserveModalErrorAlert">
                                <i class="fa-solid fa-circle-exclamation me-1"></i>Cannot reserve more than the available slots.
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success px-4 rounded-pill text-white" id="submitReserveBtn">Reserve Slots</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View Details Modal -->
    <div class="modal fade" id="detailScheduleModal" tabindex="-1" aria-labelledby="detailScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="detailScheduleModalLabel"><i class="fa-solid fa-circle-info text-primary me-2"></i>Tour Schedule Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body py-4">
                    <!-- Loading Spinner -->
                    <div id="detailsLoading" class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="text-muted mt-2">Loading schedule details...</p>
                    </div>

                    <!-- Details Content (Initially Hidden) -->
                    <div id="detailsContent" class="d-none">
                        <!-- Tour and Schedule Grid -->
                        <div class="details-grid">
                            <div>
                                <div class="details-label">Tour Package</div>
                                <div class="details-value" id="detailTourName">Can Tho - Ha Tien Motorbike Trip</div>
                            </div>
                            <div>
                                <div class="details-label">Departure From</div>
                                <div class="details-value" id="detailDepartureLocation">Can Tho</div>
                            </div>
                            <div>
                                <div class="details-label">Duration</div>
                                <div class="details-value" id="detailDuration">2 Days</div>
                            </div>
                            <div>
                                <div class="details-label">Price</div>
                                <div class="details-value text-primary" id="detailPrice">đ1,200,000</div>
                            </div>
                            <div>
                                <div class="details-label">Departure Date</div>
                                <div class="details-value" id="detailDepDate">15 Jun 2026</div>
                            </div>
                            <div>
                                <div class="details-label">Return Date</div>
                                <div class="details-value" id="detailRetDate">16 Jun 2026</div>
                            </div>
                            <div>
                                <div class="details-label">Status</div>
                                <div class="details-value" id="detailStatus"><span class="badge bg-success">Open</span></div>
                            </div>
                        </div>

                        <!-- Capacity & Availability Progress -->
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-users me-2 text-primary"></i>Availability & Capacity</h6>
                        <div class="mb-4">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="small text-muted fw-semibold">Booked: <span id="detailBookedSlots">2</span> / <span id="detailTotalSlots">20</span> slots</span>
                                <span class="small text-primary fw-bold" id="detailAvailableSlots">18 slots left</span>
                            </div>
                            <div class="progress" style="height: 12px; border-radius: 6px;">
                                <div id="detailProgressBar" class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 10%;" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>

                        <!-- Participant Bookings Table -->
                        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-receipt me-2 text-primary"></i>Participant Bookings</h6>
                        <div class="table-responsive border rounded-3" style="max-height: 250px; overflow-y: auto;">
                            <table class="table table-hover align-middle mb-0" style="font-size: 0.85rem;">
                                <thead class="table-light sticky-top">
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Contact Name</th>
                                        <th>Contact Phone</th>
                                        <th class="text-center">Pax</th>
                                        <th class="text-end">Total Paid</th>
                                        <th>Status</th>
                                        <th>Booking Date</th>
                                    </tr>
                                </thead>
                                <tbody id="participantsTableBody">
                                    <!-- Dynamic rows will be inserted here -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Close</button>
                </div>
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

        function openReserveModal(scheduleId, tourName, availableSlots) {
            document.getElementById('reserveScheduleId').value = scheduleId;
            document.getElementById('reserveTourName').value = tourName;
            document.getElementById('reserveAvailableSlotsInfo').value = availableSlots + " slots left";
            
            var numSlotsInput = document.getElementById('reserveNumSlots');
            numSlotsInput.value = '1';
            numSlotsInput.max = availableSlots;
            
            document.getElementById('customerIdentifier').value = '';
            document.getElementById('reserveContactName').value = '';
            document.getElementById('reserveContactPhone').value = '';
            
            document.getElementById('reserveModalErrorAlert').classList.add('d-none');
            document.getElementById('submitReserveBtn').disabled = false;
            
            var myModal = new bootstrap.Modal(document.getElementById('reserveSlotsModal'));
            myModal.show();
        }

        function validateReserveSlots() {
            var numSlotsInput = document.getElementById('reserveNumSlots');
            var val = parseInt(numSlotsInput.value);
            var maxVal = parseInt(numSlotsInput.max);
            var errorAlert = document.getElementById('reserveModalErrorAlert');
            var submitBtn = document.getElementById('submitReserveBtn');
            
            if (val > maxVal || val <= 0 || isNaN(val)) {
                errorAlert.classList.remove('d-none');
                submitBtn.disabled = true;
            } else {
                errorAlert.classList.add('d-none');
                submitBtn.disabled = false;
            }
        }

        function viewDetails(scheduleId) {
            // Reset modal view to loading
            document.getElementById('detailsLoading').classList.remove('d-none');
            document.getElementById('detailsContent').classList.add('d-none');
            
            // Show modal
            var detailModal = new bootstrap.Modal(document.getElementById('detailScheduleModal'));
            detailModal.show();

            // Fetch details via AJAX
            fetch('${pageContext.request.contextPath}/admin/schedules?action=getDetails&scheduleId=' + scheduleId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.error) {
                        alert(data.error);
                        detailModal.hide();
                        return;
                    }

                    // Populate Tour & Schedule details
                    var sched = data.schedule;
                    var tour = data.tour;
                    var bookings = data.bookings;

                    document.getElementById('detailTourName').innerText = tour.tourName || sched.tourName;
                    document.getElementById('detailDepartureLocation').innerText = tour.departureLocation || 'N/A';
                    document.getElementById('detailDuration').innerText = tour.durationDays + ' Days';
                    document.getElementById('detailPrice').innerText = 'đ' + Number(sched.price).toLocaleString('vi-VN');
                    
                    // Format dates
                    var depDate = new Date(sched.departureDate);
                    var retDate = new Date(sched.returnDate);
                    var options = { day: '2-digit', month: 'short', year: 'numeric' };
                    document.getElementById('detailDepDate').innerText = depDate.toLocaleDateString('en-US', options);
                    document.getElementById('detailRetDate').innerText = retDate.toLocaleDateString('en-US', options);
                    
                    // Status Badge
                    var statusBadge = '';
                    if (sched.status === 'Open') {
                        statusBadge = '<span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Open</span>';
                    } else if (sched.status === 'Full') {
                        statusBadge = '<span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Full</span>';
                    } else {
                        statusBadge = '<span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-1 rounded-pill">' + sched.status + '</span>';
                    }
                    document.getElementById('detailStatus').innerHTML = statusBadge;

                    // Capacity Progress
                    var booked = sched.totalSlots - sched.availableSlots;
                    document.getElementById('detailBookedSlots').innerText = booked;
                    document.getElementById('detailTotalSlots').innerText = sched.totalSlots;
                    document.getElementById('detailAvailableSlots').innerText = sched.availableSlots + ' slots left';
                    
                    var percent = Math.round((booked / sched.totalSlots) * 100);
                    var progressBar = document.getElementById('detailProgressBar');
                    progressBar.style.width = percent + '%';
                    progressBar.setAttribute('aria-valuenow', percent);
                    
                    // Set color of progress bar
                    if (percent >= 90) {
                        progressBar.className = 'progress-bar bg-danger progress-bar-striped progress-bar-animated';
                    } else if (percent >= 50) {
                        progressBar.className = 'progress-bar bg-warning progress-bar-striped progress-bar-animated';
                    } else {
                        progressBar.className = 'progress-bar bg-success progress-bar-striped progress-bar-animated';
                    }

                    // Populate Bookings Table
                    var tableBody = document.getElementById('participantsTableBody');
                    tableBody.innerHTML = '';

                    if (!bookings || bookings.length === 0) {
                        tableBody.innerHTML = '<tr><td colspan="7" class="text-center py-4 text-muted"><i class="fa-solid fa-users-slash me-1"></i>No bookings yet.</td></tr>';
                    } else {
                        bookings.forEach(b => {
                            var bDate = new Date(b.bookingDate);
                            var bDateStr = bDate.toLocaleDateString('en-US', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
                            
                            var bStatusBadge = '';
                            if (b.status === 'Confirmed') {
                                bStatusBadge = '<span class="badge bg-success-subtle text-success border border-success px-2 py-1 rounded-pill">Confirmed</span>';
                            } else if (b.status === 'Pending') {
                                bStatusBadge = '<span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1 rounded-pill">Pending</span>';
                            } else {
                                bStatusBadge = '<span class="badge bg-secondary-subtle text-secondary border border-secondary px-2 py-1 rounded-pill">' + b.status + '</span>';
                            }

                            var row = '<tr>' +
                                '<td><span class="text-muted fw-bold">#' + b.bookingId + '</span></td>' +
                                '<td class="fw-semibold">' + b.contactName + '</td>' +
                                '<td>' + b.contactPhone + '</td>' +
                                '<td class="text-center fw-bold">' + b.numberOfPeople + '</td>' +
                                '<td class="text-end fw-bold text-primary">đ' + Number(b.totalPrice).toLocaleString('vi-VN') + '</td>' +
                                '<td>' + bStatusBadge + '</td>' +
                                '<td>' + bDateStr + '</td>' +
                                '</tr>';
                            tableBody.innerHTML += row;
                        });
                    }

                    // Hide loading and show content
                    document.getElementById('detailsLoading').classList.add('d-none');
                    document.getElementById('detailsContent').classList.remove('d-none');
                })
                .catch(err => {
                    console.error(err);
                    alert('An error occurred while loading details. Please try again.');
                    detailModal.hide();
                });
        }
    </script>

</body>
</html>
