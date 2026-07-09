<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Bookings" />
    <jsp:param name="activeMenu" value="bookings" />
</jsp:include>


<!-- Main Content -->
<div class="col-lg-10 p-4">
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

    <!-- Table -->
    <div class="table-panel">
        <div class="table-responsive">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Tour Name</th>
                        <th>Departure Date</th>
                        <th>Contact Name</th>
                        <th>People</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-5">
                                    <i class="fa-solid fa-box-open display-6 mb-3 opacity-50"></i>
                                    <p class="mb-0">No bookings found.</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>#${b.bookingId}</td>
                                    <td>
                                        <div class="fw-bold text-primary">${b.tourName}</div>
                                    </td>
                                    <td><fmt:formatDate value="${b.departureDate}" pattern="MMM dd, yyyy"/></td>
                                    <td>
                                        <div>${b.contactName}</div>
                                        <div class="text-muted small">${b.contactPhone}</div>
                                    </td>
                                    <td>${b.numberOfPeople}</td>
                                    <td>
                                        <fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Pending</span>
                                            </c:when>
                                            <c:when test="${b.status == 'Confirmed'}">
                                                <span class="badge bg-success px-3 py-2 rounded-pill">Confirmed</span>
                                            </c:when>
                                            <c:when test="${b.status == 'Cancelled'}">
                                                <span class="badge bg-danger px-3 py-2 rounded-pill">Cancelled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary px-3 py-2 rounded-pill">${b.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <c:if test="${b.status != 'Cancelled'}">
                                            <button class="btn btn-sm btn-outline-danger rounded-circle me-1" title="Cancel Booking" data-bs-toggle="modal" data-bs-target="#cancelModal${b.bookingId}">
                                                <i class="fa-solid fa-ban"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-primary rounded-circle me-1" title="Update Status" data-bs-toggle="modal" data-bs-target="#updateStatusModal${b.bookingId}">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn btn-sm btn-outline-info rounded-circle me-1" title="View Details" data-bs-toggle="modal" data-bs-target="#viewDetailsModal${b.bookingId}">
                                            <i class="fa-solid fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>

                                <!-- View Details Modal -->
                                <div class="modal fade" id="viewDetailsModal${b.bookingId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered modal-lg">
                                        <div class="modal-content border-0 shadow">
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
                                                        <div class="mb-2"><strong>Total Price:</strong> <span class="fw-bold text-success"><fmt:formatNumber value="${b.totalPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span></div>
                                                        <div class="mb-2"><strong>Deposit Paid:</strong> <fmt:formatNumber value="${b.depositAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
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
                                
                                <!-- Update Status Modal -->
                                <div class="modal fade" id="updateStatusModal${b.bookingId}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow">
                                            <div class="modal-header border-0 pb-0">
                                                <h5 class="modal-title fw-bold">Update Status for Booking #${b.bookingId}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/bookings" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    
                                                    <div class="mb-3">
                                                        <label class="form-label text-muted small fw-bold text-uppercase">Current Status</label>
                                                        <input type="text" class="form-control bg-light border-0" value="${b.status}" readonly>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label text-muted small fw-bold text-uppercase">New Status</label>
                                                        <select name="status" class="form-select border-0 bg-light" required>
                                                            <option value="Pending" ${b.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                            <option value="Confirmed" ${b.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                            <option value="Completed" ${b.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary rounded-pill px-4">Save Changes</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Modal -->
                                
                                <!-- Cancel Booking Modal -->
                                <c:if test="${b.status != 'Cancelled'}">
                                    <div class="modal fade" id="cancelModal${b.bookingId}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 shadow">
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
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />

