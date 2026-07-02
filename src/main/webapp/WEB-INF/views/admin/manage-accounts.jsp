<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Accounts" />
    <jsp:param name="activeMenu" value="accounts" />
</jsp:include>
<style>
    .user-avatar {
        width: 45px;
        height: 45px;
        object-fit: cover;
        border-radius: 50%;
        border: 2px solid var(--primary-blue);
    }
    .filter-panel, .table-panel {
        background: white;
        border-radius: 24px;
        padding: 25px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        margin-bottom: 30px;
    }
    .table-custom { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
    .table-custom th { color: #64748b; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; padding: 0 15px 10px; border-bottom: 1px solid #f1f5f9; }
    .table-custom td { padding: 15px; background: #f8fafc; font-size: 0.9rem; font-weight: 600; color: #1e293b; }
    .table-custom td:first-child { border-radius: 12px 0 0 12px; }
    .table-custom td:last-child { border-radius: 0 12px 12px 0; }
</style>

<!-- Main Content -->
<div class="container-fluid p-0">

    <!-- Search & Filters Panel -->
    <section class="filter-panel">
        <h4 class="mb-4 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i>Search & Filters</h4>
        <form method="GET" action="${pageContext.request.contextPath}/admin/accounts">
            <div class="row g-3">
                <!-- Keyword search -->
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Keyword Search</label>
                    <input type="text" name="search" class="form-control rounded-3" placeholder="Username, email, name, phone..." value="${not empty searchKeyword ? searchKeyword : ''}">
                </div>
                
                <!-- Role Filter -->
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Role</label>
                    <select name="role" class="form-select rounded-3">
                        <option value="All" ${selectedRole == 'All' ? 'selected' : ''}>All Roles</option>
                        <option value="Admin" ${selectedRole == 'Admin' ? 'selected' : ''}>Admin</option>
                        <option value="Staff" ${selectedRole == 'Staff' ? 'selected' : ''}>Staff</option>
                        <option value="Customer" ${selectedRole == 'Customer' ? 'selected' : ''}>Customer</option>
                    </select>
                </div>

                <!-- Status Filter -->
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold">Status</label>
                    <select name="status" class="form-select rounded-3">
                        <option value="All" ${selectedStatus == 'All' ? 'selected' : ''}>All Statuses</option>
                        <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${selectedStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        <option value="Blocked" ${selectedStatus == 'Blocked' ? 'selected' : ''}>Blocked</option>
                    </select>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 mt-4">
                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-outline-secondary px-4 rounded-3">
                    Clear
                </a>
                <button type="submit" class="btn btn-primary px-4 rounded-3 text-white">
                    Filter
                </button>
            </div>
        </form>
    </section>

    <!-- Accounts Table List -->
    <section class="table-panel">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0 fw-bold" style="color: var(--text-main);"><i class="fa-solid fa-users-gear me-2 text-primary"></i>User Accounts List</h4>
            <div>
                <span class="badge bg-primary rounded-pill py-2 px-3">${accounts.size()} Account(s)</span>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-custom table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width: 70px;">Avatar</th>
                        <th>Account ID & Username</th>
                        <th>Full Name</th>
                        <th>Email & Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Created Date</th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>
                        <c:when test="${empty accounts}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="fa-regular fa-folder-open display-4 mb-3 d-block text-secondary"></i>
                                    No accounts found matching the selected search criteria.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="acc" items="${accounts}">
                                <tr>
                                    <td>
                                        <img src="https://ui-avatars.com/api/?name=${acc.username}&background=random&size=128" 
                                             alt="User Avatar" 
                                             class="user-avatar">
                                    </td>
                                    <td>
                                        <span class="text-muted small d-block">ID: #${acc.accountId}</span>
                                        <span class="fw-semibold text-dark d-block">${acc.username}</span>
                                    </td>
                                    <td>
                                        <span class="text-dark d-block">${acc.fullName}</span>
                                    </td>
                                    <td>
                                        <span class="text-muted small d-block"><i class="fa-regular fa-envelope me-1"></i>${acc.email}</span>
                                        <c:if test="${not empty acc.phone}">
                                            <span class="text-muted small d-block"><i class="fa-solid fa-phone me-1"></i>${acc.phone}</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${'Admin'.equalsIgnoreCase(acc.role)}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-user-shield me-1"></i>Admin</span>
                                            </c:when>
                                            <c:when test="${'Staff'.equalsIgnoreCase(acc.role)}">
                                                <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill"><i class="fa-solid fa-user-tie me-1"></i>Staff</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info-subtle text-info border border-info px-3 py-2 rounded-pill"><i class="fa-solid fa-user me-1"></i>Customer</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${'Active'.equalsIgnoreCase(acc.status)}">
                                                <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-check me-1"></i>Active</span>
                                            </c:when>
                                            <c:when test="${'Inactive'.equalsIgnoreCase(acc.status)}">
                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary px-3 py-2 rounded-pill"><i class="fa-solid fa-circle-pause me-1"></i>Inactive</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill"><i class="fa-solid fa-ban me-1"></i>${acc.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="text-muted small d-block">
                                            <fmt:formatDate value="${acc.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
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
