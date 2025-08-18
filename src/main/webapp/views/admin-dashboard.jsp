<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    // Session guard
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
<title>Pahana edu — Admin Dashboard</title>
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
    .topbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;}
    .brand{font-weight:700;letter-spacing:.2px; font-size:18px;}
    .right{display:flex;gap:40px;align-items:center;}
    .userbox{font-size:14px;line-height:1.1;}
    .username {font-size: 16px;}
    .badge{display:inline-block;font-size:12px;padding:3px 8px;border-radius:9999px;background:var(--badge);color:var(--badge-text);margin-top:6px;}
    
    .logout{
        border:0;background:var(--danger);color:#fff;padding:12px 25px;border-radius:9999px;
        cursor:pointer;
    }
    
    /* Heading */
    .title{font-size:48px;font-weight:600;text-align:center;margin:30px 0 8px;}
    .subtitle{font-size:42px;font-weight:500;text-align:center;margin:0 0 28px;}
    
    /* Grid cards */
    .grid{display:grid;grid-template-columns:repeat(12,1fr);gap:24px;}
    .card{
        grid-column:span 3; background:var(--card); border:1px solid var(--card-border); border-radius:18px; padding:28px;
        text-align:center;
    }
    .card h3{margin:6px 0 8px; font-size:18px;}
    .card p{margin:0 0 18px; color:var(--muted); font-size:14px; margin-bottom:60px;}
    
    .go{
        display:inline-flex; align-items:center; gap:10px; padding:10px 18px; border-radius:9999px; background:var(--primary); color:#fff;
        font-border:0; cursor:pointer;
    }

    .toast{
        position:fixed; top:18px; left:50%; transform:translateX(-50%); background:#0ea5e9; color:#fff; padding:10px 16px;
        border-radius:9999px; font-weight:600; display:none; z-index:50;
    }

    /* Responsive */
    @media (max-width:1100px){ .card{grid-column:span 4} .title{font-size:40px} }
    @media (max-width:780px){ .card{grid-column:span 6} .title{font-size:34px} }
    @media (max-width:520px){ .card{grid-column:span 12} .title{font-size:28px} .subtitle{font-size:18px} }
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
                <button class="logout" type="submit">logout</button>
            </form>
        </div>
    </div>

    <!-- Heading -->
    <h1 class="title">Welcome to Pahana edu</h1>
    <div class="subtitle">Admin Dashboard</div>

    <!-- Cards -->
    <div class="grid">

        <div class="card">
            <h3>View Users</h3>
            <p>Manage and view all users</p>
            <a class="go" href="<%=request.getContextPath()%>/UserController?action=list">Go Forward →</a>
        </div>

        <div class="card">
            <h3>View Products</h3>
            <p>Manage and view all Products</p>
            <a class="go" href="<%=request.getContextPath()%>/ProductController?action=list">Go Forward →</a>
        </div>

        <div class="card">
            <h3>View Logs</h3>
            <p>Check system logs and activities</p>
            <a class="go" href="<%=request.getContextPath()%>/LogController?action=list">Go Forward →</a>
        </div>

        <div class="card">
            <h3>View Customers</h3>
            <p>Manage and view all customers</p>
            <a class="go" href="<%=request.getContextPath()%>/CustomerController?action=list">Go Forward →</a>
        </div>

        <div class="card">
            <h3>View Reports</h3>
            <p>Manage and view all reports</p>
            <a class="go" href="<%=request.getContextPath()%>/ReportController?action=list">Go Forward →</a>
        </div>

        <div class="card">
            <h3>Help Section</h3>
            <p>Get guidance and support</p>
            <a class="go" href="help.jsp">Go Forward →</a>
        </div>
    </div>
</div>

<div id="toast" class="toast"></div>

<script>
    const params = new URLSearchParams(window.location.search);
    const msg = params.get("msg");
    if (msg) {
        const t = document.getElementById("toast");
        t.textContent = msg;
        t.style.display = "block";
        setTimeout(()=> t.style.display = "none", 2600);
    }

    function confirmLogout(){
        return confirm("Log out from the admin session?");
    }
</script>
</body>
</html>
