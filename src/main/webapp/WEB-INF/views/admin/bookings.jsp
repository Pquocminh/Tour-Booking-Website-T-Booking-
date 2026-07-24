<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Bookings" />
    <jsp:param name="activeMenu" value="bookings" />
</jsp:include>

<!-- Count bookings for each status -->
<c:set var="pendingCount" value="0"/>
<c:set var="confirmedCount" value="0"/>
<c:set var="completedCount" value="0"/>
<c:set var="cancelledCount" value="0"/>
<c:forEach var="b" items="${bookings}">
    <c:choose>
        <c:when test="${b.status == 'Pending'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:when>
        <c:when test="${b.status == 'Confirmed'}"><c:set var="confirmedCount" value="${confirmedCount + 1}"/></c:when>
        <c:when test="${b.status == 'Completed'}"><c:set var="completedCount" value="${completedCount + 1}"/></c:when>
        <c:when test="${b.status == 'Cancelled'}"><c:set var="cancelledCount" value="${cancelledCount + 1}"/></c:when>
    </c:choose>
</c:forEach>

<!-- Main Content -->
<div class="container-fluid p-0">
    <!-- Header Page -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-list-check me-2 text-primary"></i>Manage Bookings</h3>
            <p class="text-muted mb-0">View all customer bookings</p>
        </div>
    </div>

    <!-- Feedback Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            <c:remove var="successMessage" scope="session"/>
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            <c:remove var="errorMessage" scope="session"/>
        </div>
    </c:if>

    <!-- Table Panel -->
    <section class="table-panel">
        <!-- Tabs Nav -->
        <ul class="nav nav-tabs mb-4" id="bookingTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-bold" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="true">
                    <i class="fa-solid fa-circle-pause me-2 text-warning"></i>Pending
                    <span class="badge bg-warning text-dark ms-1 rounded-pill">${pendingCount}</span>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button" role="tab" aria-controls="confirmed" aria-selected="false">
                    <i class="fa-solid fa-circle-check me-2 text-success"></i>Confirmed
                    <span class="badge bg-success text-white ms-1 rounded-pill">${confirmedCount}</span>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button" role="tab" aria-controls="completed" aria-selected="false">
                    <i class="fa-solid fa-square-check me-2 text-primary"></i>Completed
                    <span class="badge bg-secondary text-white ms-1 rounded-pill">${completedCount}</span>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button" role="tab" aria-controls="cancelled" aria-selected="false">
                    <i class="fa-solid fa-ban me-2 text-danger"></i>Cancelled
                    <span class="badge bg-danger text-white ms-1 rounded-pill">${cancelledCount}</span>
                </button>
            </li>
        </ul>

        <!-- Tabs Content -->
        <div class="tab-content" id="bookingTabsContent">
            
            <!-- Pending Tab -->
            <div class="tab-pane fade show active" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                <div class="table-responsive" style="max-height: 650px; overflow-y: auto;">
                    <table class="table table-custom table-hover align-middle w-100 mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Booking ID</th>
                                <th>Tour Name</th>
                                <th>Departure Date</th>
                                <th>Contact Name</th>
                                <th class="text-center">People</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th style="width: 120px;" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPending" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status == 'Pending'}">
                                    <c:set var="hasPending" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not hasPending}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="fa-solid fa-box-open display-6 mb-3 opacity-50"></i>
                                            <p class="mb-0">No pending bookings found.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bookings}">
                                        <c:if test="${b.status == 'Pending'}">
                                            <tr>
                                                <td><span class="text-muted small fw-bold">#${b.bookingId}</span></td>
                                                <td>
                                                    <div class="fw-bold text-primary text-truncate" style="max-width: 260px;" title="${b.tourName}">${b.tourName}</div>
                                                </td>
                                                <td><fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${b.contactName}</div>
                                                    <div class="text-muted small">${b.contactPhone}</div>
                                                </td>
                                                <td class="text-center fw-bold text-dark">${b.numberOfPeople}</td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/admin/bookings" method="post" class="m-0 p-0">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                        <select name="status" class="form-select form-select-sm fw-bold rounded-pill text-center border-0" 
                                                            onchange="this.form.submit()" 
                                                            style="cursor: pointer; box-shadow: none; width: 130px; display: inline-block; background-color: #fff3cd; color: #856404;">
                                                            <option value="Pending" style="background-color: white; color: black;" selected>Pending</option>
                                                            <option value="Confirmed" style="background-color: white; color: black;">Confirmed</option>
                                                            <option value="Completed" style="background-color: white; color: black;">Completed</option>
                                                        </select>
                                                    </form>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <button class="btn btn-outline-info btn-icon shadow-sm" title="View Details" data-bs-toggle="modal" data-bs-target="#viewDetailsModal${b.bookingId}">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-icon shadow-sm" title="Cancel Booking" data-bs-toggle="modal" data-bs-target="#cancelModal${b.bookingId}">
                                                            <i class="fa-solid fa-ban"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Confirmed Tab -->
            <div class="tab-pane fade" id="confirmed" role="tabpanel" aria-labelledby="confirmed-tab">
                <div class="table-responsive" style="max-height: 650px; overflow-y: auto;">
                    <table class="table table-custom table-hover align-middle w-100 mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Booking ID</th>
                                <th>Tour Name</th>
                                <th>Departure Date</th>
                                <th>Contact Name</th>
                                <th class="text-center">People</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th style="width: 120px;" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasConfirmed" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status == 'Confirmed'}">
                                    <c:set var="hasConfirmed" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not hasConfirmed}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="fa-solid fa-box-open display-6 mb-3 opacity-50"></i>
                                            <p class="mb-0">No confirmed bookings found.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bookings}">
                                        <c:if test="${b.status == 'Confirmed'}">
                                            <tr>
                                                <td><span class="text-muted small fw-bold">#${b.bookingId}</span></td>
                                                <td>
                                                    <div class="fw-bold text-primary text-truncate" style="max-width: 260px;" title="${b.tourName}">${b.tourName}</div>
                                                </td>
                                                <td><fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${b.contactName}</div>
                                                    <div class="text-muted small">${b.contactPhone}</div>
                                                </td>
                                                <td class="text-center fw-bold text-dark">${b.numberOfPeople}</td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/admin/bookings" method="post" class="m-0 p-0">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                        <select name="status" class="form-select form-select-sm fw-bold rounded-pill text-center border-0" 
                                                            onchange="this.form.submit()" 
                                                            style="cursor: pointer; box-shadow: none; width: 130px; display: inline-block; background-color: #d1e7dd; color: #0f5132;">
                                                            <option value="Pending" style="background-color: white; color: black;">Pending</option>
                                                            <option value="Confirmed" style="background-color: white; color: black;" selected>Confirmed</option>
                                                            <option value="Completed" style="background-color: white; color: black;">Completed</option>
                                                        </select>
                                                    </form>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <button class="btn btn-outline-info btn-icon shadow-sm" title="View Details" data-bs-toggle="modal" data-bs-target="#viewDetailsModal${b.bookingId}">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-icon shadow-sm" title="Cancel Booking" data-bs-toggle="modal" data-bs-target="#cancelModal${b.bookingId}">
                                                            <i class="fa-solid fa-ban"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Completed Tab -->
            <div class="tab-pane fade" id="completed" role="tabpanel" aria-labelledby="completed-tab">
                <div class="table-responsive" style="max-height: 650px; overflow-y: auto;">
                    <table class="table table-custom table-hover align-middle w-100 mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Booking ID</th>
                                <th>Tour Name</th>
                                <th>Departure Date</th>
                                <th>Contact Name</th>
                                <th class="text-center">People</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th style="width: 120px;" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasCompleted" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status == 'Completed'}">
                                    <c:set var="hasCompleted" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not hasCompleted}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="fa-solid fa-box-open display-6 mb-3 opacity-50"></i>
                                            <p class="mb-0">No completed bookings found.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bookings}">
                                        <c:if test="${b.status == 'Completed'}">
                                            <tr>
                                                <td><span class="text-muted small fw-bold">#${b.bookingId}</span></td>
                                                <td>
                                                    <div class="fw-bold text-primary text-truncate" style="max-width: 260px;" title="${b.tourName}">${b.tourName}</div>
                                                </td>
                                                <td><fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${b.contactName}</div>
                                                    <div class="text-muted small">${b.contactPhone}</div>
                                                </td>
                                                <td class="text-center fw-bold text-dark">${b.numberOfPeople}</td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/admin/bookings" method="post" class="m-0 p-0">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                        <select name="status" class="form-select form-select-sm fw-bold rounded-pill text-center border-0" 
                                                            onchange="this.form.submit()" 
                                                            style="cursor: pointer; box-shadow: none; width: 130px; display: inline-block; background-color: #e2e3e5; color: #41464b;">
                                                            <option value="Pending" style="background-color: white; color: black;">Pending</option>
                                                            <option value="Confirmed" style="background-color: white; color: black;">Confirmed</option>
                                                            <option value="Completed" style="background-color: white; color: black;" selected>Completed</option>
                                                        </select>
                                                    </form>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <button class="btn btn-outline-info btn-icon shadow-sm" title="View Details" data-bs-toggle="modal" data-bs-target="#viewDetailsModal${b.bookingId}">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-icon shadow-sm" title="Cancel Booking" data-bs-toggle="modal" data-bs-target="#cancelModal${b.bookingId}">
                                                            <i class="fa-solid fa-ban"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Cancelled Tab -->
            <div class="tab-pane fade" id="cancelled" role="tabpanel" aria-labelledby="cancelled-tab">
                <div class="table-responsive" style="max-height: 650px; overflow-y: auto;">
                    <table class="table table-custom table-hover align-middle w-100 mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Booking ID</th>
                                <th>Tour Name</th>
                                <th>Departure Date</th>
                                <th>Contact Name</th>
                                <th class="text-center">People</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th style="width: 120px;" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasCancelled" value="false" />
                            <c:forEach var="b" items="${bookings}">
                                <c:if test="${b.status == 'Cancelled'}">
                                    <c:set var="hasCancelled" value="true" />
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${not hasCancelled}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-5">
                                            <i class="fa-solid fa-box-open display-6 mb-3 opacity-50"></i>
                                            <p class="mb-0">No cancelled bookings found.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="b" items="${bookings}">
                                        <c:if test="${b.status == 'Cancelled'}">
                                            <tr>
                                                <td><span class="text-muted small fw-bold">#${b.bookingId}</span></td>
                                                <td>
                                                    <div class="fw-bold text-primary text-truncate" style="max-width: 260px;" title="${b.tourName}">${b.tourName}</div>
                                                </td>
                                                <td><fmt:formatDate value="${b.departureDate}" pattern="dd/MM/yyyy"/></td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${b.contactName}</div>
                                                    <div class="text-muted small">${b.contactPhone}</div>
                                                </td>
                                                <td class="text-center fw-bold text-dark">${b.numberOfPeople}</td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/>
                                                </td>
                                                <td>
                                                    <span class="badge bg-danger px-3 py-2 rounded-pill">Cancelled</span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <button class="btn btn-outline-info btn-icon shadow-sm" title="View Details" data-bs-toggle="modal" data-bs-target="#viewDetailsModal${b.bookingId}">
                                                            <i class="fa-solid fa-eye"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </section>
</div>

<!-- Modals rendered outside table structure -->
<c:if test="${not empty bookings}">
    <c:forEach var="b" items="${bookings}">
        <!-- View Details Modal -->
        <div class="modal fade" id="viewDetailsModal${b.bookingId}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-primary"><i class="fa-solid fa-receipt me-2"></i>Booking Details #${b.bookingId}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <!-- Tour Info -->
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-secondary border-bottom pb-2 small">Tour Information</h6>
                                <div class="mb-2"><strong>Tour Name:</strong> <span class="text-primary">${b.tourName}</span></div>
                                <div class="mb-2"><strong>Departure Date:</strong> <fmt:formatDate value="${b.departureDate}" pattern="MMM dd, yyyy"/></div>
                                <div class="mb-2"><strong>Number of People:</strong> ${b.numberOfPeople}</div>
                            </div>
                            <!-- Customer Info -->
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-secondary border-bottom pb-2 small">Customer Account</h6>
                                <div class="mb-2"><strong>Username:</strong> ${not empty b.customerUsername ? b.customerUsername : 'Guest'}</div>
                                <div class="mb-2"><strong>Email:</strong> ${not empty b.customerEmail ? b.customerEmail : 'N/A'}</div>
                            </div>
                            <!-- Contact Info -->
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-secondary border-bottom pb-2 small">Contact details</h6>
                                <div class="mb-2"><strong>Contact Name:</strong> ${b.contactName}</div>
                                <div class="mb-2"><strong>Contact Phone:</strong> ${b.contactPhone}</div>
                            </div>
                            <!-- Payment Info -->
                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-secondary border-bottom pb-2 small">Payment & Status</h6>
                                <div class="mb-2"><strong>Total Price:</strong> <span class="fw-bold text-success"><fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/></span></div>
                                <div class="mb-2"><strong>Deposit Paid:</strong> <fmt:formatNumber value="${b.depositAmount}" pattern="#,##0 ₫"/></div>
                                <div class="mb-2"><strong>Remaining Amount:</strong> <span class="fw-bold text-dark"><fmt:formatNumber value="${b.totalPrice - b.depositAmount}" pattern="#,##0 ₫"/></span></div>
                                <div class="mb-2"><strong>Status:</strong> ${b.status}</div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- End View Details Modal -->
        
        <!-- Cancel Booking Modal -->
        <c:if test="${b.status != 'Cancelled'}">
            <div class="modal fade" id="cancelModal${b.bookingId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow" style="border-radius: 20px;">
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-circle-exclamation me-2"></i>Cancel Booking #${b.bookingId}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/bookings" method="post">
                            <div class="modal-body text-start">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                <p class="mb-0">Are you sure you want to cancel booking <strong>#${b.bookingId}</strong> for <strong>${b.contactName}</strong>?</p>
                                <p class="text-danger small mt-2 mb-0"><i class="fa-solid fa-triangle-exclamation me-1"></i>This will update the booking status to Cancelled and release ${b.numberOfPeople} slots back to the schedule.</p>
                            </div>
                            <div class="modal-footer border-0 pt-0">
                                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">No, Keep It</button>
                                <button type="submit" class="btn btn-danger rounded-pill px-4">Yes, Cancel Booking</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
        <!-- End Cancel Booking Modal -->
    </c:forEach>
</c:if>

<jsp:include page="layout/footer.jsp" />
