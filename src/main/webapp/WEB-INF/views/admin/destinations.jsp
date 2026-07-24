<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Destinations" />
    <jsp:param name="activeMenu" value="destinations" />
</jsp:include>

    <!-- Main Content -->
    <main class="container">

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

        <!-- Edit Destination Panel (visible only when editing) -->
        <c:if test="${not empty editDestination}">
            <section class="filter-panel mb-4 p-4 rounded-4 bg-white shadow-sm">
                <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-pen-to-square me-2 text-primary"></i>Edit Destination</h4>
                <form method="POST" action="${pageContext.request.contextPath}/admin/destinations">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${editDestination.destinationId}">
                    
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label text-muted small fw-bold">Destination ID</label>
                            <input type="text" class="form-control rounded-3" value="#${editDestination.destinationId}" readonly disabled>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label text-muted small fw-bold">Destination Name <span class="text-danger">*</span></label>
                            <input type="text" name="destinationName" class="form-control rounded-3" value="${editDestination.destinationName}" minlength="2" required placeholder="e.g. Da Nang Beach">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold">Province <span class="text-danger">*</span></label>
                            <input type="text" name="province" class="form-control rounded-3" value="${editDestination.province}" required placeholder="e.g. Da Nang">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold">Region <span class="text-danger">*</span></label>
                            <select name="region" class="form-select rounded-3" required>
                                <option value="North" ${editDestination.region == 'North' ? 'selected' : ''}>North</option>
                                <option value="Central" ${editDestination.region == 'Central' ? 'selected' : ''}>Central</option>
                                <option value="South" ${editDestination.region == 'South' ? 'selected' : ''}>South</option>
                                <option value="International" ${editDestination.region == 'International' ? 'selected' : ''}>International</option>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label text-muted small fw-bold">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control rounded-3" value="${editDestination.imageUrl}" placeholder="https://example.com/image.jpg">
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small fw-bold">Description</label>
                            <textarea name="description" class="form-control rounded-3" rows="3" placeholder="Briefly describe this destination...">${editDestination.description}</textarea>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/destinations" class="btn btn-outline-secondary px-4 rounded-3">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">
                            Save Changes
                        </button>
                    </div>
                </form>
            </section>
        </c:if>

        <!-- Destinations Table List -->
        <section class="table-panel p-4 rounded-4 bg-white shadow-sm">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h4 class="mb-1 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-location-dot me-2 text-primary"></i>Destinations List</h4>
                    <span class="badge bg-primary rounded-pill py-2 px-3">${destinations.size()} Destination(s)</span>
                </div>

                <div class="d-flex gap-2 align-items-center">
                    <!-- Search Form -->
                    <form method="GET" action="${pageContext.request.contextPath}/admin/destinations" class="d-flex me-2">
                        <div class="input-group">
                            <input type="text" name="search" class="form-control rounded-start-pill" placeholder="Search destination..." value="${searchKeyword}">
                            <button type="submit" class="btn btn-outline-primary rounded-end-pill px-3">
                                <i class="fa-solid fa-search"></i>
                            </button>
                        </div>
                    </form>

                    <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#createDestinationModal">
                        <i class="fa-solid fa-plus me-1"></i> New Destination
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">ID</th>
                            <th style="width: 100px;">Image</th>
                            <th>Destination Name</th>
                            <th>Province</th>
                            <th>Region</th>
                            <th>Description</th>
                            <th style="width: 200px;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty destinations}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                        No destinations found in the system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="dest" items="${destinations}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${dest.destinationId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty dest.imageUrl}">
                                                    <img src="${dest.imageUrl}" alt="${dest.destinationName}" class="rounded-3 shadow-sm" style="width: 60px; height: 45px; object-fit: cover;" onerror="this.src='https://placehold.co/60x45?text=No+Image'">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-light rounded-3 d-flex align-items-center justify-content-center text-muted" style="width: 60px; height: 45px; font-size: 0.75rem;">
                                                        No Image
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark d-block">${dest.destinationName}</span>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border px-2 py-1 rounded-2">${dest.province}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dest.region == 'Miền Bắc' || dest.region == 'North'}">
                                                    <span class="badge bg-success text-white rounded-pill px-3 py-1">North</span>
                                                </c:when>
                                                <c:when test="${dest.region == 'Miền Trung' || dest.region == 'Central'}">
                                                    <span class="badge bg-success text-white rounded-pill px-3 py-1">Central</span>
                                                </c:when>
                                                <c:when test="${dest.region == 'Miền Nam' || dest.region == 'South'}">
                                                    <span class="badge bg-success text-white rounded-pill px-3 py-1">South</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success text-white rounded-pill px-3 py-1">${dest.region}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="text-muted small d-inline-block text-truncate" style="max-width: 250px;">
                                                ${not empty dest.description ? dest.description : 'No description provided.'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <button type="button" class="btn btn-outline-info btn-sm btn-icon shadow-sm" data-bs-toggle="modal" data-bs-target="#viewDestinationModal${dest.destinationId}" title="View Details">
                                                    <i class="fa-solid fa-eye"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/destinations?action=edit&id=${dest.destinationId}"
                                                   class="btn btn-outline-primary btn-sm btn-icon shadow-sm" title="Edit Destination">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/destinations" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this destination?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${dest.destinationId}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm btn-icon shadow-sm" title="Delete Destination">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <!-- View Modal -->
                                            <div class="modal fade text-start" id="viewDestinationModal${dest.destinationId}" tabindex="-1" aria-hidden="true">
                                              <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg rounded-4">
                                                  <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold text-primary"><i class="fa-solid fa-location-dot me-2"></i>Destination Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                  </div>
                                                  <div class="modal-body">
                                                    <c:if test="${not empty dest.imageUrl}">
                                                        <img src="${dest.imageUrl}" alt="${dest.destinationName}" class="w-100 rounded-3 mb-3 shadow-sm" style="max-height: 200px; object-fit: cover;" onerror="this.src='https://placehold.co/600x300?text=No+Image'">
                                                    </c:if>
                                                    <div class="mb-2">
                                                        <label class="text-muted small fw-bold">Destination ID</label>
                                                        <p class="fs-6 fw-semibold text-dark mb-0">#${dest.destinationId}</p>
                                                    </div>
                                                    <div class="mb-2">
                                                        <label class="text-muted small fw-bold">Destination Name</label>
                                                        <p class="fs-5 fw-bold text-primary mb-0">${dest.destinationName}</p>
                                                    </div>
                                                    <div class="row mb-2">
                                                        <div class="col-6">
                                                            <label class="text-muted small fw-bold">Province</label>
                                                            <p class="fw-semibold text-dark mb-0">${dest.province}</p>
                                                        </div>
                                                        <div class="col-6">
                                                            <label class="text-muted small fw-bold">Region</label>
                                                            <p class="fw-semibold text-dark mb-0">
                                                                <c:choose>
                                                                    <c:when test="${dest.region == 'Miền Bắc' || dest.region == 'North'}">North</c:when>
                                                                    <c:when test="${dest.region == 'Miền Trung' || dest.region == 'Central'}">Central</c:when>
                                                                    <c:when test="${dest.region == 'Miền Nam' || dest.region == 'South'}">South</c:when>
                                                                    <c:otherwise>${dest.region}</c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="mb-2">
                                                        <label class="text-muted small fw-bold">Description</label>
                                                        <p class="text-dark mb-0">${not empty dest.description ? dest.description : 'No description provided.'}</p>
                                                    </div>
                                                  </div>
                                                  <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                                                  </div>
                                                </div>
                                              </div>
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
    </main>

    <!-- Create Destination Modal -->
    <div class="modal fade" id="createDestinationModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4">
          <form method="POST" action="${pageContext.request.contextPath}/admin/destinations">
            <input type="hidden" name="action" value="create">
            <div class="modal-header border-0 pb-0">
              <h5 class="modal-title fw-bold text-primary"><i class="fa-solid fa-map-location-dot me-2"></i>Create New Destination</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="row g-3">
                  <div class="col-md-6">
                      <label class="form-label text-muted small fw-bold">Destination Name <span class="text-danger">*</span></label>
                      <input type="text" name="destinationName" class="form-control rounded-3" minlength="2" required placeholder="e.g. Ha Long Bay">
                  </div>
                  <div class="col-md-6">
                      <label class="form-label text-muted small fw-bold">Province <span class="text-danger">*</span></label>
                      <input type="text" name="province" class="form-control rounded-3" required placeholder="e.g. Quang Ninh">
                  </div>
                  <div class="col-md-6">
                      <label class="form-label text-muted small fw-bold">Region <span class="text-danger">*</span></label>
                      <select name="region" class="form-select rounded-3" required>
                          <option value="">-- Select Region --</option>
                          <option value="North">North</option>
                          <option value="Central">Central</option>
                          <option value="South">South</option>
                          <option value="International">International</option>
                      </select>
                  </div>
                  <div class="col-md-6">
                      <label class="form-label text-muted small fw-bold">Image URL</label>
                      <input type="url" name="imageUrl" class="form-control rounded-3" placeholder="https://example.com/image.jpg">
                  </div>
                  <div class="col-12">
                      <label class="form-label text-muted small fw-bold">Description</label>
                      <textarea name="description" class="form-control rounded-3" rows="4" placeholder="Briefly describe this destination..."></textarea>
                  </div>
              </div>
            </div>
            <div class="modal-footer border-0 pt-0">
              <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary rounded-pill px-4">Create Destination</button>
            </div>
          </form>
        </div>
      </div>
    </div>

<jsp:include page="layout/footer.jsp" />
