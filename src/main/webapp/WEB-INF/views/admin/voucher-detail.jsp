<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Voucher Details" />
    <jsp:param name="activeMenu" value="vouchers" />
</jsp:include>

<!-- Main Content -->
<div class="container-fluid p-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary btn-sm mb-2">
                <i class="fa-solid fa-arrow-left me-1"></i>Back to Vouchers
            </a>
            <h3 class="mb-0 fw-bold" style="color: var(--text-main);">Voucher Details: <span class="text-primary">${voucher.voucherCode}</span></h3>
        </div>
        <c:if test="${sessionScope.user.role == 'Admin'}">
            <a href="${pageContext.request.contextPath}/admin/vouchers?action=edit&id=${voucher.voucherId}" class="btn btn-warning rounded-pill px-4 text-dark fw-bold">
                <i class="fa-solid fa-pen me-2"></i>Edit Voucher
            </a>
        </c:if>
    </div>

    <!-- Voucher Details Panel -->
    <section class="filter-panel mb-4 p-4 p-md-5" style="background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.05);">
        <div class="row g-4">
            <!-- Left Info Block -->
            <div class="col-md-6 border-end">
                <h5 class="mb-4 text-primary fw-bold"><i class="fa-solid fa-circle-info me-2"></i>General Information</h5>
                <table class="table table-borderless align-middle">
                    <tr>
                        <td class="text-muted ps-0" style="width: 40%; font-weight: 600;">Voucher ID</td>
                        <td class="fw-bold">#${voucher.voucherId}</td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Voucher Code</td>
                        <td>
                            <span class="badge bg-light text-dark border px-3 py-2 fs-6 fw-bold" style="letter-spacing: 0.5px; border-radius: 6px;">${voucher.voucherCode}</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Discount Percent</td>
                        <td><span class="h5 mb-0 text-primary fw-bold">${voucher.discountPercent}%</span></td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Status</td>
                        <td>
                            <c:choose>
                                <c:when test="${'Active'.equalsIgnoreCase(voucher.status)}">
                                    <span class="badge bg-success text-white px-3 py-2 rounded-pill"><i class="fa-regular fa-circle-check me-1"></i>Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger text-white px-3 py-2 rounded-pill"><i class="fa-regular fa-circle-xmark me-1"></i>Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>

            <!-- Right Info Block -->
            <div class="col-md-6 ps-md-4">
                <h5 class="mb-4 text-primary fw-bold"><i class="fa-solid fa-sliders me-2"></i>Usage & Limits</h5>
                <table class="table table-borderless align-middle">
                    <tr>
                        <td class="text-muted ps-0" style="width: 40%; font-weight: 600;">Minimum Order Value</td>
                        <td class="fw-bold text-dark">
                            <fmt:formatNumber value="${voucher.minimumOrderValue}" pattern="#,##0 ₫"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Maximum Discount</td>
                        <td class="fw-bold text-dark">
                            <fmt:formatNumber value="${voucher.maxDiscountAmount}" pattern="#,##0 ₫"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Available Quantity</td>
                        <td class="fw-bold">
                            <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${voucher.quantity} usages left</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted ps-0" style="font-weight: 600;">Validity Period</td>
                        <td>
                            <div class="small fw-semibold">
                                <span class="text-success"><i class="fa-solid fa-calendar-day me-1"></i>Start: <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy" /></span><br>
                                <span class="text-danger"><i class="fa-solid fa-calendar-check me-1"></i>End: <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy" /></span>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </section>
</div>

<jsp:include page="layout/footer.jsp" />
