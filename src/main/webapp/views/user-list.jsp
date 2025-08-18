<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — User List</title>
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
    .wrap{ max-width:1180px; margin:28px auto; padding:0 20px; }

    /* Top bar */
    .topbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
    .brand { font-weight:700; letter-spacing:.2px; font-size:18px; }
    .right { display:flex; gap:40px; align-items:center; }
    .userbox { font-size:14px; line-height:1.1; }
    .username { font-size:16px; }
    .badge { display:inline-block; font-size:12px; padding:3px 8px; border-radius:9999px; margin-top:6px; }

    .logout { border:0; background:#ef4444; color:#fff; padding:15px 20px; border-radius:9999px; cursor:pointer; font-size:14px; font-weight:500; display:inline-flex; align-items:center; justify-content:center; gap:6px; }

    /* Heading */
    .title { font-size:36px; font-weight:600; text-align:center; margin:30px 0 10px; }
    .subtitle { font-size:18px; font-weight:500; text-align:center; margin-bottom:25px; color:#64748b; }

    /* Add user button */
    .btn-success { background:#007BFF; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; }
    .btn-success:hover { opacity:0.85; }

    /* Table styling */
    table { width:100%; border-collapse:collapse; margin-top:20px; font-size:15px; }
    th, td { padding:12px 15px; text-align:left; }
    thead { background-color:#1d4ed8; color:#fff; text-transform:uppercase; font-size:13px; letter-spacing:0.5px; }
    tbody tr { border-bottom:1px solid #e5e7eb; transition: background 0.2s; }
    tbody tr:hover { background: #f3f4f6; }
    td { color:#0f172a; }

    /* Status dots */
    .status-dot { display:inline-block; width:12px; height:12px; border-radius:50%; margin-right:6px; }
    .status-online { background-color:#22c55e; }
    .status-offline { background-color:#ef4444; }

    /* Action buttons with icons */
    .actions { display:flex; gap:8px; flex-wrap:wrap; }
    .icon-btn { border:none; width:30px; height:30px; border-radius:50%; cursor:pointer; display:inline-flex; align-items:center; justify-content:center; transition:0.3s; padding:0; }
    .icon-btn img { width:18px; height:18px; }

    .icon-btn.edit { background:rgba(29,78,216,0.1); color:#1d4ed8; }
    .icon-btn.edit:hover { background:rgba(29,78,216,0.2); }

    .icon-btn.delete { background:rgba(239,68,68,0.1); color:#ef4444; }
    .icon-btn.delete:hover { background:rgba(239,68,68,0.2); }

    /* Toast */
    .toast { position:fixed; top:18px; left:50%; transform:translateX(-50%); background:#0ea5e9; color:#fff; padding:10px 16px; border-radius:9999px; font-weight:600; display:none; z-index:50; box-shadow:0 4px 6px rgba(0,0,0,0.1); }

    /* Responsive */
    @media (max-width:768px){ table, th, td{font-size:13px;} .actions{flex-direction:row;gap:6px;} }
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
    <h1 class="title">User Management</h1>

    <!-- Add new user -->
    <div style="margin-bottom:20px; text-align:right;">
        <a href="add-user.jsp" class="btn btn-success">+ Add New User</a>
    </div>

    <!-- User table -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Role</th>
                <th>Is Login</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (users != null && !users.isEmpty()) {
                for (User u : users) {
        %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <span class="status-dot <%= u.isLogin() ? "status-online" : "status-offline" %>"></span>
                    <%= u.isLogin() ? "Online" : "Offline" %>
                </td>
                <td class="actions">
                    <!-- Edit icon button -->
                    <form method="post" action="<%=request.getContextPath()%>/UserController" style="display:inline;">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        <button type="submit" class="icon-btn edit" title="Edit">
                            <img src="<%=request.getContextPath()%>/views/assets/edit.svg" alt="Edit">
                        </button>
                    </form>
                    <!-- Delete icon button -->
                    <form method="post" action="<%=request.getContextPath()%>/UserController" style="display:inline;" onsubmit="return confirmDelete()">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        <button type="submit" class="icon-btn delete" title="Delete">
                            <img src="<%=request.getContextPath()%>/views/assets/delete.svg" alt="Delete">
                        </button>
                    </form>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="5" style="text-align:center; color:#64748b;">No users found</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
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

    function confirmDelete(){
        return confirm("Are you sure you want to delete this user?");
    }
    function confirmLogout(){
        return confirm("Log out from the admin session?");
    }
</script>
</body>
</html>
