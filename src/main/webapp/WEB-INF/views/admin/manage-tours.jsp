<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tours | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- Custom Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .tour-thumbnail {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/tours">Tours</a>
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
                                <ul class="dropdown-menu dropdown-menu-end border-0 shadow mt-2" aria-labelledby="navbarDropdown" style="border-radius: 12px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);">
                                    <li><span class="dropdown-item-text text-muted" style="font-size: 0.8rem;">Role: ${sessionScope.user.role}</span></li>
                                    <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/tours"><i class="fa-solid fa-user-gear me-2 text-primary"></i>Manage Tours</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2 text-primary"></i>Manage Categories</a></li>
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
            <h1 class="hero-title">Tour <span>Management</span></h1>
            <p class="hero-subtitle">Search, filter and inspect available tour packages in the system</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">

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
                <span class="badge bg-primary rounded-pill py-2 px-3">${tours.size()} Package(s)</span>
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
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty tours}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
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
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="text-center p-4 border-top border-secondary text-muted" style="background: rgba(15, 23, 42, 0.95); margin-top: 50px;">
        &copy; 2026 T-Booking Dashboard. All rights reserved.
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
