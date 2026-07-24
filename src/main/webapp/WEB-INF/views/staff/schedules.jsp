<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../admin/layout/header.jsp">
    <jsp:param name="pageTitle" value="Staff Schedule Management" />
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
            <form method="GET" action="${pageContext.request.contextPath}/admin/staff/schedules">
                <div class="row g-3 align-items-end">
                    <div class="col-md-9">
                        <label class="form-label text-muted small fw-bold">Select Tour</label>
                        <select name="tourId" class="form-select rounded-3">
                            <option value="">-- All Tours --</option>
                            <c:forEach var="t" items="${tours}">
                                <c:if test="${t.status == 'Active'}">
                                    <option value="${t.tourId}" ${selectedTourId == t.tourId ? 'selected' : ''}>
                                        ID: #${t.tourId} - ${t.tourName}
                                    </option>
                                </c:if>
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
                <div class="d-flex gap-2 align-self-start">
                    <button class="btn btn-success text-white rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#createScheduleModal">
                        <i class="fa-solid fa-plus me-2"></i>Create New Schedule
                    </button>
                    <span class="badge bg-primary rounded-pill py-2 px-3 align-self-center">${schedules.size()} Schedule(s)</span>
                </div>
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
                            <th>Assigned Staff</th>
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
                                        <td><fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${s.returnDate}" pattern="dd/MM/yyyy"/></td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${s.price}" pattern="#,##0 ₫"/>
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
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty s.assignedStaffId}">
                                                    <c:set var="staffName" value="Unknown"/>
                                                    <c:forEach var="staff" items="${staffList}">
                                                        <c:if test="${staff.accountId == s.assignedStaffId}">
                                                            <c:set var="staffName" value="${staff.fullName}"/>
                                                        </c:if>
                                                    </c:forEach>
                                                    <span class="badge bg-info-subtle text-info border border-info px-2 py-1 rounded-pill">
                                                        <i class="fa-solid fa-user me-1"></i>${staffName}
                                                        <c:if test="${sessionScope.account.accountId == s.assignedStaffId}"> (You)</c:if>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small"><em>Unassigned</em></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <button class="btn btn-outline-success btn-sm rounded-pill px-3" 
                                                        ${(!'Open'.equalsIgnoreCase(s.status) || s.availableSlots <= 0) ? 'disabled' : ''}
                                                        onclick="openReserveModal(${s.scheduleId}, '${s.tourName.replace("'", "\\'")}', ${s.availableSlots})">
                                                    <i class="fa-solid fa-ticket me-1"></i>Reserve
                                                </button>
                                                <c:if test="${empty s.assignedStaffId}">
                                                    <form action="${pageContext.request.contextPath}/admin/staff/schedules" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="takeTour">
                                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                                                        <input type="hidden" name="tourId" value="${param.tourId}">
                                                        <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-3" onclick="return confirm('Are you sure you want to take this tour?');">
                                                            <i class="fa-solid fa-hand-paper me-1"></i>Take Tour
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                                        onclick="viewDetails(${s.scheduleId})">
                                                    <i class="fa-solid fa-eye me-1"></i>Detail
                                                </button>
                                                <button class="btn btn-outline-danger btn-sm rounded-pill px-3" 
                                                        onclick="confirmDelete(${s.scheduleId}, ${booked})">
                                                    <i class="fa-solid fa-trash me-1"></i>Delete
                                                </button>
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

    <!-- Hidden Form for Deletion -->
    <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/admin/staff/schedules">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" id="deleteScheduleId" name="scheduleId">
        <input type="hidden" name="tourId" value="${selectedTourId}">
    </form>

    <!-- Create Schedule Modal -->
    <div class="modal fade" id="createScheduleModal" tabindex="-1" aria-labelledby="createScheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="createScheduleModalLabel"><i class="fa-solid fa-calendar-plus text-success me-2"></i>Create Tour Schedule</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/staff/schedules">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="tourId" value="${selectedTourId}">
                    
                    <div class="modal-body py-4">
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Select Tour Package</label>
                            <select name="formTourId" class="form-select rounded-3" required onchange="onTourSelectChangeCreate()">
                                <option value="">-- Choose Tour --</option>
                                <c:forEach var="t" items="${tours}">
                                    <c:if test="${t.status == 'Active'}">
                                        <option value="${t.tourId}">ID: #${t.tourId} - ${t.tourName} (${t.durationDays} days)</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="createDepartureDate" class="form-label text-muted small fw-bold">Departure Date</label>
                                <input type="date" class="form-control rounded-3" id="createDepartureDate" name="departureDate" min="2020-01-01" max="2099-12-31" required onchange="onDepartureDateChangeCreate()">
                            </div>
                            <div class="col-md-6">
                                <label for="createReturnDate" class="form-label text-muted small fw-bold">Return Date</label>
                                <input type="date" class="form-control rounded-3" id="createReturnDate" name="returnDate" min="2020-01-01" max="2099-12-31" required onchange="validateCreateDates()">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="createPrice" class="form-label text-muted small fw-bold">Price (d)</label>
                            <input type="number" class="form-control rounded-3" id="createPrice" name="price" min="0" step="1000" placeholder="e.g. 1500000" required>
                        </div>

                        <div class="mb-3">
                            <label for="createTotalSlots" class="form-label text-muted small fw-bold">Total Capacity (Passengers)</label>
                            <input type="number" class="form-control rounded-3" id="createTotalSlots" name="totalSlots" min="44" value="44" step="44" placeholder="44 (1 Bus)" required>
                            <div class="form-text text-muted small">Default 1 big bus (44 passenger seats)</div>
                        </div>

                        <div class="alert alert-danger d-none border-0 py-2 small rounded-3" id="createModalErrorAlert">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>Departure date cannot be after return date.
                        </div>
                    </div>
                    
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success px-4 rounded-pill text-white" id="submitCreateBtn">Create Schedule</button>
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
                                <div class="details-value text-primary" id="detailPrice">1,200,000d</div>
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

    <!-- Reserve Slots Modal -->
    <div class="modal fade" id="reserveSlotsModal" tabindex="-1" aria-labelledby="reserveSlotsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="reserveSlotsModalLabel"><i class="fa-solid fa-ticket text-success me-2"></i>Reserve Tour Slots</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/admin/staff/schedules">
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


    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 50px;">
        &copy; 2026 T-Booking Staff Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function validateCreateDates() {
            var depDateVal = document.getElementById('createDepartureDate').value;
            var retDateVal = document.getElementById('createReturnDate').value;
            var errorAlert = document.getElementById('createModalErrorAlert');
            var submitBtn = document.getElementById('submitCreateBtn');

            if (depDateVal && retDateVal) {
                var depDate = new Date(depDateVal);
                var retDate = new Date(retDateVal);
                var depYear = depDate.getFullYear();
                var retYear = retDate.getFullYear();
                
                if (depYear < 2020 || depYear > 2099 || retYear < 2020 || retYear > 2099) {
                    errorAlert.innerHTML = '<i class="fa-solid fa-circle-exclamation me-1"></i>Year must be a valid 4-digit year (2020 - 2099).';
                    errorAlert.classList.remove('d-none');
                    submitBtn.disabled = true;
                } else if (depDate > retDate) {
                    errorAlert.innerHTML = '<i class="fa-solid fa-circle-exclamation me-1"></i>Departure date cannot be after return date.';
                    errorAlert.classList.remove('d-none');
                    submitBtn.disabled = true;
                } else {
                    errorAlert.classList.add('d-none');
                    submitBtn.disabled = false;
                }
            }
        }

        function confirmDelete(scheduleId, bookedSlots) {
            if (bookedSlots > 0) {
                alert("Cannot delete Tour Schedule #" + scheduleId + " because it contains " + bookedSlots + " booking(s). You must cancel the bookings first to protect data integrity.");
                return;
            }
            if (confirm("Are you sure you want to permanently delete Tour Schedule #" + scheduleId + "? This action cannot be undone.")) {
                document.getElementById('deleteScheduleId').value = scheduleId;
                document.getElementById('deleteForm').submit();
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
            fetch('${pageContext.request.contextPath}/admin/staff/schedules?action=getDetails&scheduleId=' + scheduleId)
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
                    document.getElementById('detailPrice').innerText = Number(sched.price).toLocaleString('vi-VN') + 'd';
                    
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
                                '<td class="text-end fw-bold text-primary">' + Number(b.totalPrice).toLocaleString('vi-VN') + 'd</td>' +
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

        const tourDurations = {
            <c:forEach var="t" items="${tours}">
                "${t.tourId}": ${t.durationDays > 0 ? t.durationDays : 1},
            </c:forEach>
        };

        function autoCalculateReturnDate(depDateString, durationDays) {
            if (!depDateString || !durationDays || durationDays < 1) return null;
            const parts = depDateString.split('-');
            if (parts.length !== 3) return null;
            const year = parseInt(parts[0], 10);
            const month = parseInt(parts[1], 10) - 1;
            const day = parseInt(parts[2], 10);
            
            const depDate = new Date(Date.UTC(year, month, day));
            if (isNaN(depDate.getTime())) return null;
            
            depDate.setUTCDate(depDate.getUTCDate() + (parseInt(durationDays, 10) - 1));
            
            const resYear = depDate.getUTCFullYear();
            const resMonth = String(depDate.getUTCMonth() + 1).padStart(2, '0');
            const resDay = String(depDate.getUTCDate()).padStart(2, '0');
            
            return resYear + '-' + resMonth + '-' + resDay;
        }

        function validateCreateDates() {
            const depDateVal = document.getElementById('createDepartureDate').value;
            const retDateVal = document.getElementById('createReturnDate').value;
            const errorAlert = document.getElementById('createModalErrorAlert');
            const submitBtn = document.getElementById('submitCreateBtn');

            if (depDateVal && retDateVal) {
                const depDate = new Date(depDateVal);
                const retDate = new Date(retDateVal);
                const depYear = depDate.getFullYear();
                const retYear = retDate.getFullYear();

                if (depYear < 2020 || depYear > 2099 || retYear < 2020 || retYear > 2099) {
                    if (errorAlert) {
                        errorAlert.innerHTML = '<i class="fa-solid fa-circle-exclamation me-1"></i>Year must be a valid 4-digit year (2020 - 2099).';
                        errorAlert.classList.remove('d-none');
                    }
                    if (submitBtn) submitBtn.disabled = true;
                } else if (depDate > retDate) {
                    if (errorAlert) {
                        errorAlert.innerHTML = '<i class="fa-solid fa-circle-exclamation me-1"></i>Departure date cannot be after return date.';
                        errorAlert.classList.remove('d-none');
                    }
                    if (submitBtn) submitBtn.disabled = true;
                } else {
                    if (errorAlert) errorAlert.classList.add('d-none');
                    if (submitBtn) submitBtn.disabled = false;
                }
            }
        }

        function onDepartureDateChangeCreate() {
            const depVal = document.getElementById('createDepartureDate').value;
            const selectTour = document.querySelector('select[name="formTourId"]');
            const tourId = (selectTour && selectTour.value) ? selectTour.value : "${selectedTourId}";
            const duration = tourDurations[tourId] || 1;
            
            if (depVal) {
                const calculatedRet = autoCalculateReturnDate(depVal, duration);
                if (calculatedRet) {
                    document.getElementById('createReturnDate').value = calculatedRet;
                }
            }
            validateCreateDates();
        }

        function onTourSelectChangeCreate() {
            const depVal = document.getElementById('createDepartureDate').value;
            const selectTour = document.querySelector('select[name="formTourId"]');
            const tourId = selectTour ? selectTour.value : null;
            const duration = tourDurations[tourId] || 1;
            
            if (depVal && tourId) {
                const calculatedRet = autoCalculateReturnDate(depVal, duration);
                if (calculatedRet) {
                    document.getElementById('createReturnDate').value = calculatedRet;
                }
            }
            validateCreateDates();
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

        window.addEventListener('DOMContentLoaded', (event) => {
            // Ensure capacity field only accepts multiples of 44, and min 44
            const createTotalSlots = document.getElementById('createTotalSlots');
            if (createTotalSlots) {
                createTotalSlots.addEventListener('change', function() {
                    let val = parseInt(this.value);
                    if (isNaN(val) || val < 44) {
                        this.value = 44;
                    } else {
                        this.value = Math.round(val / 44) * 44;
                    }
                });
            }
        });
    </script>

</div>

<jsp:include page="../admin/layout/footer.jsp" />
