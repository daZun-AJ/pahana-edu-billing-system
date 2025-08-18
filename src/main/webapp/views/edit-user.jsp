<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // The user to edit (set in UserController before forwarding to this page)
    User editUser = (User) request.getAttribute("editUser");
    if (editUser == null) {
        response.sendRedirect("user-list.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Edit User</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    /* Same styles as Add User page */
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
    .btn { padding:10px 18px; border-radius:9999px; border:0; cursor:pointer; font-weight:500; transition:0.3s; }
    .btn-primary { background:#1d4ed8; color:#fff; }
    .btn-primary:hover { opacity:0.85; }
    .btn-danger { background:#ef4444; color:#fff; }
    .btn-danger:hover { opacity:0.85; }
    .form-container { max-width:600px; margin:0 auto; background:#fff; padding:28px; border:1px solid #e5e7eb; border-radius:12px; box-shadow:0 4px 8px rgba(0,0,0,0.05); }
    .form-group { margin-bottom:18px; display:flex; flex-direction:column; }
    .form-group label { margin-bottom:6px; font-weight:500; }
    .form-group input, .form-group select { padding:10px 12px; border-radius:8px; border:1px solid #d1d5db; font-size:15px; }
    .form-group input:focus, .form-group select:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 2px rgba(29,78,216,0.2); }
    .toast { position:fixed; top:18px; left:50%; transform:translateX(-50%); background:#0ea5e9; color:#fff; padding:10px 16px; border-radius:9999px; font-weight:600; display:none; z-index:50; box-shadow:0 4px 6px rgba(0,0,0,0.1); }
    @media (max-width:768px){ .wrap{padding:0 15px;} }
</style>
</head>
<body>
<div class="wrap">

    <!-- Top bar -->
    <div class="topbar">
        <div class="brand">Pahana edu</div>
        <div class="right">
            <div class="userbox">
                <div class="username"><%= currentUser.getUsername() %></div>
                <div class="badge badge-bg">
                    <%= (currentUser.getRole() != null ? currentUser.getRole().substring(0,1).toUpperCase() + currentUser.getRole().substring(1) : "User") %>
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
    <h1 class="title">Edit User</h1>
    <p class="subtitle">Update the details for user <strong><%= editUser.getUsername() %></strong></p>

    <!-- Form -->
    <div class="form-container">
        <form method="post" action="<%=request.getContextPath()%>/UserController">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= editUser.getId() %>">

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" name="username" id="username" value="<%= editUser.getUsername() %>" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" placeholder="Enter new password or leave blank to keep current">
            </div>
            <div class="form-group">
                <label for="role">Role</label>
                <select name="role" id="role" required>
                    <option value="">Select Role</option>
                    <option value="admin" <%= "admin".equals(editUser.getRole()) ? "selected" : "" %>>Admin</option>
                    <option value="staff" <%= "staff".equals(editUser.getRole()) ? "selected" : "" %>>Staff</option>
                </select>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <a href="<%=request.getContextPath()%>/views/user-list.jsp" class="btn btn-danger">Cancel</a>
                <button type="submit" class="btn btn-primary">Update User</button>
            </div>
        </form>
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
