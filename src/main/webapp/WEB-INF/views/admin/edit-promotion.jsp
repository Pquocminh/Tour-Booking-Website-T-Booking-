<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Edit Promotion" />
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

        <!-- Edit Promotion Form -->
        <section class="form-panel col-lg-8 mx-auto">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);">
                    <i class="fa-solid fa-pen-to-square me-2 text-warning"></i>Promotion Details
                </h4>
                <span class="badge bg-warning text-dark rounded-pill py-2 px-3">ID: #${promotion.promotionId}</span>
            </div>
            
            <form method="POST" action="${pageContext.request.contextPath}/admin/promotions">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${promotion.promotionId}">
                
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Promotion Name</label>
                        <input type="text" name="promotionName" class="form-control rounded-3" value="${promotion.promotionName}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Discount Percent (%)</label>
                        <input type="number" name="discountPercent" class="form-control rounded-3" min="1" max="100" value="${promotion.discountPercent}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" ${'Active'.equalsIgnoreCase(promotion.status) ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${'Inactive'.equalsIgnoreCase(promotion.status) ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Start Date</label>
                        <input type="date" name="startDate" class="form-control rounded-3" value="${promotion.startDate}" required>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">End Date</label>
                        <input type="date" name="endDate" class="form-control rounded-3" value="${promotion.endDate}" required>
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
                                        <!-- Check if tour is currently mapped to this promotion -->
                                        <c:set var="isMapped" value="false" />
                                        <c:forEach var="mappedId" items="${mappedTourIds}">
                                            <c:if test="${mappedId == tour.tourId}">
                                                <c:set var="isMapped" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="checkbox" name="tourIds" value="${tour.tourId}" id="tour_${tour.tourId}" ${isMapped ? 'checked' : ''}>
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
                    <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary px-4 rounded-3">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-warning px-4 rounded-3 text-dark fw-semibold">
                        Update Promotion
                    </button>
                </div>
            </form>
        </section>
    </div>

    <jsp:include page="layout/footer.jsp" />