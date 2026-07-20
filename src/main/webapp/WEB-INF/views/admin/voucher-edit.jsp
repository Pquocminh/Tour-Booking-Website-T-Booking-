<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Edit Voucher" />
    <jsp:param name="activeMenu" value="vouchers" />
</jsp:include>

<!-- Main Content -->
<div class="container-fluid p-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary btn-sm mb-2">
                <i class="fa-solid fa-arrow-left me-1"></i>Back to Vouchers
            </a>
            <h3 class="mb-0 fw-bold" style="color: var(--text-main);">Edit Voucher: <span class="text-primary">${voucher.voucherCode}</span></h3>
        </div>
    </div>

    <!-- Notification Alerts -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
        </div>
    </c:if>

    <!-- Edit Voucher Panel -->
    <section class="filter-panel mb-4">
        <form method="POST" action="${pageContext.request.contextPath}/admin/vouchers">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${voucher.voucherId}">
            
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold">Voucher Code</label>
                    <input type="text" name="voucherCode" value="${voucher.voucherCode}" class="form-control rounded-3" style="text-transform: uppercase;" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold">Discount Percent (%)</label>
                    <input type="number" name="discountPercent" value="${voucher.discountPercent}" step="0.01" class="form-control rounded-3" min="0" max="100" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold">Quantity (Uses)</label>
                    <input type="number" name="quantity" value="${voucher.quantity}" class="form-control rounded-3" min="1" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold">Status</label>
                    <select name="status" class="form-select rounded-3" required>
                        <option value="Active" ${'Active'.equalsIgnoreCase(voucher.status) ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${'Inactive'.equalsIgnoreCase(voucher.status) ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Minimum Order Value (VND)</label>
                    <input type="number" name="minimumOrderValue" value="${voucher.minimumOrderValue}" class="form-control rounded-3" min="0" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Max Discount Amount (VND)</label>
                    <input type="number" name="maxDiscountAmount" value="${voucher.maxDiscountAmount}" class="form-control rounded-3" min="0" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">Start Date</label>
                    <input type="date" name="startDate" value="${voucher.startDate}" min="2020-01-01" max="2099-12-31" class="form-control rounded-3" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">End Date</label>
                    <input type="date" name="endDate" value="${voucher.endDate}" min="2020-01-01" max="2099-12-31" class="form-control rounded-3" required>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 mt-4">
                <button type="submit" class="btn btn-warning px-4 rounded-3 fw-bold text-dark">
                    <i class="fa-solid fa-floppy-disk me-2"></i>Save Changes
                </button>
            </div>
        </form>
    </section>
</div>

<jsp:include page="layout/footer.jsp" />
