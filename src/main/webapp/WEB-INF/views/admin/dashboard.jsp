<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="activeMenu" value="dashboard" />
</jsp:include>

            <!-- Stats Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-icon-wrapper icon-blue"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-info">
                                <h3 class="stat-value">${totalUsers}+</h3>
                                <span class="stat-label">Total Customers</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-icon-wrapper icon-green"><i class="fa-solid fa-map"></i></div>
                            <div class="stat-info">
                                <h3 class="stat-value">${totalTours}+</h3>
                                <span class="stat-label">Active Tours</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-icon-wrapper icon-red"><i class="fa-solid fa-ticket"></i></div>
                            <div class="stat-info">
                                <h3 class="stat-value">${totalBookings}+</h3>
                                <span class="stat-label">Total Bookings</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-icon-wrapper icon-yellow"><i class="fa-solid fa-sack-dollar"></i></div>
                            <div class="stat-info">
                                <h3 class="stat-value">
                                    <fmt:formatNumber value="${totalRevenue/1000000}" pattern="#,##0"/>M+
                                </h3>
                                <span class="stat-label">Total Revenue</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Charts & Tables -->
            <div class="row g-4">
                
                <!-- Left Column (Line Chart & Table) -->
                <div class="col-lg-8">
                    <!-- Line Chart -->
                    <div class="panel mb-4" style="height: 350px;">
                        <div class="panel-title">
                            Sales Reports
                            <select class="form-select border-0 bg-light" style="width: auto; font-size: 0.85rem; font-weight: 600;">
                                <option>Weekly</option>
                                <option>Monthly</option>
                            </select>
                        </div>
                        <div style="height: 260px;">
                            <canvas id="mainChart"></canvas>
                        </div>
                    </div>

                    <!-- Recent Orders Table -->
                    <div class="panel">
                        <div class="panel-title">
                            Recent Orders
                            <a href="#" style="font-size: 0.8rem; background: #f1f5f9; padding: 5px 12px; border-radius: 15px; text-decoration: none; color: var(--text-gray);">See more</a>
                        </div>
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Contact Name</th>
                                    <th>Status</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${recentBookings}">
                                    <tr>
                                        <td><span class="text-muted">#</span>${b.bookingId}</td>
                                        <td>
                                            <i class="fa-solid fa-user-circle me-2 text-primary"></i>
                                            ${b.contactName}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.status == 'COMPLETED' || b.status == 'CONFIRMED' || b.status == 'PAID'}">
                                                    <span class="badge-status badge-complete">${b.status}</span>
                                                </c:when>
                                                <c:when test="${b.status == 'CANCELED'}">
                                                    <span class="badge-status badge-canceled">${b.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status badge-pending">${b.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Right Column (Donut & Bar Chart) -->
                <div class="col-lg-4">
                    <!-- Donut Chart -->
                    <div class="panel mb-4" style="height: 350px;">
                        <div class="panel-title">
                            Booking Reports
                            <i class="fa-solid fa-ellipsis text-muted"></i>
                        </div>
                        <div style="height: 200px; display: flex; justify-content: center; position: relative;">
                            <canvas id="donutChart"></canvas>
                            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
                                <h3 style="margin: 0; font-weight: 800;">70%</h3>
                            </div>
                        </div>
                        <div class="d-flex justify-content-center gap-4 mt-4 text-muted" style="font-size: 0.8rem; font-weight: 600;">
                            <div><i class="fa-solid fa-circle text-primary me-1"></i> Sale</div>
                            <div><i class="fa-solid fa-circle text-success me-1"></i> Distribute</div>
                            <div><i class="fa-solid fa-circle text-danger me-1"></i> Return</div>
                        </div>
                    </div>

                    <!-- Bar Chart -->
                    <div class="panel" style="height: 350px;">
                        <div class="panel-title">
                            Analytics
                            <i class="fa-solid fa-ellipsis text-muted"></i>
                        </div>
                        <div style="height: 250px;">
                            <canvas id="barChart"></canvas>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    <script>
        // Data from Controller
        const salesData = ${salesData};
        const salesLabels = ${salesLabels};
        const donutData = ${donutData};
        const barData1 = ${barData1};
        const barData2 = ${barData2};

        // Common Chart Defaults
        Chart.defaults.font.family = "'Inter', sans-serif";
        Chart.defaults.color = "#94a3b8";

        // 1. Main Line Chart
        new Chart(document.getElementById('mainChart'), {
            type: 'line',
            data: {
                labels: salesLabels,
                datasets: [{
                    label: 'Sales',
                    data: salesData,
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    borderWidth: 3,
                    pointBackgroundColor: 'white',
                    pointBorderColor: '#3b82f6',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false } },
                    y: { border: { display: false }, grid: { color: '#f1f5f9' }, min: 0, max: 100 }
                }
            }
        });

        // 2. Donut Chart
        new Chart(document.getElementById('donutChart'), {
            type: 'doughnut',
            data: {
                labels: ['Sale', 'Distribute', 'Return'],
                datasets: [{
                    data: donutData,
                    backgroundColor: ['#3b82f6', '#22c55e', '#ef4444'],
                    borderWidth: 0,
                    cutout: '75%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } }
            }
        });

        // 3. Bar Chart
        new Chart(document.getElementById('barChart'), {
            type: 'bar',
            data: {
                labels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                datasets: [
                    {
                        label: 'Visits',
                        data: barData1,
                        backgroundColor: '#3b82f6',
                        borderRadius: 5,
                        barPercentage: 0.5,
                        categoryPercentage: 0.4
                    },
                    {
                        label: 'Clicks',
                        data: barData2,
                        backgroundColor: '#93c5fd',
                        borderRadius: 5,
                        barPercentage: 0.5,
                        categoryPercentage: 0.4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false }, border: { display: false } },
                    y: { grid: { display: false }, border: { display: false }, min: 0, max: 100 }
                }
            }
        });
    </script>
<jsp:include page="layout/footer.jsp" />
