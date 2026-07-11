<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Account Details" />
    <jsp:param name="activeMenu" value="accounts" />
</jsp:include>

<style>
    .details-card {
        background: white;
        border-radius: 24px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        margin-bottom: 30px;
    }
    .profile-header {
        display: flex;
        align-items: center;
        gap: 25px;
        border-bottom: 1px solid #f1f5f9;
        padding-bottom: 25px;
        margin-bottom: 30px;
    }
    .profile-avatar {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 50%;
        border: 4px solid var(--primary-blue);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    .info-label {
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        color: #64748b;
        margin-bottom: 5px;
    }
    .info-value {
        font-size: 1rem;
        font-weight: 600;
        color: #1e293b;
        background: #f8fafc;
        padding: 12px 18px;
        border-radius: 12px;
        border: 1px solid #f1f5f9;
    }
</style>

<div class="container-fluid p-0">
    <div class="d-flex align-items-center mb-4">
        <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-outline-secondary btn-sm rounded-pill me-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Back to Accounts List
        </a>
        <h3 class="mb-0 fw-bold" style="color: var(--text-main);">Account Profile Details</h3>
    </div>

    <div class="details-card">
        <!-- Profile Header section -->
        <div class="profile-header">
            <img src="https://ui-avatars.com/api/?name=${account.username}&background=random&size=200" alt="Avatar" class="profile-avatar">
            <div>
                <h4 class="fw-bold mb-1 text-dark">${account.fullName}</h4>
                <p class="text-muted mb-2">@${account.username}</p>
                <div class="d-flex gap-2">
                    <c:choose>
                        <c:when test="${'Admin'.equalsIgnoreCase(account.role)}">
                            <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-user-shield me-1"></i>Admin</span>
                        </c:when>
                        <c:when test="${'Staff'.equalsIgnoreCase(account.role)}">
                            <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill"><i class="fa-solid fa-user-tie me-1"></i>Staff</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-info-subtle text-info border border-info px-3 py-2 rounded-pill"><i class="fa-solid fa-user me-1"></i>Customer</span>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${'Active'.equalsIgnoreCase(account.status)}">
                            <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                        </c:when>
                        <c:when test="${'Inactive'.equalsIgnoreCase(account.status)}">
                            <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-ban me-1"></i>${account.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Profile Information Grid -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="info-label">Account ID</div>
                <div class="info-value">#${account.accountId}</div>
            </div>
            <div class="col-md-6">
                <div class="info-label">Username</div>
                <div class="info-value">${account.username}</div>
            </div>
            <div class="col-md-6">
                <div class="info-label">Email Address</div>
                <div class="info-value"><i class="fa-regular fa-envelope me-2 text-primary"></i>${account.email}</div>
            </div>
            <div class="col-md-6">
                <div class="info-label">Phone Number</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty account.phone}">
                            <i class="fa-solid fa-phone me-2 text-primary"></i>${account.phone}
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted font-italic">Not provided</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-12">
                <div class="info-label">Residential Address</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty account.address}">
                            <i class="fa-solid fa-location-dot me-2 text-primary"></i>${account.address}
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted font-italic">Not provided</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-label">Created Date</div>
                <div class="info-value">
                    <i class="fa-regular fa-calendar-plus me-2 text-primary"></i>
                    <fmt:formatDate value="${account.createdAt}" pattern="dd MMMM yyyy, HH:mm"/>
                </div>
            </div>
            <div class="col-md-6">
                <div class="info-label">Last Login</div>
                <div class="info-value">
                    <i class="fa-solid fa-arrow-right-to-bracket me-2 text-primary"></i>
                    <c:choose>
                        <c:when test="${not empty account.lastLogin}">
                            <fmt:formatDate value="${account.lastLogin}" pattern="dd MMMM yyyy, HH:mm"/>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted font-italic">Never logged in</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />
