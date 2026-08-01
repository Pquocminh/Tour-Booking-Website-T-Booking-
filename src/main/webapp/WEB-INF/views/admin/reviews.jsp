<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Reviews" />
    <jsp:param name="activeMenu" value="reviews" />
</jsp:include>


<div class="container-fluid p-0">

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <section class="table-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-star me-2 text-warning"></i>Customer Reviews List</h4>
                <span class="badge bg-primary rounded-pill py-2 px-3">${not empty totalReviews ? totalReviews : reviews.size()} Review(s)</span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width: 15%;">Customer & Tour</th>
                            <th style="width: 10%;">Rating</th>
                            <th style="width: 25%;">Customer Review</th>
                            <th style="width: 25%;">Staff Response</th>
                            <th style="width: 10%;">Date</th>
                            <th style="width: 15%;" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="fa-regular fa-comment-dots display-4 mb-3 d-block text-secondary"></i>
                                        No reviews found in the system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${reviews}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-primary mb-1">${r.customerName}</div>
                                            <div class="text-muted small"><i class="fa-solid fa-map-location-dot me-1"></i>${r.tourName}</div>
                                            <div class="text-muted small"><i class="fa-solid fa-hashtag me-1"></i>Booking #${r.bookingId}</div>
                                            <div class="text-muted small mt-1 border-top pt-1"><i class="fa-solid fa-plane-departure me-1"></i>Departure: <strong><fmt:formatDate value="${r.departureDate}" pattern="dd/MM/yyyy"/></strong></div>
                                        </td>
                                        <td>
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fa-solid fa-star ${i <= r.rating ? 'text-warning' : 'text-light'}"></i>
                                                </c:forEach>
                                            </div>
                                            <span class="badge ${r.rating >= 4 ? 'bg-success' : (r.rating == 3 ? 'bg-warning' : 'bg-danger')} mt-1">
                                                ${r.rating}/5
                                            </span>
                                        </td>
                                        <td>
                                            <div class="comment-box">
                                                ${r.comment}
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r.staffResponse}">
                                                    <div class="response-box">
                                                        <div class="fw-bold text-primary mb-1" style="font-size: 0.75rem;"><i class="fa-solid fa-reply me-1"></i>Our Response:</div>
                                                        ${r.staffResponse}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small fst-italic">No response yet.</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="small fw-bold"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/></div>
                                            <div class="small text-muted"><fmt:formatDate value="${r.createdAt}" pattern="HH:mm"/></div>
                                        </td>
                                        <td class="text-center">
                                            <!-- Respond Button -->
                                            <button class="btn btn-outline-primary btn-sm rounded-pill px-3 me-1 mb-1" 
                                                    data-bs-toggle="modal" data-bs-target="#respondModal${r.reviewId}">
                                                <i class="fa-solid fa-reply me-1"></i>Reply
                                            </button>

                                            <!-- Toggle Status Button -->
                                            <c:choose>
                                                <c:when test="${'VISIBLE'.equalsIgnoreCase(r.status) || 'APPROVED'.equalsIgnoreCase(r.status)}">
                                                    <button type="button" class="btn btn-success btn-sm rounded-pill px-3 mb-1 toggle-btn" title="Click to Hide" data-bs-toggle="modal" data-bs-target="#toggleModal${r.reviewId}">
                                                        <i class="fa-solid fa-eye me-1"></i>Visible
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-secondary btn-sm rounded-pill px-3 mb-1 toggle-btn" title="Click to Show" data-bs-toggle="modal" data-bs-target="#toggleModal${r.reviewId}">
                                                        <i class="fa-solid fa-eye-slash me-1"></i>Hidden
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Toggle Confirmation Modal -->
                                            <div class="modal fade text-start" id="toggleModal${r.reviewId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered modal-sm">
                                                    <div class="modal-content rounded-4 border-0 shadow">
                                                        <div class="modal-header border-bottom-0 pb-0">
                                                            <h5 class="modal-title fw-bold text-dark">Confirm Action</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body text-center py-3">
                                                            <c:choose>
                                                                <c:when test="${'VISIBLE'.equalsIgnoreCase(r.status) || 'APPROVED'.equalsIgnoreCase(r.status)}">
                                                                    <i class="fa-solid fa-eye-slash text-warning display-4 mb-3 d-block"></i>
                                                                    <p class="mb-0">Hide this review from public view?</p>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fa-solid fa-eye text-success display-4 mb-3 d-block"></i>
                                                                    <p class="mb-0">Show this review to public view?</p>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="modal-footer border-top-0 pt-0 justify-content-center">
                                                            <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                                                            <form method="POST" action="${pageContext.request.contextPath}/admin/staff/reviews" class="d-inline">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <input type="hidden" name="currentStatus" value="${r.status}">
                                                                <input type="hidden" name="page" value="${currentPage}">
                                                                <button type="submit" class="btn ${('VISIBLE'.equalsIgnoreCase(r.status) || 'APPROVED'.equalsIgnoreCase(r.status)) ? 'btn-warning text-white' : 'btn-success'} rounded-pill px-4">
                                                                    Confirm
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Respond Modal -->
                                            <div class="modal fade text-start" id="respondModal${r.reviewId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content rounded-4 border-0 shadow">
                                                        <div class="modal-header border-bottom-0 pb-0">
                                                            <h5 class="modal-title fw-bold text-primary">Respond to Review</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/staff/reviews">
                                                            <div class="modal-body">
                                                                <input type="hidden" name="action" value="respond">
                                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                <input type="hidden" name="page" value="${currentPage}">
                                                                
                                                                <div class="bg-light p-3 rounded-3 mb-3">
                                                                    <div class="fw-bold text-dark">${r.customerName}</div>
                                                                    <div class="star-rating mb-2">
                                                                        <c:forEach begin="1" end="5" var="i">
                                                                            <i class="fa-solid fa-star ${i <= r.rating ? 'text-warning' : 'text-muted'}"></i>
                                                                        </c:forEach>
                                                                    </div>
                                                                    <div class="fst-italic text-secondary">"${r.comment}"</div>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-muted small">Your Response</label>
                                                                    <textarea name="response" class="form-control rounded-3" rows="4" required placeholder="Write a polite response...">${r.staffResponse}</textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer border-top-0 pt-0">
                                                                <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">Save Response</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- End Modal -->
                                            
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination Bar matching reference design -->
            <c:if test="${not empty totalPages and totalPages >= 1}">
                <nav aria-label="Reviews list pagination" class="d-flex justify-content-center mt-4">
                    <ul class="pagination custom-pagination mb-0" style="display: flex !important; list-style: none !important; padding-left: 0 !important; margin: 0 !important;">
                        <!-- Previous Button -->
                        <c:choose>
                            <c:when test="${currentPage <= 1}">
                                <li class="page-item disabled" style="list-style: none !important;">
                                    <a class="page-link" href="javascript:void(0);" tabindex="-1" aria-disabled="true">Previous</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item" style="list-style: none !important;">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/staff/reviews?page=${currentPage - 1}">Previous</a>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page Numbers -->
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${currentPage == i}">
                                    <li class="page-item active" style="list-style: none !important;">
                                        <a class="page-link" href="javascript:void(0);">${i}</a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item" style="list-style: none !important;">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/staff/reviews?page=${i}">${i}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next Button -->
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">
                                <li class="page-item disabled" style="list-style: none !important;">
                                    <a class="page-link" href="javascript:void(0);" tabindex="-1" aria-disabled="true">Next</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item" style="list-style: none !important;">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/staff/reviews?page=${currentPage + 1}">Next</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </c:if>
        </section>
    </div>
    </div>

<jsp:include page="layout/footer.jsp" />

