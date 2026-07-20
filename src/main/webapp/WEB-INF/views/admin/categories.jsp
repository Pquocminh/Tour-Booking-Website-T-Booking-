<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
        <jsp:param name="pageTitle" value="Manage Categories" />
        <jsp:param name="activeMenu" value="categories" />
    </jsp:include>
    


    <!-- Main Content -->
    <main class="container">

        <!-- Notification Alerts -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 rounded-3 mb-4" role="alert" style="background-color: #fef2f2; color: #b91c1c; font-size: 0.9rem;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success border-0 rounded-3 mb-4" role="alert" style="background-color: #f0fdf4; color: #15803d; font-size: 0.9rem;">
                <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <!-- Edit Category Panel (visible only when editing) -->
        <c:if test="${not empty editCategory}">
            <section class="filter-panel">
                <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-pen-to-square me-2 text-primary"></i>Edit Category</h4>
                <form method="POST" action="${pageContext.request.contextPath}/admin/categories">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${editCategory.categoryId}">
                    
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold">Category ID</label>
                            <input type="text" class="form-control rounded-3" value="#${editCategory.categoryId}" readonly disabled>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label text-muted small fw-bold">Category Name <span class="text-danger">*</span></label>
                            <input type="text" name="categoryName" class="form-control rounded-3" value="${editCategory.categoryName}" minlength="3" required placeholder="e.g. Luxury Tours">
                            <div class="form-text text-muted small">Must be at least 3 characters long.</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small fw-bold">Description <span class="text-danger">*</span></label>
                            <textarea name="description" class="form-control rounded-3" rows="3" minlength="3" required placeholder="Briefly describe this category...">${editCategory.description}</textarea>
                            <div class="form-text text-muted small">Must be at least 3 characters long.</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary px-4 rounded-3">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">
                            Save Changes
                        </button>
                    </div>
                </form>
            </section>
        </c:if>

        <!-- Categories Table List -->
        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-tags me-2 text-primary"></i>Categories List</h4>
                <div>
                    <span class="badge bg-primary rounded-pill py-2 px-3 me-2">${categories.size()} Category(ies)</span>
                    <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#createCategoryModal">
                        <i class="fa-solid fa-plus me-1"></i> New Category
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 100px;">ID</th>
                            <th>Category Name</th>
                            <th>Description</th>
                            <th style="width: 250px;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty categories}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                        No categories found in the system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${cat.categoryId}</td>
                                        <td>
                                            <span class="fw-semibold text-dark d-block">${cat.categoryName}</span>
                                        </td>
                                        <td>
                                            <span class="text-muted small">${not empty cat.description ? cat.description : 'No description provided.'}</span>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <button type="button" class="btn btn-outline-info btn-icon shadow-sm" data-bs-toggle="modal" data-bs-target="#viewCategoryModal${cat.categoryId}" title="View Details">
                                                    <i class="fa-solid fa-eye"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.categoryId}"
                                                   class="btn btn-outline-primary btn-icon shadow-sm" title="Edit Category">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>
                                                <form method="POST" action="${pageContext.request.contextPath}/admin/categories" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this category?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${cat.categoryId}">
                                                    <button type="submit" class="btn btn-outline-danger btn-icon shadow-sm" title="Delete Category">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <!-- View Modal -->
                                            <div class="modal fade text-start" id="viewCategoryModal${cat.categoryId}" tabindex="-1" aria-hidden="true">
                                              <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg rounded-4">
                                                  <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold text-primary"><i class="fa-solid fa-tag me-2"></i>Category Details</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                  </div>
                                                  <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="text-muted small fw-bold">Category ID</label>
                                                        <p class="fs-5 fw-semibold text-dark mb-0">#${cat.categoryId}</p>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="text-muted small fw-bold">Category Name</label>
                                                        <p class="fs-5 fw-semibold text-dark mb-0">${cat.categoryName}</p>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="text-muted small fw-bold">Description</label>
                                                        <p class="text-dark mb-0">${not empty cat.description ? cat.description : 'No description provided.'}</p>
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

    <!-- Create Category Modal -->
    <div class="modal fade" id="createCategoryModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
          <form method="POST" action="${pageContext.request.contextPath}/admin/categories">
            <input type="hidden" name="action" value="create">
            <div class="modal-header border-0 pb-0">
              <h5 class="modal-title fw-bold text-primary"><i class="fa-solid fa-folder-plus me-2"></i>Create New Category</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="mb-3">
                  <label class="form-label text-muted small fw-bold">Category Name <span class="text-danger">*</span></label>
                  <input type="text" name="categoryName" class="form-control rounded-3" minlength="3" required placeholder="e.g. Luxury Tours">
                  <div class="form-text text-muted small">Must be at least 3 characters long.</div>
              </div>
              <div class="mb-3">
                  <label class="form-label text-muted small fw-bold">Description <span class="text-danger">*</span></label>
                  <textarea name="description" class="form-control rounded-3" rows="4" minlength="3" required placeholder="Briefly describe this category..."></textarea>
                  <div class="form-text text-muted small">Must be at least 3 characters long.</div>
              </div>
            </div>
            <div class="modal-footer border-0 pt-0">
              <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary rounded-pill px-4">Create Category</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

