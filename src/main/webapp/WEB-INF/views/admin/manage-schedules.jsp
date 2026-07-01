<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Schedules" />
    <jsp:param name="activeMenu" value="schedules" />
</jsp:include>

<!-- Main Content -->
<div class="container-fluid p-0">

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
    </div>

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


    <jsp:include page="layout/footer.jsp" />