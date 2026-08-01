<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="${not empty tour ? 'Edit Tour' : 'Create New Tour'}" />
    <jsp:param name="activeMenu" value="tours" />
</jsp:include>


<div class="container-fluid p-0">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
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

            <form id="tourForm" method="POST" action="${pageContext.request.contextPath}/admin/tours" enctype="multipart/form-data">
                <input type="hidden" name="action" value="${not empty tour ? 'update' : 'create'}">
                <input type="hidden" name="existingThumbnailUrl" value="${tour.thumbnailUrl}">
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
                        <input type="number" name="durationDays" min="1" class="form-control rounded-3" value="${not empty tour and tour.durationDays > 0 ? tour.durationDays : 1}" required>
                        <small class="text-muted d-block mt-1" style="font-size: 0.75rem;">Set the tour duration in days</small>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label text-muted small fw-bold">Status <span class="text-danger">*</span></label>
                        <select name="status" class="form-select rounded-3" required>
                            <option value="Active" ${tour.status == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${tour.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Starting Price (Base Price)</label>
                        <div class="input-group">
                            <input type="number" name="basePrice" class="form-control rounded-start-3 bg-light" value="<c:if test='${not empty tour and tour.basePrice > 0}'><fmt:formatNumber value='${tour.basePrice}' pattern='0'/></c:if><c:if test='${empty tour or tour.basePrice == 0}'>0</c:if>" readonly tabindex="-1">
                            <span class="input-group-text rounded-end-3 border-start-0 bg-light">VND</span>
                        </div>
                        <small class="text-info d-block mt-1" style="font-size: 0.75rem;"><i class="fa-solid fa-circle-info me-1"></i>Base price is automatically calculated from the lowest price among active schedules in Manage Schedule.</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">Thumbnail Image</label>
                        <input type="file" id="thumbnailFileInput" name="thumbnailFile" class="d-none" accept="image/*">
                        <div class="input-group">
                            <button type="button" class="btn btn-outline-primary rounded-start-3 px-3" onclick="document.getElementById('thumbnailFileInput').click();">
                                <i class="fa-solid fa-folder-open me-2"></i>Choose File
                            </button>
                            <input type="text" id="fileNameDisplay" class="form-control rounded-end-3 bg-white text-muted" value="No file chosen" readonly onclick="document.getElementById('thumbnailFileInput').click();" style="cursor: pointer;">
                        </div>
                        <div id="imagePreviewContainer" class="mt-3 text-center p-2 border rounded-3 bg-light ${empty tour.thumbnailUrl ? 'd-none' : ''}">
                            <c:set var="previewSrc" value="" />
                            <c:if test="${not empty tour.thumbnailUrl}">
                                <c:choose>
                                    <c:when test="${tour.thumbnailUrl.startsWith('http')}">
                                        <c:set var="previewSrc" value="${tour.thumbnailUrl}" />
                                    </c:when>
                                    <c:when test="${tour.thumbnailUrl.startsWith('/')}">
                                        <c:set var="previewSrc" value="${pageContext.request.contextPath}${tour.thumbnailUrl}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="previewSrc" value="${pageContext.request.contextPath}/${tour.thumbnailUrl}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <img id="imagePreview" src="${previewSrc}" alt="Preview" class="img-fluid rounded shadow-sm" style="max-height: 160px;">
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">Description</label>
                        <textarea name="description" class="form-control rounded-3" rows="6" placeholder="Write a captivating description about the tour...">${tour.description}</textarea>
                    </div>

                    <div class="col-12 mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <label class="form-label text-muted small fw-bold mb-0">Day-by-Day Itinerary</label>
                            <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="addItineraryDay()">
                                <i class="fa-solid fa-plus me-1"></i> Add Day
                            </button>
                        </div>
                        <div id="itineraryContainer">
                            <c:choose>
                                <c:when test="${not empty tour.itineraries}">
                                    <c:forEach var="iti" items="${tour.itineraries}">
                                        <div class="itinerary-card card mb-3 border-light shadow-sm">
                                            <div class="card-body position-relative">
                                                <button type="button" class="btn btn-sm btn-danger position-absolute top-0 end-0 m-2 rounded-circle" style="width: 30px; height: 30px; padding: 0;" onclick="this.closest('.itinerary-card').remove()">
                                                    <i class="fa-solid fa-times"></i>
                                                </button>
                                                <div class="row g-2 mb-2 pe-4">
                                                    <div class="col-md-3">
                                                        <input type="number" name="itiDayNumber[]" class="form-control" placeholder="Day (e.g. 1)" value="${iti.dayNumber}" min="1" required>
                                                    </div>
                                                    <div class="col-md-9">
                                                        <input type="text" name="itiTitle[]" class="form-control" placeholder="Title / Location" value="${iti.title}" required>
                                                    </div>
                                                </div>
                                                <textarea name="itiDescription[]" class="form-control" rows="2" placeholder="Description / Activities">${iti.description}</textarea>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="itinerary-card card mb-3 border-light shadow-sm">
                                        <div class="card-body position-relative">
                                            <button type="button" class="btn btn-sm btn-danger position-absolute top-0 end-0 m-2 rounded-circle" style="width: 30px; height: 30px; padding: 0;" onclick="this.closest('.itinerary-card').remove()">
                                                <i class="fa-solid fa-times"></i>
                                            </button>
                                            <div class="row g-2 mb-2 pe-4">
                                                <div class="col-md-3">
                                                    <input type="number" name="itiDayNumber[]" class="form-control" placeholder="Day (e.g. 1)" value="1" min="1" required>
                                                </div>
                                                <div class="col-md-9">
                                                    <input type="text" name="itiTitle[]" class="form-control" placeholder="Title / Location" required>
                                                </div>
                                            </div>
                                            <textarea name="itiDescription[]" class="form-control" rows="2" placeholder="Description / Activities"></textarea>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
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

<jsp:include page="layout/footer.jsp" />
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('thumbnailFileInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            const fileNameDisplay = document.getElementById('fileNameDisplay');
            const previewContainer = document.getElementById('imagePreviewContainer');
            const previewImage = document.getElementById('imagePreview');
            
            if (file) {
                fileNameDisplay.value = file.name;
                fileNameDisplay.classList.remove('text-muted');
                fileNameDisplay.classList.add('text-dark', 'fw-500');
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    previewContainer.classList.remove('d-none');
                };
                reader.readAsDataURL(file);
            } else {
                fileNameDisplay.value = "No file chosen";
                fileNameDisplay.classList.add('text-muted');
                fileNameDisplay.classList.remove('text-dark', 'fw-500');
                
                if (!previewImage.getAttribute('src') || previewImage.getAttribute('src') === window.location.href) {
                    previewContainer.classList.add('d-none');
                }
            }
        });

        document.getElementById('tourForm').addEventListener('submit', function(event) {
            const durationInput = document.querySelector('input[name="durationDays"]');
            const duration = durationInput ? parseInt(durationInput.value) : 1;
            
            const dayInputs = document.querySelectorAll('input[name="itiDayNumber[]"]');
            
            if (dayInputs.length > duration) {
                event.preventDefault();
                alert(`You have added ${dayInputs.length} itinerary days, but the tour duration is only ${duration} days. Please remove excess days or increase the duration.`);
                if (durationInput) durationInput.focus();
                return;
            }
            
            let invalidDay = false;
            dayInputs.forEach(input => {
                const dayVal = parseInt(input.value);
                if (isNaN(dayVal) || dayVal <= 0 || dayVal > duration) {
                    invalidDay = true;
                    input.classList.add('is-invalid');
                } else {
                    input.classList.remove('is-invalid');
                }
            });
            
            if (invalidDay) {
                event.preventDefault();
                alert(`Itinerary day numbers must be strictly positive and cannot exceed the Tour Duration (${duration} days).`);
                return;
            }

        });

        function addItineraryDay() {
            const durationInput = document.querySelector('input[name="durationDays"]');
            const duration = durationInput ? parseInt(durationInput.value) : 1;
            
            const container = document.getElementById('itineraryContainer');
            const dayCount = container.querySelectorAll('.itinerary-card').length;
            
            if (dayCount >= duration) {
                alert(`Cannot add more itinerary days than Tour Duration (${duration} days).`);
                return;
            }
            
            const nextDayNumber = dayCount + 1;
            const cardHtml = `
                <div class="itinerary-card card mb-3 border-light shadow-sm">
                    <div class="card-body position-relative">
                        <button type="button" class="btn btn-sm btn-danger position-absolute top-0 end-0 m-2 rounded-circle" style="width: 30px; height: 30px; padding: 0;" onclick="this.closest('.itinerary-card').remove()">
                            <i class="fa-solid fa-times"></i>
                        </button>
                        <div class="row g-2 mb-2 pe-4">
                            <div class="col-md-3">
                                <input type="number" name="itiDayNumber[]" class="form-control" placeholder="Day (e.g. 1)" value="${nextDayNumber}" min="1" max="${duration}" required>
                            </div>
                            <div class="col-md-9">
                                <input type="text" name="itiTitle[]" class="form-control" placeholder="Title / Location" required>
                            </div>
                        </div>
                        <textarea name="itiDescription[]" class="form-control" rows="2" placeholder="Description / Activities"></textarea>
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', cardHtml);
        }
    </script>



