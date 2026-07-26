<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../admin/layout/header.jsp">
    <jsp:param name="pageTitle" value="Edit Tour Schedule" />
    <jsp:param name="activeMenu" value="schedules" />
</jsp:include>

<div class="container-fluid p-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-1 fw-bold text-dark"><i class="fa-solid fa-calendar-check text-primary me-2"></i>Edit Tour Schedule #${schedule.scheduleId}</h4>
            <p class="text-muted small mb-0">Update schedule details and availability.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/staff/schedules" class="btn btn-outline-secondary rounded-pill px-3">
                <i class="fa-solid fa-arrow-left me-1"></i>Back to Schedules
            </a>
        </div>
    </div>

    <!-- Notification Alerts -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
            <c:remove var="errorMessage" scope="session"/>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-4">
            <form method="POST" action="${pageContext.request.contextPath}/admin/staff/schedules">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                <input type="hidden" name="tourId" value="${schedule.tourId}">
                
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">Tour Package</label>
                    <input type="text" class="form-control rounded-3 bg-light" value="${tour.tourName}" readonly disabled>
                </div>
                
                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <label for="departureDate" class="form-label text-muted small fw-bold">Departure Date</label>
                        <fmt:formatDate value="${schedule.departureDate}" pattern="yyyy-MM-dd" var="depDateStr"/>
                        <input type="date" class="form-control rounded-3" id="departureDate" name="departureDate" value="${depDateStr}" min="2020-01-01" max="2099-12-31" required>
                    </div>
                    <div class="col-md-6">
                        <label for="returnDate" class="form-label text-muted small fw-bold">Return Date</label>
                        <fmt:formatDate value="${schedule.returnDate}" pattern="yyyy-MM-dd" var="retDateStr"/>
                        <input type="date" class="form-control rounded-3" id="returnDate" name="returnDate" value="${retDateStr}" min="2020-01-01" max="2099-12-31" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="price" class="form-label text-muted small fw-bold">Price (d)</label>
                    <input type="number" class="form-control rounded-3 bg-light" id="price" name="price" value="${schedule.price}" readonly>
                    <div class="form-text text-muted small">Price is fixed for this schedule</div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-12">
                        <label for="assignedStaffId" class="form-label text-muted small fw-bold">Assigned Staff</label>
                        <select name="assignedStaffId" id="assignedStaffId" class="form-select rounded-3">
                            <option value="">-- No Staff Assigned --</option>
                            <c:forEach var="staff" items="${staffList}">
                                <option value="${staff.accountId}" ${staff.accountId == schedule.assignedStaffId ? 'selected' : ''}>${staff.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="totalSlots" class="form-label text-muted small fw-bold">Total Capacity</label>
                        <input type="number" class="form-control rounded-3 bg-light" id="totalSlots" name="totalSlots" value="${schedule.totalSlots}" readonly>
                        <c:set var="booked" value="${schedule.totalSlots - schedule.availableSlots}" />
                        <div class="form-text text-primary small">Already booked: ${booked}</div>
                    </div>
                    <div class="col-md-6">
                        <label for="status" class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" id="status" class="form-select rounded-3">
                            <option value="Open" ${schedule.status == 'Open' ? 'selected' : ''}>Open</option>
                            <option value="Full" ${schedule.status == 'Full' ? 'selected' : ''}>Full</option>
                            <option value="Cancelled" ${schedule.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end pt-3 border-top mt-4">
                    <a href="${pageContext.request.contextPath}/admin/staff/schedules" class="btn btn-outline-secondary px-4 rounded-pill me-2">Cancel</a>
                    <button type="submit" class="btn btn-primary px-4 rounded-pill text-white">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../admin/layout/footer.jsp" />
