<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty tour ? 'Edit Tour' : 'Create New Tour'} | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .form-panel {
            background: #fff;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            margin: 40px auto;
            max-width: 900px;
        }
        .section-title {
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 30px;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title mb-0 border-0 pb-0">
                    <i class="fa-solid ${not empty tour ? 'fa-pen-to-square' : 'fa-folder-plus'} text-primary me-2"></i>
                    ${not empty tour ? 'Edit Tour Package' : 'Create New Tour Package'}
                </h2>
                <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-outline-secondary rounded-pill px-4">
                    <i class="fa-solid fa-arrow-left me-2"></i>Back
                </a>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/admin/tours">
                <input type="hidden" name="action" value="${not empty tour ? 'update' : 'create'}">
                <c:if test="${not empty tour}">
                    <input type="hidden" name="id" value="${tour.tourId}">
                </c:if>

                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label text-muted small fw-bold">Tour Name <span class="text-danger">*</span></label>
                        <input type="text" name="tourName" class="form-control rounded-3" value="${tour.tourName}" required placeholder="e.g. 3 Days 2 Nights in Phu Quoc">
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Category <span class="text-danger">*</span></label>
                        <select name="categoryId" class="form-select rounded-3" required>
                            <option value="">Select Category</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${tour.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Destination <span class="text-danger">*</span></label>
                        <select name="destinationId" class="form-select rounded-3" required>
                            <option value="">Select Destination</option>
                            <c:forEach var="d" items="${destinations}">
                                <option value="${d.destinationId}" ${tour.destinationId == d.destinationId ? 'selected' : ''}>${d.destinationName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Departure Location <span class="text-danger">*</span></label>
                        <input type="text" name="departureLocation" class="form-control rounded-3" value="${tour.departureLocation}" required placeholder="e.g. Ho Chi Minh City">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Duration (Days) <span class="text-danger">*</span></label>
                        <input type="number" name="durationDays" class="form-control rounded-3" value="${tour.durationDays}" min="1" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Status <span class="text-danger">*</span></label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" ${tour.status == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${tour.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Base Price (VND) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="number" name="basePrice" class="form-control rounded-start-3" value="${tour.basePrice}" step="0.01" min="0" required>
                            <span class="input-group-text rounded-end-3 border-start-0">VND</span>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Thumbnail URL</label>
                        <input type="text" name="thumbnailUrl" class="form-control rounded-3" value="${tour.thumbnailUrl}" placeholder="/assets/images/tour1.jpg">
                    </div>

                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Description</label>
                        <textarea name="description" class="form-control rounded-3" rows="6" placeholder="Write a captivating description about the tour...">${tour.description}</textarea>
                    </div>
                </div>

                <div class="mt-5 text-end border-top pt-4">
                    <a href="${pageContext.request.contextPath}/admin/tours" class="btn btn-outline-secondary px-5 rounded-pill me-2">Cancel</a>
                    <button type="submit" class="btn btn-primary px-5 rounded-pill shadow-sm">
                        <i class="fa-solid fa-save me-2"></i>${not empty tour ? 'Save Changes' : 'Create Tour'}
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
