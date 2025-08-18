<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
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
<title>Pahana edu — Add User</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    /* Colors */
    body { background:#ffffff; color:#0f172a; font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif; }
    .muted { color:#64748b; }
    .primary { background:#1d4ed8; color:#fff; }
    .success { background:#22c55e; color:#fff; }
    .danger { background:#ef4444; color:#fff; }
    .badge-bg { background:#e6f0ff; color:#0b61ff; }

    * { box-sizing:border-box; }
    a { color:inherit; text-decoration:none; }
    .wrap{ max-width:600px; margin:28px auto; padding:0 20px; }

    /* Top bar */
    .topbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; }
    .brand { font-weight:700; letter-spacing:.2px; font-size:18px; }
    .right { display:flex; gap:40px; align-items:center; }
    .userbox { font-size:14px; line-height:1.1; }
    .username { font-size:16px; }
    .badge { display:inline-block; font-size:12px; padding:3px 8px; border-radius:9999px; margin-top:6px; }

    .logout { border:0; background:#ef4444; color:#fff; padding:12px 18px; border-radius:9999px; cursor:pointer; font-size:14px; font-weight:500; display:inline-flex; align-items:center; justify-content:center; gap:6px; }

    /* Heading */
    .title { font-size:32px; font-weight:600; text-align:center; margin:20px 0; }
    .subtitle { font-size:16px; font-weight:500; text-align:center; margin-bottom:20px; color:#64748b; }

    /* Form */
    form { background:#fff; padding:25px 30px; border-radius:12px; box-shadow:0 4px 6px rgba(0,0,0,0.05); }
    label { display:block; font-weight:600; margin-bottom:6px; margin-top:15px; }
    input, select { width:100%; padding:10px 14px; border-radius:8px; border:1px solid #e5e7eb; font-size:14px; }
    input:focus, select:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 2px rgba(29,78,216,0.2); }

    /* Buttons */
    .btn-success { background:#22c55e; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; margin-top:20px; }
    .btn-success:hover { opacity:0.85; }
    .btn-danger { background:#ef4444; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; margin-top:20px; margin-left:10px; }
    .btn-danger:hover { opacity:0.85; }

    /* Toast */
    .toast { position:fixed; top:18px; left:50%; transform:translateX(-50%); background:#0ea5e9; color:#fff; padding:10px 16px; border-radius:9999px; font-weight:600; display:none; z-index:50; box-shadow:0 4px 6px rgba(0,0,0,0.1); }

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
    <h1 class="title">Add New User</h1>

    <!-- User Form -->
    <form method="post" action="<%=request.getContextPath()%>/UserController">
        <input type="hidden" name="action" value="add">

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <label for="role">Role</label>
        <select id="role" name="role" required>
            <option value="">Select Role</option>
            <option value="admin">Admin</option>
            <option value="staff">Staff</option>
        </select>

        <button type="submit" class="btn-success">Add User</button>
        <a href="user-list.jsp" class="btn-danger">Cancel</a>
    </form>

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
