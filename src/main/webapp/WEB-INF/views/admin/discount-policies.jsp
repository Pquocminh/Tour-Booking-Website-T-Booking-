<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Global Policies" />
    <jsp:param name="activeMenu" value="discount-policies" />
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

        <form method="POST" action="${pageContext.request.contextPath}/admin/discount-policies">
            <input type="hidden" name="action" value="updatePolicies">
            
            <div class="row g-4">
                <!-- UC 1: Booking Window Policy -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card p-4 bg-white rounded-4 shadow-sm border h-100">
                        <div class="icon-circle bg-indigo-light mb-3">
                            <i class="fa-solid fa-calendar-check text-indigo fa-2x"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Booking Window</h4>
                        <p class="text-muted small mb-4">Minimum days before departure that a customer must complete their booking. Prevents last-minute bookings.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Days to Book</label>
                            <input type="number" min="0" name="bookingWindowDays" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.booking_window_days : '3'}" required>
                        </div>
                    </div>
                </div>

                <!-- UC 2: Configure Deposit Policy -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card p-4 bg-white rounded-4 shadow-sm border border-primary h-100">
                        <div class="icon-circle bg-sky-light mb-3">
                            <i class="fa-solid fa-file-invoice-dollar text-primary fa-2x"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Deposit Policy</h4>
                        <p class="text-muted small mb-4">Specify the minimum down-payment percentage required for customers to reserve slots on a tour. This applies globally.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Deposit Percentage (%)</label>
                            <input type="number" min="1" max="100" name="depositPercent" class="form-control form-control-lg rounded-3 border-primary" 
                                   value="${not empty settings ? settings.deposit_percent : '20'}" required>
                            <div class="form-text small text-muted mt-2">A setting of 100% requires payment in full upon booking.</div>
                        </div>
                    </div>
                </div>

                <!-- UC 3: Cancellation Window Policy -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card p-4 bg-white rounded-4 shadow-sm border h-100">
                        <div class="icon-circle bg-danger-subtle mb-3">
                            <i class="fa-solid fa-ban text-danger fa-2x"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Cancellation Window</h4>
                        <p class="text-muted small mb-4">Minimum days before departure that a customer is allowed to cancel their booking without penalty.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Days to Cancel</label>
                            <input type="number" min="0" name="cancellationWindowDays" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.cancellation_window_days : '7'}" required>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Button Bar -->
            <div class="d-flex justify-content-end gap-3 mt-5">
                <button type="reset" class="btn btn-outline-secondary px-4 py-2 rounded-pill">
                    <i class="fa-solid fa-rotate-left me-2"></i>Reset Form
                </button>
                <button type="submit" class="btn btn-primary text-white px-5 py-2 rounded-pill">
                    <i class="fa-solid fa-save me-2"></i>Save Policies
                </button>
            </div>
        </form>
    </div>

    <jsp:include page="layout/footer.jsp" />