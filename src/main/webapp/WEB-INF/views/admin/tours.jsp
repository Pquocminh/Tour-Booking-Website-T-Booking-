<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Tours" />
    <jsp:param name="activeMenu" value="tours" />
</jsp:include>


<!-- Main Content -->
<div class="container-fluid p-0">

        <!-- Search & Filters Panel -->
        <section class="filter-panel">
            <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Search & Filters</h4>
            <form method="GET" action="${pageContext.request.contextPath}/admin/tours">
                <div class="row g-3">
                    <!-- Keyword search -->
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Keyword Search</label>
                        <input type="text" name="search" class="form-control rounded-3" placeholder="Name, desc..." value="${not empty searchKeyword ? searchKeyword : ''}">
                    </div>
                    
                    <!-- Status Filter -->
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Status</label>
                        <select name="status" class="form-select rounded-3">
                            <option value="All" ${selectedStatus == 'All' ? 'selected' : ''}>All Statuses</option>
                            <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${selectedStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <!-- Category Filter -->
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Category</label>
                        <select name="category" class="form-select rounded-3">
                            <option value="">All Categories</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${selectedCategory == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Destination Filter -->
                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Destination</label>
                        <select name="destination" class="form-select rounded-3">
                            <option value="">All Destinations</option>
                            <c:forEach var="d" items="${destinations}">
                                <option value="${d.destinationId}" ${selectedDestination == d.destinationId ? 'selected' : ''}>${d.destinationName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-outline-secondary px-4 rounded-3">
                        Clear
                    </a>
                    <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">
                        Filter
                    </button>
                </div>
            </form>
        </section>

        <!-- Tours Table List -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-list me-2 text-primary"></i>Tours List</h4>
                <div>
                    <span class="badge bg-primary rounded-pill py-2 px-3 me-2">${tours.size()} Package(s)</span>
                    <a href="${pageContext.request.contextPath}/admin/tours?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="fa-solid fa-plus me-1"></i> New Tour
                    </a>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 100px;">Thumbnail</th>
                            <th>Tour ID & Name</th>
                            <th>Category</th>
                            <th>Destination</th>
                            <th>Departure</th>
                            <th>Price</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th class="text-center" style="width: 250px;">Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${empty tours}">
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                        No tours found matching the selected search criteria.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${tours}">
                                    <tr>
                                        <td>
                                            <img src="${not empty t.thumbnailUrl ? pageContext.request.contextPath.concat(t.thumbnailUrl) : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=100&auto=format&fit=crop'}" 
                                                 alt="Tour Thumbnail" 
                                                 class="tour-thumbnail"
                                                 onerror="this.src='https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=100&auto=format&fit=crop'">
                                        </td>
                                        <td>
                                            <span class="text-muted small d-block">ID: #${t.tourId}</span>
                                            <span class="fw-semibold text-dark d-block" title="${t.tourName}">${t.tourName}</span>
                                        </td>
                                        <td><span class="badge bg-light text-primary border border-primary">${t.category.categoryName}</span></td>
                                        <td>${t.destination.destinationName}</td>
                                        <td>${t.departureLocation}</td>
                                        <td class="fw-bold text-primary">
                                            <fmt:formatNumber value="${t.basePrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td>${t.durationDays} Days</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${'Active'.equalsIgnoreCase(t.status)}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/admin/tours?action=view&id=${t.tourId}" class="btn btn-outline-info btn-sm rounded-pill px-2 me-1" title="View Details">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/tours?action=edit&id=${t.tourId}" class="btn btn-outline-primary btn-sm rounded-pill px-2 me-1" title="Edit Tour">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/capacity?tourId=${t.tourId}" class="btn btn-outline-secondary btn-sm rounded-pill px-2 me-1" title="Schedules">
                                                <i class="fa-solid fa-calendar-days"></i>
                                            </a>
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/tours" class="d-inline" onsubmit="return confirm('Are you sure you want to mark this tour as Inactive?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${t.tourId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Delete (Inactive)">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
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

