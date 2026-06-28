<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .hero-section {
            padding: 80px 0 50px 0;
            text-align: center;
        }
        .filter-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }
        .table-panel {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0, 0, 0, 0.08);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            margin-bottom: 50px;
        }
        .table-custom th {
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/tours">
                <i class="fa-solid fa-plane-departure me-2"></i>T-Booking
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tours">Tours</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">About Us</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contact</a>
                    </li>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item dropdown ms-lg-3">
                                <a class="nav-link dropdown-toggle btn btn-outline-primary rounded-pill px-4 py-2" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fa-regular fa-user me-1"></i>Hi, ${sessionScope.user.fullName}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="max-height: 380px; overflow-y: auto; border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-id-card me-2 text-primary"></i>My Profile</a></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/capacity"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Capacity</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/schedules"><i class="fa-solid fa-calendar-days me-2 text-primary"></i>Manage Schedules</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/promotions"><i class="fa-solid fa-percent me-2 text-primary"></i>Manage Promotions</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/discount-policies"><i class="fa-solid fa-hand-holding-dollar me-2 text-primary"></i>Discount Policies</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item ms-lg-3">
                                <a class="btn btn-outline-primary rounded-pill px-4" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Dashboard Header Banner -->
    <header class="hero-section">
        <div class="container">
            <h1 class="hero-title">Category <span>Management</span></h1>
            <p class="hero-subtitle">View and update tour categories in the system</p>
        </div>
    </header>

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
                            <label class="form-label text-muted small fw-bold">Category Name</label>
                            <input type="text" name="categoryName" class="form-control rounded-3" value="${editCategory.categoryName}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small fw-bold">Description</label>
                            <textarea name="description" class="form-control rounded-3" rows="3">${editCategory.description}</textarea>
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
                                            <button type="button" class="btn btn-sm btn-outline-info rounded-pill px-3 me-1" 
                                                    data-bs-toggle="modal" data-bs-target="#viewCategoryModal${cat.categoryId}">
                                                <i class="fa-solid fa-eye me-1"></i>View
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.categoryId}" 
                                               class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                                <i class="fa-solid fa-pen-to-square me-1"></i>Edit
                                            </a>
                                            <form method="POST" action="${pageContext.request.contextPath}/admin/categories" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this category?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${cat.categoryId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                                    <i class="fa-solid fa-trash me-1"></i>Delete
                                                </button>
                                            </form>

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
                  <input type="text" name="categoryName" class="form-control rounded-3" required placeholder="e.g. Luxury Tours">
              </div>
              <div class="mb-3">
                  <label class="form-label text-muted small fw-bold">Description</label>
                  <textarea name="description" class="form-control rounded-3" rows="4" placeholder="Briefly describe this category..."></textarea>
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

    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 50px;">
        &copy; 2026 T-Booking Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
