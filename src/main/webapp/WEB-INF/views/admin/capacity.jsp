<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Capacity" />
    <jsp:param name="activeMenu" value="capacity" />
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
                                <th style="width: 320px;" class="text-center">Actions</th>
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
                                            <td class="fw-semibold"><fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${s.returnDate}" pattern="dd/MM/yyyy"/></td>
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
                                                <div class="d-flex justify-content-center gap-2">
                                                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                            onclick="viewDetails(${s.scheduleId})">
                                                        <i class="fa-solid fa-eye me-1"></i>Detail
                                                    </button>
                                                    <button class="btn btn-outline-success btn-sm rounded-pill px-3" 
                                                            ${(!'Open'.equalsIgnoreCase(s.status) || s.availableSlots <= 0) ? 'disabled' : ''}
                                                            onclick="openReserveModal(${s.scheduleId}, '${selectedTour.tourName.replace("'", "\\'")}', ${s.availableSlots})">
                                                        <i class="fa-solid fa-ticket me-1"></i>Reserve
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${'Cancelled'.equalsIgnoreCase(s.status) || 'Completed'.equalsIgnoreCase(s.status)}">
                                                            <button class="btn btn-outline-secondary btn-sm rounded-pill px-3" disabled title="Cannot release slots for Cancelled/Completed schedules">
                                                                <i class="fa-solid fa-plus me-1"></i>Release
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                                    onclick="openReleaseModal(${s.scheduleId}, '<fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy"/>', ${s.totalSlots}, ${s.availableSlots})">
                                                                <i class="fa-solid fa-plus me-1"></i>Release
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
        </c:if>
    </div>

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
                <form method="POST" action="${pageContext.request.contextPath}/admin/capacity">
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