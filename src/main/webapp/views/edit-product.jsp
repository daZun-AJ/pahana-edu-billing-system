<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("ProductController?action=list&msg=Product not found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Edit Product</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    body { background:#ffffff; color:#0f172a; font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif; }
    .wrap{ max-width:1180px; margin:28px auto; padding:0 20px; }
    a { color:inherit; text-decoration:none; }

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

    /* Form */
    .form-container { max-width:600px; margin:0 auto; background:#fff; padding:28px; border:1px solid #e5e7eb; border-radius:12px; box-shadow:0 4px 8px rgba(0,0,0,0.05); }
    .form-group { margin-bottom:18px; display:flex; flex-direction:column; }
    .form-group label { margin-bottom:6px; font-weight:500; }
    .form-group input, .form-group select { padding:10px 12px; border-radius:8px; border:1px solid #d1d5db; font-size:15px; }
    .form-group input:focus, .form-group select:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 2px rgba(29,78,216,0.2); }

    /* Buttons */
    .btn { padding:10px 18px; border-radius:9999px; border:0; cursor:pointer; font-weight:500; transition:0.3s; }
    .btn-primary { background:#1d4ed8; color:#fff; }
    .btn-primary:hover { opacity:0.85; }
    .btn-danger { background:#ef4444; color:#fff; }
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
                <div class="badge"><%= (user.getRole() != null ? user.getRole().substring(0,1).toUpperCase() + user.getRole().substring(1) : "User") %></div>
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
    <h1 class="title">Edit Product</h1>
    <p class="subtitle">Update the product details below</p>

    <!-- Form -->
    <div class="form-container">
        <form method="post" action="ProductController">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= product.getId() %>">

            <div class="form-group">
                <label for="product_code">Product Code</label>
                <input type="text" name="product_code" id="product_code" value="<%= product.getProductCode() %>" required>
            </div>

            <div class="form-group">
                <label for="name">Product Name</label>
                <input type="text" name="name" id="name" value="<%= product.getName() %>" required>
            </div>

            <div class="form-group">
                <label for="price">Price</label>
                <input type="number" name="price" id="price" step="0.01" value="<%= product.getPrice() %>" required>
            </div>

            <div class="form-group">
                <label for="quantity">Quantity</label>
                <input type="number" name="quantity" id="quantity" value="<%= product.getQuantity() %>" required>
            </div>

            <div class="form-group">
                <label for="category">Category</label>
                <select name="category" id="category" required>
                    <option value="">Select category</option>
                    <option value="Books" <%= "Books".equals(product.getCategory()) ? "selected" : "" %>>Books</option>
                    <option value="Stationery" <%= "Stationery".equals(product.getCategory()) ? "selected" : "" %>>Stationery</option>
                    <option value="Paper Products" <%= "Paper Products".equals(product.getCategory()) ? "selected" : "" %>>Paper Products</option>
                    <option value="Office Supplies" <%= "Office Supplies".equals(product.getCategory()) ? "selected" : "" %>>Office Supplies</option>
                    <option value="Art and Craft" <%= "Art and Craft".equals(product.getCategory()) ? "selected" : "" %>>Art and Craft</option>
                    <option value="School Accessories" <%= "School Accessories".equals(product.getCategory()) ? "selected" : "" %>>School Accessories</option>
                </select>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <a href="<%= user.getRole().equalsIgnoreCase("admin") ? "AdminDashboard.jsp" : "StaffDashboard.jsp" %>" class="btn btn-danger">Cancel</a>
                <button type="submit" class="btn btn-primary">Update Product</button>
            </div>
        </form>
    </div>

</div>

<div id="toast" class="toast"></div>

<script>
    function confirmLogout(){
        return confirm("Log out from the session?");
    }

    const params = new URLSearchParams(window.location.search);
    const msg = params.get("msg");
    if(msg){
        const t = document.getElementById("toast");
        t.textContent = msg;
        t.style.display = "block";
        setTimeout(()=> t.style.display="none", 2600);
    }
</script>
</body>
</html>
