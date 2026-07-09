<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Promotions" />
    <jsp:param name="activeMenu" value="promotions" />
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

        <!-- Create Promotion Panel -->
        <section class="filter-panel">
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-circle-plus me-2 text-primary"></i>Create New Promotion</h4>
            <form method="POST" action="${pageContext.request.contextPath}/admin/promotions">
                <input type="hidden" name="action" value="create">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Promotion Name</label>
                        <input type="text" name="promotionName" class="form-control rounded-3" placeholder="e.g., Summer Special discount" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Discount Percent (%)</label>
                        <input type="number" name="discountPercent" class="form-control rounded-3" min="1" max="100" placeholder="10" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" selected>Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Start Date</label>
                        <input type="date" name="startDate" class="form-control rounded-3" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">End Date</label>
                        <input type="date" name="endDate" class="form-control rounded-3" required>
                    </div>
                    
                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Apply to Tours</label>
                        <div class="tour-list-scroll">
                            <c:choose>
                                <c:when test="${empty tours}">
                                    <p class="text-muted small mb-0">No active tours available to apply promotions.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="tour" items="${tours}">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="checkbox" name="tourIds" value="${tour.tourId}" id="tour_${tour.tourId}">
                                            <label class="form-check-label small" for="tour_${tour.tourId}">
                                                <span class="text-primary fw-bold">[#${tour.tourId}]</span> ${tour.tourName} 
                                                <span class="text-muted">(${tour.durationDays} Days, <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>)</span>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button type="reset" class="btn btn-outline-secondary px-4 rounded-3">
                        Reset Form
                    </button>
                    <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">
                        Create Promotion
                    </button>
                </div>
            </form>
        </section>

        <!-- Promotions Table List -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-percent me-2 text-primary"></i>Promotions List</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${promotions.size()} Promotion(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th>Promotion Name</th>
                            <th>Discount (%)</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th style="width: 220px;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty promotions}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                        No promotions found in the system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="promo" items="${promotions}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${promo.promotionId}</td>
                                        <td>
                                            <span class="fw-semibold text-dark d-block">${promo.promotionName}</span>
                                        </td>
                                        <td class="fw-bold text-primary">${promo.discountPercent}%</td>
                                        <td><fmt:formatDate value="${promo.startDate}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${promo.endDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Active'.equalsIgnoreCase(promo.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/promotions?action=view&id=${promo.promotionId}" 
                                                   class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                    <i class="fa-solid fa-eye me-1"></i>Details
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/promotions?action=edit&id=${promo.promotionId}" 
                                                   class="btn btn-sm btn-outline-warning rounded-pill px-3">
                                                    <i class="fa-solid fa-pen me-1"></i>Edit
                                                </a>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/promotions" 
                                                      onsubmit="return confirm('Are you sure you want to delete this promotion? This action cannot be undone.');"
                                                      style="display:inline-block;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${promo.promotionId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                                        <i class="fa-solid fa-trash me-1"></i>Delete
                                                    </button>
                                                </form>
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