<%@page import="com.pahanaedu.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.pahanaedu.model.Bill" %>
<%
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    double totalSalesToday = (double) request.getAttribute("totalSalesToday");
    double totalSales7Days = (double) request.getAttribute("totalSales7Days");
    double totalSales30Days = (double) request.getAttribute("totalSales30Days");

    int customersCount = (int) request.getAttribute("customersCount");
    int productsCount = (int) request.getAttribute("productsCount");
    int usersCount = (int) request.getAttribute("usersCount");

    int totalBills = bills.size();
    double totalRevenue = 0;
    Map<String, Double> dailySales = new LinkedHashMap<>();
    for (Bill b : bills) {
        totalRevenue += b.getTotalAmount();
        String day = new java.text.SimpleDateFormat("yyyy-MM-dd").format(b.getBillDate());
        dailySales.put(day, dailySales.getOrDefault(day, 0.0) + b.getTotalAmount());
    }
    double avgBill = totalBills > 0 ? totalRevenue / totalBills : 0;

    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Admin Records</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    :root{
        --bg:#ffffff; --text:#0f172a; --muted:#64748b; --primary:#1d4ed8;
        --card:#ffffff; --card-border:#e5e7eb; --danger:#ef4444; --badge:#e6f0ff; --badge-text:#0b61ff;
    }
    *{box-sizing:border-box;}
    html,body{margin:0;background:var(--bg);color:var(--text);font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif;}
    a{color:inherit;text-decoration:none;}
    .wrap{max-width:1180px;margin:28px auto;padding:0 20px;}

    /* Top bar */
    .topbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px;}
    .brand{font-weight:700;letter-spacing:.2px; font-size:18px;}
    .right{display:flex;gap:40px;align-items:center;}
    .userbox{font-size:14px;line-height:1.1;}
    .username {font-size: 16px;}
    .badge{display:inline-block;font-size:12px;padding:3px 8px;border-radius:9999px;background:var(--badge);color:var(--badge-text);margin-top:6px;}
    .logout{
        border:0;background:var(--danger);color:#fff;padding:15px 20px;border-radius:9999px;
        cursor:pointer; font-size: 14px;  display: inline-flex; align-items: center; justify-content: center; gap: 6px;
    }

    /* Heading */
    .title{font-size:48px;font-weight:600;text-align:center;margin:30px 0 8px;}
    .subtitle{font-size:42px;font-weight:500;text-align:center;margin:0 0 28px;}

    /* Go Back Button */
    .go-back{
        display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:9999px;background:var(--primary);color:#fff;
        font-weight:600;text-decoration:none;margin-bottom:30px;
    }
    
    .btn-secondary { display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:9999px;background:#64748b;color:#fff;
        font-weight:600;text-decoration:none;margin-bottom:30px;}
    .btn-secondary:hover { opacity:0.85; }

    /* Grid cards */
    .grid{display:grid;grid-template-columns:repeat(12,1fr);gap:24px;}
    .card{
        grid-column:span 4; background:var(--card); border:1px solid var(--card-border); border-radius:18px; padding:28px;
        text-align:center; position:relative;
    }
    .card h3{margin:6px 0 8px; font-size:18px;}
    .card p{margin:0 0 18px; color:var(--muted); font-size:14px;}
    
    /* Sales chart */
    .chart-card{
        grid-column:span 12; background:var(--card); border:1px solid var(--card-border); border-radius:18px; padding:28px;
        margin-top:30px;
    }
    canvas{width:100%; height:300px; border-radius:12px;}

    /* Responsive */
    @media (max-width:1100px){ .card{grid-column:span 6} .title{font-size:40px} }
    @media (max-width:780px){ .card{grid-column:span 12} .title{font-size:34px} }
    @media (max-width:520px){ .title{font-size:28px} .subtitle{font-size:18px} }
</style>
</head>
<body>
<div class="wrap">

    <!-- Top bar -->
    <div class="topbar">
        <div class="brand">Pahana edu</div>

        <div class="right">
            <div class="userbox">
                <div class="username"><%= user.getUsername() %></div>
                <div class="badge">
                    <%= (user.getRole() != null ? user.getRole().substring(0,1).toUpperCase() + user.getRole().substring(1) : "User") %>
                </div>
            </div>
            <form method="post" action="<%=request.getContextPath()%>/UserController" onsubmit="return confirmLogout()">
                <input type="hidden" name="action" value="logout">
                <button class="logout" type="submit">
                    logout 
                    <img src="<%=request.getContextPath()%>/views/assets/logout.svg" alt="icon" style="width:16px; height:16px; margin-left:6px; filter: brightness(0) invert(1);">
                </button>
            </form>
        </div>
    </div>

    <!-- Heading -->
    <h1 class="title">Admin Records Dashboard</h1>
    <div class="subtitle">Check bills, revenue, and sales statistics</div>

    <!-- Go Back Button -->
    <a href="views/admin-dashboard.jsp" class="btn-secondary">← Go Back to Dashboard</a>

    <!-- Cards -->
    <div class="grid">
        <div class="card">
            <h3>Total Bills</h3>
            <p>Number of bills created</p>
            <div class="num"><%= totalBills %></div>
        </div>
        <div class="card">
            <h3>Total Revenue</h3>
            <p>All-time revenue from bills</p>
            <div class="num">Rs. <%= String.format("%.2f", totalRevenue) %></div>
        </div>
        <div class="card">
            <h3>Average Bill Value</h3>
            <p>Average revenue per bill</p>
            <div class="num">Rs. <%= String.format("%.2f", avgBill) %></div>
        </div>
        <div class="card">
            <h3>Sales Today</h3>
            <p>Revenue collected today</p>
            <div class="num">Rs. <%= String.format("%.2f", totalSalesToday) %></div>
        </div>
        <div class="card">
            <h3>Sales Last 7 Days</h3>
            <p>Revenue for the last week</p>
            <div class="num">Rs. <%= String.format("%.2f", totalSales7Days) %></div>
        </div>
        <div class="card">
            <h3>Sales Last 30 Days</h3>
            <p>Revenue for the last 30 days</p>
            <div class="num">Rs. <%= String.format("%.2f", totalSales30Days) %></div>
        </div>
        <div class="card">
            <h3>Total Customers</h3>
            <p>Registered customers</p>
            <div class="num"><%= customersCount %></div>
        </div>
        <div class="card">
            <h3>Total Products</h3>
            <p>Available products</p>
            <div class="num"><%= productsCount %></div>
        </div>
        <div class="card">
            <h3>Total Users</h3>
            <p>System users</p>
            <div class="num"><%= usersCount %></div>
        </div>

        <!-- Chart -->
        <div class="chart-card">
            <h3>Daily Sales Overview</h3>
            <canvas id="salesChart"></canvas>
        </div>
    </div>
</div>

<script>
    const labels = <%= new ArrayList<>(dailySales.keySet()) %>;
    const data = <%= new ArrayList<>(dailySales.values()) %>;

    const canvas = document.getElementById('salesChart');
    const ctx = canvas.getContext('2d');
    const maxVal = Math.max(...data, 1000);

    function drawChart(){
        const w = canvas.width = canvas.offsetWidth;
        const h = canvas.height = 300;
        ctx.clearRect(0,0,w,h);
        const barWidth = w / data.length - 15;

        data.forEach((val,i)=>{
            const x = i*(barWidth+10)+20;
            const y = h - (val/maxVal)*(h-50);
            const barHeight = (val/maxVal)*(h-50);

            ctx.fillStyle="#1d4ed8";
            ctx.fillRect(x,y,barWidth,barHeight);

            ctx.fillStyle="#333";
            ctx.font="13px sans-serif";
            ctx.fillText("Rs."+val.toFixed(0),x,y-5);

            ctx.fillStyle="#555";
            ctx.fillText(labels[i],x,h-5);
        });
    }
    drawChart();
    window.addEventListener('resize',drawChart);

    function confirmLogout(){ return confirm("Log out from the admin session?"); }
</script>

</body>
</html>
