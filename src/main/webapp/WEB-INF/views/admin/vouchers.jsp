<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Vouchers" />
    <jsp:param name="activeMenu" value="vouchers" />
</jsp:include>

<style>
    .voucher-code-badge {
        font-weight: 700;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
        padding: 6px 12px;
        border-radius: 6px;
        background: rgba(79, 70, 229, 0.08);
        color: var(--primary);
        border: 1px dashed rgba(79, 70, 229, 0.3);
        transition: all 0.2s ease;
        display: inline-block;
    }
    .voucher-code-badge:hover {
        background: var(--primary);
        color: #fff;
        border-color: var(--primary);
        transform: scale(1.05);
        cursor: pointer;
    }
    .table-custom tbody tr {
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .table-custom tbody tr:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.04);
        background-color: rgba(79, 70, 229, 0.02) !important;
    }
</style>

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

        <!-- Create Voucher Panel (Only for Admin) -->
        <c:if test="${sessionScope.user.role == 'Admin'}">
        <section class="filter-panel mb-4">
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-ticket me-2 text-primary"></i>Create New Voucher</h4>
            <form method="POST" action="${pageContext.request.contextPath}/admin/vouchers">
                <input type="hidden" name="action" value="create">
                
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Voucher Code</label>
                        <input type="text" name="voucherCode" class="form-control rounded-3" placeholder="SUMMER26" style="text-transform: uppercase;" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Discount Percent (%)</label>
                        <input type="number" name="discountPercent" step="0.01" class="form-control rounded-3" min="0" max="100" placeholder="10.5" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Quantity (Uses)</label>
                        <input type="number" name="quantity" class="form-control rounded-3" min="1" placeholder="100" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" selected>Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Minimum Order Value (VND)</label>
                        <input type="number" name="minimumOrderValue" class="form-control rounded-3" min="0" placeholder="500000" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Max Discount Amount (VND)</label>
                        <input type="number" name="maxDiscountAmount" class="form-control rounded-3" min="0" placeholder="100000" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Start Date</label>
                        <input type="date" name="startDate" class="form-control rounded-3" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">End Date</label>
                        <input type="date" name="endDate" class="form-control rounded-3" required>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button type="reset" class="btn btn-outline-secondary px-4 rounded-3">Reset</button>
                    <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">Create Voucher</button>
                </div>
            </form>
        </section>
        </c:if>

        <!-- Vouchers Table List -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-tags me-2 text-primary"></i>View Vouchers List</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${vouchers.size()} Voucher(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th>Code</th>
                            <th>Discount</th>
                            <th>Min Order / Max Amt</th>
                            <th>Quantity</th>
                            <th>Valid Dates</th>
                            <th>Status</th>
                            <th style="width: 150px;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty vouchers}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-ticket-simple display-4 mb-3 d-block text-secondary"></i>
                                        No vouchers found in the system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="v" items="${vouchers}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${v.voucherId}</td>
                                        <td>
                                            <span class="voucher-code-badge">${v.voucherCode}</span>
                                        </td>
                                        <td class="fw-bold text-primary">${v.discountPercent}%</td>
                                        <td class="small text-muted">
                                            Min: <fmt:formatNumber value="${v.minimumOrderValue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/><br>
                                            Max: <fmt:formatNumber value="${v.maxDiscountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td class="fw-semibold">${v.quantity}</td>
                                        <td class="small">
                                            <span class="text-success"><i class="fa-solid fa-calendar-day me-1"></i><fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy" /></span><br>
                                            <span class="text-danger"><i class="fa-solid fa-calendar-check me-1"></i><fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy" /></span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Active'.equalsIgnoreCase(v.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/vouchers?action=detail&id=${v.voucherId}" 
                                                   class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                    <i class="fa-solid fa-eye me-1"></i>View
                                                </a>
                                                <c:choose>
                                                    <c:when test="${sessionScope.user.role == 'Admin'}">
                                                        <a href="${pageContext.request.contextPath}/admin/vouchers?action=edit&id=${v.voucherId}" 
                                                           class="btn btn-sm btn-outline-warning rounded-pill px-3">
                                                            <i class="fa-solid fa-pen me-1"></i>Edit
                                                        </a>
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/vouchers" 
                                                              onsubmit="return confirm('Delete this voucher? Cannot be undone.');"
                                                              style="display:inline-block;">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${v.voucherId}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                                                <i class="fa-solid fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small"><i class="fa-solid fa-lock me-1"></i>View Only</span>
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

<jsp:include page="layout/footer.jsp" />
