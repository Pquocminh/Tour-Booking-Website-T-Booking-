<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Manage Accounts" />
    <jsp:param name="activeMenu" value="accounts" />
</jsp:include>


<!-- Main Content -->
<div class="container-fluid p-0">

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4 animate__animated animate__fadeIn" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4 animate__animated animate__fadeIn" role="alert">
            <i class="fa-solid fa-circle-xmark me-2"></i> ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

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
            <div class="d-flex gap-2 align-items-center">
                <span class="badge bg-primary rounded-pill py-2 px-3">${accounts.size()} Account(s)</span>
                <button type="button" class="btn btn-success btn-sm rounded-pill px-3 text-white" data-bs-toggle="modal" data-bs-target="#createAccountModal">
                    <i class="fa-solid fa-user-plus me-1"></i> Create Account
                </button>
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
                        <th style="width: 150px; text-align: center;">Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>
                        <c:when test="${empty accounts}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
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
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-1">
                                            <a href="${pageContext.request.contextPath}/admin/accounts?action=view&id=${acc.accountId}" 
                                               class="btn btn-outline-primary btn-sm rounded-pill" title="View Profile">
                                                <i class="fa-regular fa-eye"></i>
                                            </a>
                                            <button type="button" 
                                                    class="btn btn-outline-warning btn-sm rounded-pill edit-btn" 
                                                    title="Edit Account"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#editAccountModal"
                                                    data-id="${acc.accountId}"
                                                    data-username="${acc.username}"
                                                    data-fullname="${acc.fullName}"
                                                    data-email="${acc.email}"
                                                    data-phone="${acc.phone}"
                                                    data-address="${acc.address}"
                                                    data-role="${acc.role}"
                                                    data-status="${acc.status}">
                                                <i class="fa-regular fa-pen-to-square"></i>
                                            </button>
                                            <button type="button" 
                                                    class="btn btn-outline-danger btn-sm rounded-pill delete-btn" 
                                                    title="Delete Account"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#deleteAccountModal"
                                                    data-id="${acc.accountId}"
                                                    data-username="${acc.username}">
                                                <i class="fa-regular fa-trash-can"></i>
                                            </button>
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
</div>

<!-- Create Account Modal -->
<div class="modal fade" id="createAccountModal" tabindex="-1" aria-labelledby="createAccountModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="modal-title fw-bold text-dark" id="createAccountModalLabel"><i class="fa-solid fa-user-plus me-2 text-success"></i>Create New Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/accounts?action=create" method="POST">
                <div class="modal-body py-3">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Username <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Password <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Full Name</label>
                        <input type="text" name="fullName" class="form-control rounded-3">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Phone Number</label>
                        <input type="text" name="phone" class="form-control rounded-3">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Address</label>
                        <input type="text" name="address" class="form-control rounded-3">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Role <span class="text-danger">*</span></label>
                            <select name="role" class="form-select rounded-3" required>
                                <option value="Customer">Customer</option>
                                <option value="Staff">Staff</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Status <span class="text-danger">*</span></label>
                            <select name="status" class="form-select rounded-3" required>
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                                <option value="Blocked">Blocked</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary px-4 rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success px-4 rounded-3 text-white">Create</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Account Modal -->
<div class="modal fade" id="editAccountModal" tabindex="-1" aria-labelledby="editAccountModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="modal-title fw-bold text-dark" id="editAccountModalLabel"><i class="fa-solid fa-user-pen me-2 text-warning"></i>Edit User Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/accounts?action=update" method="POST">
                <input type="hidden" name="id" id="edit_id">
                <div class="modal-body py-3">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Username (Read-Only)</label>
                        <input type="text" id="edit_username" class="form-control rounded-3 bg-light text-muted" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">New Password (Leave blank to keep unchanged)</label>
                        <input type="password" name="password" class="form-control rounded-3" placeholder="Enter new password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" id="edit_email" class="form-control rounded-3" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Full Name</label>
                        <input type="text" name="fullName" id="edit_fullname" class="form-control rounded-3">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Phone Number</label>
                        <input type="text" name="phone" id="edit_phone" class="form-control rounded-3">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Address</label>
                        <input type="text" name="address" id="edit_address" class="form-control rounded-3">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Role <span class="text-danger">*</span></label>
                            <select name="role" id="edit_role" class="form-select rounded-3" required>
                                <option value="Customer">Customer</option>
                                <option value="Staff">Staff</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Status <span class="text-danger">*</span></label>
                            <select name="status" id="edit_status" class="form-select rounded-3" required>
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                                <option value="Blocked">Blocked</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary px-4 rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning px-4 rounded-3 text-dark fw-bold">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Account Modal -->
<div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="modal-title fw-bold text-dark" id="deleteAccountModalLabel"><i class="fa-solid fa-triangle-exclamation me-2 text-danger"></i>Delete Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/accounts?action=delete" method="POST">
                <input type="hidden" name="id" id="delete_id">
                <div class="modal-body py-3">
                    <p class="mb-0 text-dark">Are you sure you want to delete the account <span class="fw-bold text-danger" id="delete_username_display"></span>?</p>
                    <p class="text-muted small mt-2 mb-0"><i class="fa-solid fa-info-circle me-1"></i>This action is permanent and cannot be undone.</p>
                </div>
                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary px-4 rounded-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger px-4 rounded-3 text-white">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Edit button handler
        const editButtons = document.querySelectorAll('.edit-btn');
        editButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                document.getElementById('edit_id').value = this.getAttribute('data-id');
                document.getElementById('edit_username').value = this.getAttribute('data-username');
                document.getElementById('edit_email').value = this.getAttribute('data-email');
                document.getElementById('edit_fullname').value = this.getAttribute('data-fullname');
                document.getElementById('edit_phone').value = this.getAttribute('data-phone');
                document.getElementById('edit_address').value = this.getAttribute('data-address');
                document.getElementById('edit_role').value = this.getAttribute('data-role');
                document.getElementById('edit_status').value = this.getAttribute('data-status');
            });
        });

        // Delete button handler
        const deleteButtons = document.querySelectorAll('.delete-btn');
        deleteButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                document.getElementById('delete_id').value = this.getAttribute('data-id');
                document.getElementById('delete_username_display').textContent = '@' + this.getAttribute('data-username');
            });
        });
    });
</script>

<jsp:include page="layout/footer.jsp" />

