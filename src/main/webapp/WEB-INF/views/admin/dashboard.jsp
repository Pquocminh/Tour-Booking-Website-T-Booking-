<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard" />
    <jsp:param name="activeMenu" value="dashboard" />
</jsp:include>

<style>
    /* Custom UI Improvements */
    .stat-card {
        background: #fff;
        border-radius: 16px;
        padding: 24px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        height: 100%;
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
    }
    .stat-icon-wrapper {
        width: 56px;
        height: 56px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }
    .stat-icon-wrapper.icon-blue { background: #eff6ff; color: #3b82f6; }
    .stat-icon-wrapper.icon-green { background: #f0fdf4; color: #22c55e; }
    .stat-icon-wrapper.icon-red { background: #fef2f2; color: #ef4444; }
    .stat-icon-wrapper.icon-yellow { background: #fefce8; color: #eab308; }
    
    .stat-info .stat-value {
        font-size: 1.75rem;
        font-weight: 800;
        color: #1e293b;
        margin: 0;
        line-height: 1.2;
    }
    .stat-info .stat-label {
        font-size: 0.875rem;
        font-weight: 600;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    
    .panel {
        background: #fff;
        border-radius: 16px;
        padding: 24px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    }
    .panel-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 20px;
    }
    .badge-status {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .badge-pending { background: #fef3c7; color: #d97706; }
    .badge-complete { background: #dcfce7; color: #15803d; }
    .badge-canceled { background: #fee2e2; color: #b91c1c; }
    
    .table-custom th {
        color: #64748b;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.75rem;
        letter-spacing: 0.5px;
        padding-bottom: 15px;
        border-bottom: 1px solid #e2e8f0;
    }
    .table-custom td {
        padding: 15px 0;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
        color: #1e293b;
    }
</style>

            <!-- Primary Stats Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper icon-blue"><i class="fa-solid fa-users"></i></div>
                        <div class="stat-info">
                            <h3 class="stat-value">${totalUsers}+</h3>
                            <span class="stat-label">Total Customers</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper icon-green"><i class="fa-solid fa-map"></i></div>
                        <div class="stat-info">
                            <h3 class="stat-value">${totalTours}+</h3>
                            <span class="stat-label">Active Tours</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper icon-blue"><i class="fa-solid fa-ticket"></i></div>
                        <div class="stat-info">
                            <h3 class="stat-value">${totalBookings}+</h3>
                            <span class="stat-label">Total Bookings</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
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



            <!-- Main Charts & Tables -->
            <div class="row g-4">
                
                <!-- Left Column (Line Chart & Table) -->
                <div class="col-lg-8">
                    <!-- Line Chart -->
                    <div class="panel mb-4">
                        <div class="panel-title d-flex justify-content-between align-items-center">
                            Sales Reports
                            <div>
                                <select class="form-select form-select-sm d-inline-block w-auto d-none me-2" id="monthSelector">
                                    <option value="1">Tháng 1</option>
                                    <option value="2">Tháng 2</option>
                                    <option value="3">Tháng 3</option>
                                    <option value="4">Tháng 4</option>
                                    <option value="5">Tháng 5</option>
                                    <option value="6">Tháng 6</option>
                                    <option value="7">Tháng 7</option>
                                    <option value="8">Tháng 8</option>
                                    <option value="9">Tháng 9</option>
                                    <option value="10">Tháng 10</option>
                                    <option value="11">Tháng 11</option>
                                    <option value="12">Tháng 12</option>
                                </select>
                                <select class="form-select form-select-sm d-inline-block w-auto" id="salesReportPeriod">
                                    <option value="weekly">Weekly</option>
                                    <option value="monthly">Monthly</option>
                                    <option value="yearly">Yearly</option>
                                </select>
                            </div>
                        </div>
                        <div style="height: 300px; position: relative;">
                            <canvas id="mainChart"></canvas>
                            <div id="salesChartEmpty" class="d-none" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; align-items: center; justify-content: center; background: #ffffff; z-index: 10;">
                                <div class="text-center text-muted">
                                    <i class="fa-solid fa-chart-bar fs-1 mb-2" style="color: #cbd5e1;"></i>
                                    <p class="mb-0 fw-bold">Không có dữ liệu doanh thu</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders Table -->
                    <div class="panel">
                        <div class="panel-title d-flex justify-content-between align-items-center">
                            <span>Recent Orders</span>
                            <a href="${pageContext.request.contextPath}/admin/bookings" style="font-size: 0.8rem; background: #f1f5f9; padding: 5px 12px; border-radius: 15px; text-decoration: none; color: var(--text-gray);">See all</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table-custom w-100">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tour Name</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${recentBookings}">
                                        <tr>
                                            <td><span class="text-muted">#</span>${b.bookingId}</td>
                                            <td class="fw-semibold text-truncate" style="max-width: 150px;" title="${b.tourName}">${b.tourName}</td>
                                            <td>
                                                <i class="fa-solid fa-user-circle me-2 text-primary"></i>
                                                ${b.contactName}
                                            </td>
                                            <td class="text-muted"><fmt:formatDate value="${b.bookingDate}" pattern="MMM dd, yyyy" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status == 'COMPLETED' || b.status == 'Completed' || b.status == 'CONFIRMED' || b.status == 'Confirmed' || b.status == 'PAID' || b.status == 'Paid'}">
                                                        <span class="badge-status badge-complete">${b.status}</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'CANCELED' || b.status == 'Canceled' || b.status == 'CANCELLED' || b.status == 'Cancelled'}">
                                                        <span class="badge-status badge-canceled">${b.status}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-pending">${b.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-bold"><fmt:formatNumber value="${b.totalPrice}" pattern="#,##0 ₫"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Column (Donut & Bar Chart) -->
                <div class="col-lg-4">
                    <!-- Donut Chart -->
                    <div class="panel mb-4">
                        <div class="panel-title">
                            Booking Reports
                        </div>
                        <div style="height: 220px; display: flex; justify-content: center; position: relative;">
                            <canvas id="donutChart"></canvas>
                        </div>
                        <div class="text-center mt-3 text-muted">
                            <span class="fw-bold text-dark fs-5">${not empty statusDetails.total ? statusDetails.total : 0}</span> Total Bookings
                        </div>
                        <div class="d-flex justify-content-center gap-3 mt-3 text-muted flex-wrap" style="font-size: 0.8rem; font-weight: 600;">
                            <div><i class="fa-solid fa-circle text-success me-1"></i> Completed</div>
                            <div><i class="fa-solid fa-circle text-warning me-1"></i> Pending</div>
                            <div><i class="fa-solid fa-circle text-danger me-1"></i> Cancelled</div>
                        </div>
                    </div>

                    <!-- Bar Chart -->
                    <div class="panel">
                        <div class="panel-title">
                            Top Tours Performance
                        </div>
                        <div style="height: 320px; position: relative;">
                            <canvas id="barChart"></canvas>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <script>
        // Data from Controller
        const weeklyData = ${not empty weeklyData ? weeklyData : '[]'};
        const weeklyLabels = ${not empty weeklyLabels ? weeklyLabels : '[]'};
        const monthlyData = ${not empty monthlyData ? monthlyData : '[]'};
        const monthlyLabels = ${not empty monthlyLabels ? monthlyLabels : '[]'};
        const yearlyData = ${not empty yearlyData ? yearlyData : '[]'};
        const yearlyLabels = ${not empty yearlyLabels ? yearlyLabels : '[]'};

        const donutData = ${not empty statusDetails.distributionJson ? statusDetails.distributionJson : '[]'};
        const completionRate = '${not empty statusDetails.completionRate ? statusDetails.completionRate : 0}%';

        const analyticsLabels = ${not empty analyticsLabels ? analyticsLabels : '[]'};
        const analyticsData1 = ${not empty analyticsData1 ? analyticsData1 : '[]'}; // Counts
        const analyticsData2 = ${not empty analyticsData2 ? analyticsData2 : '[]'}; // Revenue

        // Common Chart Defaults
        Chart.defaults.font.family = "'Inter', sans-serif";
        Chart.defaults.color = "#64748b";
        if (typeof ChartDataLabels !== 'undefined') {
            Chart.register(ChartDataLabels);
        }

        // Chart.js Plugin for Donut Center Text
        const centerTextPlugin = {
            id: 'centerText',
            beforeDraw: function(chart) {
                if (chart.config.type !== 'doughnut') return;
                var width = chart.width,
                    height = chart.height,
                    ctx = chart.ctx;

                ctx.restore();
                var fontSize = (height / 100).toFixed(2);
                ctx.font = "800 " + fontSize + "em Inter";
                ctx.textBaseline = "middle";
                ctx.fillStyle = "#1e293b";

                var text = completionRate,
                    textX = Math.round((width - ctx.measureText(text).width) / 2),
                    textY = height / 2;

                ctx.fillText(text, textX, textY);
                ctx.save();
            }
        };
        Chart.register(centerTextPlugin);

        // 1. Main Bar Chart
        const mainChart = new Chart(document.getElementById('mainChart'), {
            type: 'bar',
            data: {
                labels: weeklyLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: weeklyData,
                    backgroundColor: '#3b82f6',
                    borderColor: '#2563eb',
                    borderWidth: 1,
                    borderRadius: 4,
                    barPercentage: 0.6,
                    categoryPercentage: 0.8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    intersect: false,
                    mode: 'index',
                },
                plugins: { 
                    legend: { display: false },
                    datalabels: { display: false },
                    tooltip: {
                        enabled: true,
                        backgroundColor: 'rgba(15, 23, 42, 0.9)',
                        titleFont: { family: 'Inter', size: 13 },
                        bodyFont: { family: 'Inter', size: 14, weight: 'bold' },
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                let val = context.raw * 1000000;
                                return ' ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
                            }
                        }
                    }
                },
                scales: {
                    x: { 
                        grid: { display: false } 
                    },
                    y: { 
                        border: { display: false }, 
                        grid: { color: '#f1f5f9' }, 
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                let val = value * 1000000;
                                if (val >= 1000000000) return (val / 1000000000) + ' Tỷ ₫';
                                if (val >= 1000000) return (val / 1000000) + ' Tr ₫';
                                return new Intl.NumberFormat('vi-VN').format(val) + ' ₫';
                            }
                        }
                    }
                }
            }
        });

        // Update function for empty state
        function updateSalesChart(labels, data) {
            mainChart.data.labels = labels;
            mainChart.data.datasets[0].data = data;
            mainChart.update();
            
            const sum = data.reduce((a, b) => a + b, 0);
            const emptyOverlay = document.getElementById('salesChartEmpty');
            if (sum === 0) {
                emptyOverlay.classList.remove('d-none');
            } else {
                emptyOverlay.classList.add('d-none');
            }
        }

        // Initialize empty state check
        updateSalesChart(weeklyLabels, weeklyData);

        const monthSelector = document.getElementById('monthSelector');
        monthSelector.value = new Date().getMonth() + 1;

        async function fetchMonthlyData(month) {
            try {
                const response = await fetch('<%= request.getContextPath() %>/admin/api/revenue?type=monthly&month=' + month);
                const resData = await response.json();
                updateSalesChart(resData.labels, resData.data);
            } catch (error) {
                console.error("Error fetching monthly data:", error);
            }
        }

        monthSelector.addEventListener('change', function(e) {
            fetchMonthlyData(e.target.value);
        });

        // Toggle Sales Data
        document.getElementById('salesReportPeriod').addEventListener('change', function(e) {
            if (e.target.value === 'monthly') {
                monthSelector.classList.remove('d-none');
                fetchMonthlyData(monthSelector.value);
            } else {
                monthSelector.classList.add('d-none');
                if (e.target.value === 'yearly') {
                    updateSalesChart(yearlyLabels, yearlyData);
                } else {
                    updateSalesChart(weeklyLabels, weeklyData);
                }
            }
        });

        // 2. Donut Chart
        new Chart(document.getElementById('donutChart'), {
            type: 'doughnut',
            data: {
                labels: ['Completed', 'Pending', 'Canceled'],
                datasets: [{
                    data: donutData,
                    backgroundColor: ['#22c55e', '#f59e0b', '#ef4444'],
                    borderWidth: 0,
                    hoverOffset: 4,
                    cutout: '75%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { 
                    legend: { display: false },
                    datalabels: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return ' ' + context.label + ': ' + context.raw + ' Bookings';
                            }
                        }
                    }
                }
            }
        });

        // 3. Bar Chart (Analytics: Top Tours)
        new Chart(document.getElementById('barChart'), {
            type: 'bar',
            data: {
                labels: analyticsLabels,
                datasets: [
                    {
                        label: 'Booked Seats',
                        data: analyticsData1,
                        backgroundColor: '#3b82f6',
                        borderRadius: 4
                    },
                    {
                        label: 'Available Seats',
                        data: analyticsData2,
                        backgroundColor: '#94a3b8',
                        borderRadius: 4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { 
                    legend: { 
                        display: true, 
                        position: 'top',
                        labels: { boxWidth: 12, usePointStyle: true }
                    },
                    datalabels: {
                        anchor: 'end',
                        align: 'top', // Position labels on top of vertical bars
                        font: { size: 10, weight: 'bold' },
                        color: '#64748b',
                        formatter: function(value, context) {
                            if(value === 0) return '';
                            return value;
                        }
                    },
                    tooltip: {
                        callbacks: {
                            title: function(context) {
                                // Show full name on hover
                                return context[0].label;
                            }
                        }
                    }
                },
                layout: {
                    padding: { top: 25 } // Space for datalabels on top
                },
                scales: {
                    x: { 
                        grid: { display: false },
                        ticks: {
                            maxRotation: 0,
                            minRotation: 0,
                            callback: function(value, index, values) {
                                // Truncate long tour names to keep labels horizontal and neat
                                const label = this.getLabelForValue(value);
                                if (label && label.length > 12) {
                                    return label.substring(0, 12) + '..';
                                }
                                return label;
                            }
                        }
                    },
                    y: { 
                        type: 'linear', 
                        display: true, 
                        grid: { display: false },
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
    </script>
<jsp:include page="layout/footer.jsp" />
