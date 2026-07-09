<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Tour Details" />
    <jsp:param name="activeMenu" value="tours" />
</jsp:include>


<div class="container-fluid p-0">
        <div class="detail-panel">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                <h2 class="mb-0 fw-bold text-dark">
                    <i class="fa-solid fa-map-location-dot text-primary me-2"></i>
                    Tour Package Details
                </h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/tours?action=edit&id=${tour.tourId}" class="btn btn-primary rounded-pill px-4 me-2">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Edit
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-outline-secondary rounded-pill px-4">
                        <i class="fa-solid fa-arrow-left me-2"></i>Back
                    </a>
                </div>
            </div>

            <c:if test="${not empty tour}">
                <!-- Cover Image -->
                <img src="${not empty tour.thumbnailUrl ? pageContext.request.contextPath.concat(tour.thumbnailUrl) : 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=1200&auto=format&fit=crop'}" 
                     alt="Cover" class="cover-img shadow-sm"
                     onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=1200&auto=format&fit=crop'">

                <div class="row g-4">
                    <div class="col-md-12">
                        <div class="info-label">Tour Name</div>
                        <div class="fs-4 fw-bold text-primary">${tour.tourName}</div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="info-label">Category</div>
                        <div class="info-value"><span class="badge bg-light text-primary border border-primary">${tour.category.categoryName}</span></div>
                    </div>

                    <div class="col-md-6">
                        <div class="info-label">Destination</div>
                        <div class="info-value"><i class="fa-solid fa-location-dot text-danger me-2"></i>${tour.destination.destinationName}</div>
                    </div>

                    <div class="col-md-4">
                        <div class="info-label">Departure Location</div>
                        <div class="info-value">${tour.departureLocation}</div>
                    </div>

                    <div class="col-md-4">
                        <div class="info-label">Duration</div>
                        <div class="info-value"><i class="fa-regular fa-clock text-warning me-2"></i>${tour.durationDays} Days</div>
                    </div>

                    <div class="col-md-4">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${'Active'.equalsIgnoreCase(tour.status)}">
                                    <span class="text-success fw-bold"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-bold"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <div class="info-label">Base Price</div>
                        <div class="fs-4 fw-bold text-success">
                            <fmt:formatNumber value="${tour.basePrice}" type="currency" currencySymbol="VND " maxFractionDigits="0"/>
                        </div>
                    </div>

                    <div class="col-12 mt-4">
                        <div class="info-label mb-2">Description</div>
                        <div class="p-4 bg-light rounded-4" style="line-height: 1.8; color: #4b5563;">
                            ${tour.description}
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty tour}">
                <div class="alert alert-danger">Tour not found!</div>
            </c:if>
        </div>
    </div>
    </div>

<jsp:include page="layout/footer.jsp" />

