<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Product List</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    body { background:#ffffff; color:#0f172a; font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif; }
    a { color:inherit; text-decoration:none; }
    .wrap{ max-width:1180px; margin:28px auto; padding:0 20px; }

    /* Top bar */
    .topbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
    .brand { font-weight:700; letter-spacing:.2px; font-size:18px; }
    .right { display:flex; gap:40px; align-items:center; }
    .userbox { font-size:14px; line-height:1.1; }
    .username { font-size:16px; }
    .badge { display:inline-block; font-size:12px; padding:3px 8px; border-radius:9999px; margin-top:6px; background:#e6f0ff; color:#0b61ff; }
    .logout { border:0; background:#ef4444; color:#fff; padding:15px 20px; border-radius:9999px; cursor:pointer; font-size:14px; font-weight:500; display:inline-flex; align-items:center; justify-content:center; gap:6px; }

    /* Heading */
    .title { font-size:36px; font-weight:600; text-align:center; margin:30px 0 10px; }
    .subtitle { font-size:18px; font-weight:500; text-align:center; margin-bottom:25px; color:#64748b; }

    /* Buttons */
    .btn-success { background:#007BFF; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; }
    .btn-success:hover { opacity:0.85; }
    .btn-secondary { background:#64748b; color:#fff; padding:10px 18px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; }
    .btn-secondary:hover { opacity:0.85; }

    /* Search bar */
    .search-box { margin:20px 0; text-align:right; }
    .search-input { padding:10px 14px; font-size:14px; border:1px solid #cbd5e1; border-radius:9999px; width:250px; transition:0.2s; }
    .search-input:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 3px rgba(29,78,216,0.2); }

    /* Table styling */
    table { width:100%; border-collapse:collapse; margin-top:10px; font-size:15px; }
    th, td { padding:12px 15px; text-align:left; border-bottom:1px solid #e5e7eb; }
    thead { background-color:#1d4ed8; color:#fff; text-transform:uppercase; font-size:13px; letter-spacing:0.5px; }
    tbody tr:hover { background: #f3f4f6; }

    /* Actions */
    .actions { display:flex; gap:8px; flex-wrap:wrap; }
    .icon-btn { border:none; width:30px; height:30px; border-radius:50%; cursor:pointer; display:inline-flex; align-items:center; justify-content:center; transition:0.3s; padding:0; }
    .icon-btn img { width:18px; height:18px; }
    .icon-btn.edit { background:rgba(29,78,216,0.1); color:#1d4ed8; }
    .icon-btn.edit:hover { background:rgba(29,78,216,0.2); }
    .icon-btn.delete { background:rgba(239,68,68,0.1); color:#ef4444; }
    .icon-btn.delete:hover { background:rgba(239,68,68,0.2); }

    /* Toast */
    .toast { position:fixed; top:18px; left:50%; transform:translateX(-50%); background:#0ea5e9; color:#fff; padding:10px 16px; border-radius:9999px; font-weight:600; display:none; z-index:50; box-shadow:0 4px 6px rgba(0,0,0,0.1); }

    @media (max-width:768px){ 
        table, th, td{font-size:13px;} 
        .actions{flex-direction:row;gap:6px;} 
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
                <div class="badge"><%= (user.getRole() != null ? user.getRole().substring(0,1).toUpperCase() + user.getRole().substring(1) : "Staff") %></div>
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
    <h1 class="title">Product Management</h1>
    <div class="subtitle">Manage all products in the inventory</div>

    <!-- Actions -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
    	<div>
    		<a href="<%= user.getRole().equalsIgnoreCase("admin") ? "views/admin-dashboard.jsp" : "views/staff-dashboard.jsp" %>" class="btn-secondary">Go Back to Dashboard</a>
	    	<a href="ProductController?action=new" class="btn-success">+ Add New Product</a>
    	</div>
        <div class="search-box">
            <input type="text" id="searchInput" class="search-input" placeholder="Search by ID, Name or Category...">
        </div>
    </div>

    <!-- Product Table -->
    <table id="productTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Category</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (products != null && !products.isEmpty()) {
                for (Product p : products) {
        %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getProductCode() %></td>
                <td><%= p.getName() %></td>
                <td><%= p.getPrice() %></td>
                <td><%= p.getQuantity() %></td>
                <td><%= p.getCategory() %></td>
                <td class="actions">
                    <form method="get" action="ProductController" style="display:inline;">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%=p.getId()%>">
                        <button type="submit" class="icon-btn edit" title="Edit">
                            <img src="<%=request.getContextPath()%>/views/assets/edit.svg" alt="Edit">
                        </button>
                    </form>
                    <form method="get" action="ProductController" style="display:inline;" onsubmit="return confirmDelete()">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%=p.getId()%>">
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
                <td colspan="7" style="text-align:center; color:#64748b;">No products found</td>
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
    if(msg){
        const t = document.getElementById("toast");
        t.textContent = msg;
        t.style.display = "block";
        setTimeout(()=> t.style.display="none", 2600);
    }

    function confirmDelete(){ return confirm("Are you sure you want to delete this product?"); }
    function confirmLogout(){ return confirm("Log out from the session?"); }

    // Search filter
    document.getElementById("searchInput").addEventListener("keyup", function() {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll("#productTable tbody tr");
        rows.forEach(row => {
            const id = row.cells[0].textContent.toLowerCase();
            const code = row.cells[1].textContent.toLowerCase();
            const name = row.cells[2].textContent.toLowerCase();
            const category = row.cells[5].textContent.toLowerCase();
            if(id.includes(filter) || name.includes(filter) || category.includes(filter)) row.style.display="";
            else row.style.display="none";
        });
    });
</script>
</body>
</html>
