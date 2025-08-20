<%@ page import="java.util.*,com.pahanaedu.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    Double totalSalesToday = (Double) request.getAttribute("totalSalesToday");
    Double totalSales7Days = (Double) request.getAttribute("totalSales7Days");
    Double totalSales30Days = (Double) request.getAttribute("totalSales30Days");

    totalSalesToday = (totalSalesToday == null) ? 0.0 : totalSalesToday;
    totalSales7Days = (totalSales7Days == null) ? 0.0 : totalSales7Days;
    totalSales30Days = (totalSales30Days == null) ? 0.0 : totalSales30Days;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Billing Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    body { background:#ffffff; color:#0f172a; font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif; }
    .muted { color:#64748b; }
    .primary { background:#1d4ed8; color:#fff; }
    .success { background:#22c55e; color:#fff; }
    .danger { background:#ef4444; color:#fff; }
    .badge-bg { background:#e6f0ff; color:#0b61ff; }

    * { box-sizing:border-box; }
    a { color:inherit; text-decoration:none; }
    .wrap{ max-width:1180px; margin:28px auto; padding:0 20px; }

    .topbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
    .brand { font-weight:700; letter-spacing:.2px; font-size:18px; }
    .right { display:flex; gap:40px; align-items:center; }
    .userbox { font-size:14px; line-height:1.1; }
    .username { font-size:16px; }
    .badge { display:inline-block; font-size:12px; padding:3px 8px; border-radius:9999px; margin-top:6px; }

    .logout { border:0; background:#ef4444; color:#fff; padding:15px 20px; border-radius:9999px; cursor:pointer; font-size:14px; font-weight:500; display:inline-flex; align-items:center; justify-content:center; gap:6px; }

    .title { font-size:36px; font-weight:600; text-align:center; margin:30px 0 10px; }
    .subtitle { font-size:18px; font-weight:500; text-align:center; margin-bottom:25px; color:#64748b; }

    .btn-success { background:#007BFF; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; }
    .btn-success:hover { opacity:0.85; }

    .btn-secondary {
        background:#64748b;
        color:#fff;
        padding:10px 18px;
        border-radius:9999px;
        font-weight:500;
        border:0;
        cursor:pointer;
        transition:0.3s;
    }
    .btn-secondary:hover { opacity:0.85; }

    .search-box { margin:20px 0; text-align:right; }
    .search-input { padding:10px 14px; font-size:14px; border:1px solid #cbd5e1; border-radius:9999px; width:250px; transition:0.2s; }
    .search-input:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 3px rgba(29,78,216,0.2); }

    table { width:100%; border-collapse:collapse; margin-top:20px; font-size:15px; }
    th, td { padding:12px 15px; text-align:left; }
    thead { background-color:#1d4ed8; color:#fff; text-transform:uppercase; font-size:13px; letter-spacing:0.5px; }
    tbody tr { border-bottom:1px solid #e5e7eb; transition: background 0.2s; cursor:pointer; }
    tbody tr:hover { background: #f3f4f6; }
    td { color:#0f172a; }

    .summary { display:flex; gap:20px; flex-wrap:wrap; margin:20px 0 30px; }
    .card { flex:1 1 200px; background:#f9fafb; border:1px solid #e5e7eb; border-radius:10px; padding:20px; text-align:center; box-shadow:0 2px 4px rgba(0,0,0,0.05); }
    .card h3 { margin:0; font-size:16px; color:#1d4ed8; margin-bottom:8px; }
    .card p { font-size:20px; font-weight:600; }

    @media (max-width:768px){ 
        table, th, td{font-size:13px;} 
        .search-input{width:100%; margin-top:10px;} 
        .search-box{text-align:center;} 
    }
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
                <div class="badge badge-bg">
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
    <h1 class="title">Billing Dashboard</h1>

    

    <!-- Sales summary -->
    <div class="summary">
        <div class="card">
            <h3>Sales Today</h3>
            <p>LKR <%= String.format("%,.2f", totalSalesToday) %></p>
        </div>
        <div class="card">
            <h3>Sales Last 7 Days</h3>
            <p>LKR <%= String.format("%,.2f", totalSales7Days) %></p>
        </div>
        <div class="card">
            <h3>Sales Last 30 Days</h3>
            <p>LKR <%= String.format("%,.2f", totalSales30Days) %></p>
        </div>
    </div>

    <!-- Actions -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap;">
	    <div style="text-align:center; margin-bottom:20px;">
	        <a href="views/staff-dashboard.jsp" class="btn-secondary">Go Back to Dashboard</a>
	        <a href="BillController?action=new" class="btn btn-success">+ Create New Bill</a>
	    </div>
        
        <div class="search-box">
            <input type="text" id="searchInput" class="search-input" placeholder="Search by bill no, customer or staff...">
        </div>
    </div>

    <!-- Billing table -->
    <table id="billTable">
        <thead>
            <tr>
                <th>Bill No</th>
                <th>Customer</th>
                <th>Staff</th>
                <th>Date</th>
                <th>Total (LKR)</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% if (bills != null && !bills.isEmpty()) {
            for (Bill b : bills) { %>
            <tr onclick="window.location.href='BillController?action=view&billNumber=<%= b.getBillNumber() %>'">
                <td><%= b.getBillNumber() %></td>
                <td><%= b.getCustomer().getName() %></td>
                <td><%= b.getStaff().getUsername() %></td>
                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(b.getBillDate()) %></td>
                <td>LKR <%= String.format("%,.2f", b.getTotalAmount()) %></td>
                <td><a href="BillController?action=view&billNumber=<%= b.getBillNumber() %>" style="color:#1d4ed8; font-weight:600;">View Invoice</a></td>
            </tr>
        <%   }
          } else { %>
            <tr><td colspan="6" style="text-align:center; color:#64748b;">No bills found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<script>
    function confirmLogout(){
        return confirm("Log out from the admin session?");
    }

    document.getElementById("searchInput").addEventListener("keyup", function() {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll("#billTable tbody tr");

        rows.forEach(row => {
            const billNo = row.cells[0].textContent.toLowerCase();
            const customer = row.cells[1].textContent.toLowerCase();
            const staff = row.cells[2].textContent.toLowerCase();
            if (billNo.includes(filter) || customer.includes(filter) || staff.includes(filter)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });
</script>
</body>
</html>
