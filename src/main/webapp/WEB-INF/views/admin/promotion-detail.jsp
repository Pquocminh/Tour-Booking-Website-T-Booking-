<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Promotion Details" />
    <jsp:param name="activeMenu" value="promotions" />
</jsp:include>

<!-- Main Content -->
<div class="container-fluid p-0">

        <!-- Back Button -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/promotions" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-2"></i>Back to Promotions
            </a>
        </div>

        <!-- Notification Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Promotion Main Info Card -->
        <section class="detail-panel">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-percent me-2 text-primary"></i>General Information</h4>
                <c:choose>
                    <c:when test="${'Active'.equalsIgnoreCase(promotion.status)}">
                        <span class="badge bg-success-subtle text-success border border-success px-4 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger-subtle text-danger border border-danger px-4 py-2 rounded-pill"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="row g-4">
                <div class="col-md-3">
                    <span class="info-label d-block mb-1">Promotion ID</span>
                    <span class="info-value">#${promotion.promotionId}</span>
                </div>
                <div class="col-md-5">
                    <span class="info-label d-block mb-1">Promotion Name</span>
                    <span class="info-value text-dark fw-semibold">${promotion.promotionName}</span>
                </div>
                <div class="col-md-4">
                    <span class="info-label d-block mb-1">Discount Rate</span>
                    <span class="info-value text-primary fw-bold" style="font-size: 1.3rem;">${promotion.discountPercent}% OFF</span>
                </div>
                <div class="col-md-6 border-top pt-3">
                    <span class="info-label d-block mb-1"><i class="fa-regular fa-calendar-check me-1"></i>Start Date</span>
                    <span class="info-value"><fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd" /></span>
                </div>
                <div class="col-md-6 border-top pt-3">
                    <span class="info-label d-block mb-1"><i class="fa-regular fa-calendar-xmark me-1"></i>End Date</span>
                    <span class="info-value"><fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd" /></span>
                </div>
            </div>
        </section>

        <!-- Applying Tours Section -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-plane-departure me-2 text-primary"></i>Applied Tours</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${tours.size()} Tour(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 100px;">Tour ID</th>
                            <th>Tour Name</th>
                            <th>Category</th>
                            <th>Destination</th>
                            <th>Duration</th>
                            <th>Base Price</th>
                            <th style="width: 120px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty tours}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-circle-info display-4 mb-3 d-block text-secondary"></i>
                                        This promotion is not applied to any tour package.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="tour" items="${tours}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${tour.tourId}</td>
                                        <td class="fw-semibold text-dark">${tour.tourName}</td>
                                        <td><span class="badge bg-light text-primary border border-primary">${tour.category.categoryName}</span></td>
                                        <td>${tour.destination.destinationName}</td>
                                        <td>${tour.durationDays} Days</td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Active'.equalsIgnoreCase(tour.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-1 rounded-pill">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
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