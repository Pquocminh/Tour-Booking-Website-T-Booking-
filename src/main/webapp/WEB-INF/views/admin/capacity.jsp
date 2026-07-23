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
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-route me-2 text-primary"></i>Search Tour Package</h4>
            <form method="GET" action="${pageContext.request.contextPath}/admin/capacity">
                <div class="row g-3 align-items-end">
                    <div class="col-md-9 position-relative">
                        <label class="form-label text-muted small fw-bold">Search Tour</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 rounded-start-3"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                            <input type="text" id="tourSearchInput" name="tourId" class="form-control border-start-0 rounded-end-3" 
                                   placeholder="Search tour by ID or Name (Leave empty for all)..." value="${searchQuery}" autocomplete="off">
                        </div>

                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 rounded-3 text-white py-2">
                            <i class="fa-solid fa-calendar-check me-2"></i>Search
                        </button>
                    </div>
                </div>
            </form>
        </section>
        <!-- Dynamic Schedule Details Panel (No JavaScript) -->
        <c:if test="${not empty detailSchedule}">
            <section class="filter-panel mb-4" style="border-left: 5px solid var(--bs-primary); background: #ffffff; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border-radius: 15px; padding: 25px;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-circle-info text-primary me-2"></i>Tour Schedule Details (ID: #${detailSchedule.scheduleId})</h4>
                    <a href="${pageContext.request.contextPath}/admin/capacity?${not empty selectedTourId ? 'tourId='.concat(selectedTourId) : ''}" class="btn-close" aria-label="Close"></a>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <span class="text-muted small d-block">TOUR PACKAGE</span>
                        <span class="fw-bold text-dark">${detailTour.tourName}</span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">DEPARTURE FROM</span>
                        <span class="fw-bold text-dark">${detailTour.departureLocation}</span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">DURATION</span>
                        <span class="fw-bold text-dark">${detailTour.durationDays} Days</span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">PRICE</span>
                        <span class="fw-bold text-primary">
                            <fmt:formatNumber value="${detailSchedule.price}" pattern="#,##0 ₫"/>
                        </span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">DEPARTURE DATE</span>
                        <span class="fw-bold text-dark"><fmt:formatDate value="${detailSchedule.departureDate}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">RETURN DATE</span>
                        <span class="fw-bold text-dark"><fmt:formatDate value="${detailSchedule.returnDate}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">STATUS</span>
                        <c:choose>
                            <c:when test="${'Open'.equalsIgnoreCase(detailSchedule.status)}">
                                <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Open</span>
                            </c:when>
                            <c:when test="${'Full'.equalsIgnoreCase(detailSchedule.status)}">
                                <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Full</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-1 rounded-pill">${detailSchedule.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-3">
                        <span class="text-muted small d-block">AVAILABILITY (Available/Total)</span>
                        <span class="fw-bold text-dark">${detailSchedule.availableSlots} / ${detailSchedule.totalSlots} slots left</span>
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
                        <tbody>
                            <c:choose>
                                <c:when test="${empty detailBookings}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted"><i class="fa-solid fa-users-slash me-1"></i>No bookings yet.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${detailBookings}">
                                        <tr>
                                            <td><span class="text-muted fw-bold">#${b.bookingId}</span></td>
                                            <td class="fw-semibold">${b.contactName}</td>
                                            <td>${b.contactPhone}</td>
                                            <td class="text-center fw-bold">${b.numberOfPeople}</td>
                                            <td class="text-end fw-bold text-primary">
                                                <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${'Confirmed'.equalsIgnoreCase(b.status)}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1 rounded-pill">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${'Pending'.equalsIgnoreCase(b.status)}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1 rounded-pill">Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary px-2 py-1 rounded-pill">${b.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </c:if>

        <!-- Schedules Table List -->
        <c:if test="${schedules != null}">
            <section class="table-panel">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-2">
                    <div>
                        <span class="text-muted small d-block">MANAGING CAPACITY FOR</span>
                        <h4 class="mb-0 fw-bold text-dark">
                            <i class="fa-solid fa-calendar-days me-2 text-primary"></i>
                            <c:choose>
                                <c:when test="${not empty selectedTour}">
                                    ${selectedTour.tourName}
                                </c:when>
                                <c:when test="${not empty searchQuery}">
                                    Search results for "${searchQuery}"
                                </c:when>
                                <c:otherwise>
                                    All Tour Packages
                                </c:otherwise>
                            </c:choose>
                        </h4>
                    </div>
                    <span class="badge bg-primary rounded-pill py-2 px-3 align-self-start">${schedules.size()} Schedule(s)</span>
                </div>

                <div class="table-responsive" style="max-height: 650px; overflow-y: auto;">
                    <table class="table table-custom table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Sched ID</th>
                                <c:if test="${empty selectedTour}">
                                    <th>Tour Name</th>
                                </c:if>
                                <th>Departure Date</th>
                                <th>Return Date</th>
                                <th>Price</th>
                                <th class="text-center">Total Capacity</th>
                                <th class="text-center">Booked</th>
                                <th class="text-center">Available</th>
                                <th>Assigned Staff</th>
                                <th>Status</th>
                                <th style="width: 150px; position: sticky; right: 0; background-color: #f8f9fa; z-index: 1;" class="text-center shadow-sm">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty schedules}">
                                    <tr>
                                        <td colspan="${empty selectedTour ? 11 : 10}" class="text-center py-5 text-muted">
                                            <i class="fa-regular fa-calendar display-4 mb-3 d-block text-secondary"></i>
                                            No schedules found.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="s" items="${schedules}">
                                        <tr>
                                            <td><span class="text-muted small fw-bold">#${s.scheduleId}</span></td>
                                            <c:if test="${empty selectedTour}">
                                                <td class="fw-semibold text-dark text-truncate" style="max-width: 200px;" title="${s.tourName}">${s.tourName}</td>
                                            </c:if>
                                            <td class="fw-semibold"><fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${s.returnDate}" pattern="dd/MM/yyyy"/></td>
                                            <td class="fw-bold text-primary">
                                                <fmt:formatNumber value="${s.price}" pattern="#,##0 ₫"/>
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
                                                    <c:when test="${not empty s.assignedStaffName}">
                                                        <div class="fw-bold text-primary"><i class="fa-solid fa-user-check me-1"></i>${s.assignedStaffName}</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small"><i class="fa-regular fa-circle-user me-1"></i>Unassigned</span>
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
                                            <td style="position: sticky; right: 0; background-color: #ffffff; z-index: 1;" class="text-center shadow-sm">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a class="btn btn-outline-info btn-icon shadow-sm" title="View Detail"
                                                       href="${pageContext.request.contextPath}/admin/capacity?${not empty selectedTourId ? 'tourId='.concat(selectedTourId).concat('&') : ''}detailScheduleId=${s.scheduleId}">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                    <button class="btn btn-outline-success btn-icon shadow-sm" title="Reserve Slots" 
                                                            ${(!'Open'.equalsIgnoreCase(s.status) || s.availableSlots <= 0) ? 'disabled' : ''}
                                                            data-bs-toggle="modal" data-bs-target="#reserveSlotsModal${s.scheduleId}">
                                                        <i class="fa-solid fa-ticket"></i>
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${'Cancelled'.equalsIgnoreCase(s.status) || 'Completed'.equalsIgnoreCase(s.status)}">
                                                            <button class="btn btn-outline-secondary btn-icon shadow-sm" disabled title="Cannot release slots for Cancelled/Completed schedules">
                                                                <i class="fa-solid fa-plus"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-outline-primary btn-icon shadow-sm" title="Release Additional Slots" 
                                                                    data-bs-toggle="modal" data-bs-target="#releaseSlotsModal${s.scheduleId}">
                                                                <i class="fa-solid fa-plus"></i>
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

                <!-- Modals rendered outside table structure -->
                <c:if test="${not empty schedules}">
                    <c:forEach var="s" items="${schedules}">
                        <!-- Release Slots Modal for Schedule #${s.scheduleId} -->
                        <div class="modal fade text-start" id="releaseSlotsModal${s.scheduleId}" tabindex="-1" aria-labelledby="releaseSlotsModalLabel${s.scheduleId}" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                                    <div class="modal-header border-0 pb-0">
                                        <h5 class="modal-title fw-bold" id="releaseSlotsModalLabel${s.scheduleId}"><i class="fa-solid fa-circle-plus text-primary me-2"></i>Release Additional Slots</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form method="POST" action="${pageContext.request.contextPath}/admin/capacity">
                                        <input type="hidden" name="action" value="release">
                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                                        <input type="hidden" name="tourId" value="${s.tourId}">
                                        
                                        <div class="modal-body py-4">
                                            <div class="mb-3 bg-light p-3 rounded-3">
                                                <div class="row g-2">
                                                    <div class="col-6">
                                                        <span class="text-muted small d-block">DEPARTURE DATE</span>
                                                        <span class="fw-bold text-dark"><fmt:formatDate value="${s.departureDate}" pattern="dd/MM/yyyy"/></span>
                                                    </div>
                                                    <div class="col-6">
                                                        <span class="text-muted small d-block">CURRENT CAPACITY (Avail/Total)</span>
                                                        <span class="fw-bold text-dark">${s.availableSlots} / ${s.totalSlots}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="slotsToRelease${s.scheduleId}" class="form-label text-muted small fw-bold">Number of slots to release (Bus capacity)</label>
                                                <input type="number" class="form-control rounded-3" id="slotsToRelease${s.scheduleId}" name="slotsToRelease" min="44" step="44" value="44" required placeholder="44 (1 Bus)">
                                                <div class="form-text">Each release adds 1 big bus (44 passenger slots).</div>
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

                        <!-- Reserve Slots Modal for Schedule #${s.scheduleId} -->
                        <div class="modal fade text-start" id="reserveSlotsModal${s.scheduleId}" tabindex="-1" aria-labelledby="reserveSlotsModalLabel${s.scheduleId}" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                                    <div class="modal-header border-0 pb-0">
                                        <h5 class="modal-title fw-bold" id="reserveSlotsModalLabel${s.scheduleId}"><i class="fa-solid fa-ticket text-success me-2"></i>Reserve Tour Slots</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form method="POST" action="${pageContext.request.contextPath}/admin/capacity">
                                        <input type="hidden" name="action" value="reserve">
                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                                        <input type="hidden" name="tourId" value="${s.tourId}">
                                        
                                        <div class="modal-body py-4">
                                            <div class="mb-3 bg-light p-3 rounded-3 text-start">
                                                <span class="text-muted small d-block">TOUR PACKAGE</span>
                                                <span class="fw-bold text-dark">${empty selectedTour ? s.tourName : selectedTour.tourName}</span>
                                            </div>

                                            <div class="mb-3 bg-light p-3 rounded-3 text-start">
                                                <span class="text-muted small d-block">AVAILABLE SLOTS</span>
                                                <span class="fw-bold text-success">${s.availableSlots} slots left</span>
                                            </div>

                                            <div class="mb-3">
                                                <label for="customerIdentifier${s.scheduleId}" class="form-label text-muted small fw-bold">Customer Username or Email</label>
                                                <input type="text" class="form-control rounded-3" id="customerIdentifier${s.scheduleId}" name="customerIdentifier" placeholder="e.g. minhpq" required>
                                                <div class="form-text text-muted small">Enter the username or email of a registered customer.</div>
                                            </div>

                                            <div class="row g-3 mb-3">
                                                <div class="col-md-6">
                                                    <label for="reserveContactName${s.scheduleId}" class="form-label text-muted small fw-bold">Contact Name</label>
                                                    <input type="text" class="form-control rounded-3" id="reserveContactName${s.scheduleId}" name="contactName" placeholder="e.g. Pham Quoc Minh" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="reserveContactPhone${s.scheduleId}" class="form-label text-muted small fw-bold">Contact Phone</label>
                                                    <input type="text" class="form-control rounded-3" id="reserveContactPhone${s.scheduleId}" name="contactPhone" placeholder="e.g. 0923456789" required>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label for="reserveNumSlots${s.scheduleId}" class="form-label text-muted small fw-bold">Number of slots to reserve</label>
                                                <input type="number" class="form-control rounded-3" id="reserveNumSlots${s.scheduleId}" name="numberOfPeople" min="1" max="${s.availableSlots}" required value="1">
                                                <div class="form-text">Choose between 1 and ${s.availableSlots} slots.</div>
                                            </div>
                                        </div>
                                        
                                        <div class="modal-footer border-0 pt-0">
                                            <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-success px-4 rounded-pill text-white">Reserve Slots</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </section>
        </c:if>
    </div>



    <jsp:include page="layout/footer.jsp" />