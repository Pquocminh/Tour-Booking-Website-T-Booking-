<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Discount Policies" />
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
                <!-- UC 1: Configure Discount Rules -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-indigo-light">
                            <i class="fa-solid fa-percent"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Discount Rules</h4>
                        <p class="text-muted small mb-4">Set up general rules to automatically discount bookings exceeding a specific price threshold.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Booking Amount (đ)</label>
                            <input type="number" step="1000" min="0" name="discountMinAmount" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.discount_min_amount : '1000000.00'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Discount Rate (%)</label>
                            <input type="number" min="0" max="100" name="discountPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.discount_percent : '5'}" required>
                        </div>
                    </div>
                </div>

                <!-- UC 2: Configure Deposit Policy -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-sky-light">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Deposit Policy</h4>
                        <p class="text-muted small mb-4">Specify the minimum down-payment percentage required for customers to reserve slots on a tour.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Deposit Percentage (%)</label>
                            <input type="number" min="1" max="100" name="depositPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.deposit_percent : '20'}" required>
                            <div class="form-text small text-muted">A setting of 100% requires payment in full upon booking.</div>
                        </div>
                    </div>
                </div>

                <!-- UC 3: Configure Group Booking Discount -->
                <div class="col-lg-4 col-md-6">
                    <div class="policy-card">
                        <div class="icon-circle bg-amber-light">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <h4 class="fw-bold mb-3 text-dark">Group Booking Discount</h4>
                        <p class="text-muted small mb-4">Reward large parties by setting a discount threshold based on the number of people in the booking.</p>
                        
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Min Group Size (People)</label>
                            <input type="number" min="1" name="groupMinPeople" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.group_min_people : '5'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Group Discount (%)</label>
                            <input type="number" min="0" max="100" name="groupDiscountPercent" class="form-control rounded-3" 
                                   value="${not empty settings ? settings.group_discount_percent : '10'}" required>
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