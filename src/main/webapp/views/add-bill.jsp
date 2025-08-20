<%@ page import="java.util.*, com.pahanaedu.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");

    String billNumber = "BILL-" + System.currentTimeMillis();
    Date now = new Date();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Invoice — Pahana edu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { margin:0; padding:0; background:#fff; color:#0f172a; font-family:ui-sans-serif, system-ui, Segoe UI, Roboto, Arial, sans-serif; }
        * { box-sizing: border-box; }
        .wrap { max-width:100%; margin:10px auto; padding:10px; }
        h1 { font-size:24px; font-weight:600; margin-bottom:16px; text-align:center; }
        .container { display:flex; gap:12px; }
        .panel { background:#f9fafb; border:1px solid #e5e7eb; border-radius:10px; padding:12px; flex:1; box-shadow:0 1px 3px rgba(0,0,0,0.05);}
        .left { flex:1.5; display:flex; flex-direction:column; }
        .right { flex:1.2; display:flex; flex-direction:column; gap:12px; }
        .search-input { padding:12px 14px; font-size:14px; border:1px solid #cbd5e1; border-radius:10px; width:100%; margin-bottom:12px; }
        .search-input:focus { outline:none; border-color:#1d4ed8; box-shadow:0 0 0 3px rgba(29,78,216,0.2); }
        .list-box { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:12px; max-height:85vh; overflow-y:auto; padding:5px; background:#fff; border:1px solid #e5e7eb; border-radius:10px; }
        .product-card { background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:12px; box-shadow:0 1px 2px rgba(0,0,0,0.04); display:flex; flex-direction:column; gap:6px; transition: transform 0.2s; }
        .product-card:hover { transform: scale(1.02); background:#f9fafb; }
        .out-of-stock { opacity:0.5; pointer-events:none; }
        .card-title { font-size:14px; font-weight:600; }
        .card-code, .card-price { font-size:13px; color:#475569; }
        .btn-add { background:#22c55e; color:#fff; border:none; border-radius:6px; padding:6px 10px; cursor:pointer; font-size:13px; width:fit-content; }
        .btn-add:hover { opacity:0.9; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        th, td { padding:8px; border-bottom:1px solid #e5e7eb; text-align:left; }
        thead { background-color:#1d4ed8; color:#fff; }
        .btn { padding:8px 14px; border-radius:9999px; font-weight:500; border:0; cursor:pointer; transition:0.3s; }
        .btn-primary { background:#1d4ed8; color:#fff; }
        .btn-primary:hover { opacity:0.85; }
        .btn-danger { background:#ef4444; color:#fff; }
        .btn-danger:hover { opacity:0.85; }
        .summary-box { background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:10px; margin-top:10px; font-size:14px; }
        .info-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
        .info-grid div { background:#fff; border:1px solid #e5e7eb; border-radius:6px; padding:8px; font-size:13px; }
        select { font-size:14px; padding:10px; border-radius:10px; border:1px solid #cbd5e1; width:100%; }
        select option { padding:6px; }
    </style>
    <script>
        let products = [
            <% for (Product p : products) { %>
            { id: "<%= p.getId() %>", code: "<%= p.getProductCode() %>", name: "<%= p.getName() %>", price: <%= p.getPrice() %>, stock: <%= p.getQuantity() %> },
            <% } %>
        ];

        function filterProducts() {
            const kw = document.getElementById('productSearch').value.toLowerCase();
            let list = document.getElementById('productList');

            let filtered = products.filter(p =>
                p.name.toLowerCase().includes(kw) || p.code.toLowerCase().includes(kw)
            );

            if (filtered.length === 0) {
                list.innerHTML = "<p style='padding:10px; color:#6b7280;'>No products found</p>";
                return;
            }

            list.innerHTML = filtered.map(p => `
                <div class="product-card ${p.stock <=0 ? 'out-of-stock' : ''}">
                    <div class="card-title">${p.name}</div>
                    <div class="card-code">Code: ${p.code}</div>
                    <div class="card-price">LKR ${p.price.toFixed(2)}</div>
                    <button type="button" class="btn-add" onclick="selectProduct('${p.id}')" ${p.stock <=0 ? 'disabled' : ''}>
                        ${p.stock <=0 ? 'Out of Stock' : 'Add'}
                    </button>
                </div>
            `).join('');
        }

        function filterCustomerOptions() {
            const searchTerm = document.getElementById("customerSearch").value.toLowerCase();
            const select = document.getElementById("customerSelect");
            for (let option of select.options) {
                const text = option.text.toLowerCase();
                option.style.display = text.includes(searchTerm) ? '' : 'none';
            }
        }

        function handleCustomerSelect() {
            const select = document.getElementById("customerSelect");
            const selectedOption = select.options[select.selectedIndex];
            document.getElementById("selCustomer").textContent = selectedOption.text;
            document.getElementById("customerId").value = selectedOption.value;
        }

        function selectProduct(id) {
            const p = products.find(x => x.id === id);

            if (p.stock <= 0) {
                alert("Cannot add product. Stock is 0.");
                return;
            }

            const alreadyAdded = Array.from(document.querySelectorAll('input[name="productId"]'))
                .some(input => input.value === id);
            if (alreadyAdded) { alert("This product is already added."); return; }

            const tbody = document.getElementById('itemRows');
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${p.name}<input type="hidden" name="productId" value="${p.id}"></td>
                <td><input type="number" name="quantity" value="1" min="1" max="${p.stock}" onchange="updateTotals(this)" style="width:60px;"></td>
                <td><input type="number" name="unitPrice" value="${p.price}" readonly style="width:80px;"></td>
                <td><input type="number" name="totalPrice" value="${p.price.toFixed(2)}" readonly style="width:90px;"></td>
                <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
            `;
            tbody.appendChild(row);
            updateTotals(row.querySelector('input[name=quantity]'));
        }

        function removeRow(btn) { btn.closest("tr").remove(); updateSummary(); }

        function updateTotals(input) {
            const row = input.closest("tr");
            const qty = parseFloat(row.querySelector('input[name=quantity]').value) || 0;
            const price = parseFloat(row.querySelector('input[name=unitPrice]').value) || 0;
            row.querySelector('input[name=totalPrice]').value = (qty*price).toFixed(2);
            updateSummary();
        }

        function updateSummary() {
            let total=0;
            document.querySelectorAll('#itemRows tr').forEach(r=>{ total += parseFloat(r.querySelector('input[name=totalPrice]').value)||0; });
            document.getElementById("grandTotal").textContent = total.toFixed(2);
            document.getElementById("totalAmount").value = total.toFixed(2);
        }

        window.onload = filterProducts;
    </script>
</head>
<body>
<div class="wrap">
    <h1>Create New Invoice</h1>
    <form id="billForm" action="BillController" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="customerId" id="customerId">
        <input type="hidden" name="billNumber" value="<%= billNumber %>">
        <input type="hidden" name="totalAmount" id="totalAmount" value="0">

        <div class="container">
            <div class="panel left">
                <h3>Select Product</h3>
                <input type="text" id="productSearch" class="search-input" placeholder="Search product..." oninput="filterProducts()">
                <div id="productList" class="list-box"></div>
            </div>

            <div class="panel right">
                <div class="panel">
                    <h3>Invoice Items</h3>
                    <table>
                        <thead>
                            <tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Total</th><th></th></tr>
                        </thead>
                        <tbody id="itemRows"></tbody>
                    </table>
                    <div class="summary-box">
                        <strong>Grand Total: LKR <span id="grandTotal">0.00</span></strong>
                    </div>
                </div>

                <div class="panel">
                    <h3>Customer & Invoice Info</h3>
                    <input type="text" id="customerSearch" class="search-input" placeholder="Search customer..." oninput="filterCustomerOptions()">
                    <select id="customerSelect" size="5" onchange="handleCustomerSelect()">
                        <% for (Customer c : customers) { %>
                        <option value="<%= c.getId() %>"><%= c.getName() %> (<%= c.getAccountNumber() %>)</option>
                        <% } %>
                    </select>
                    <p><strong>Selected:</strong> <span id="selCustomer">None</span></p>
                    <div class="info-grid">
                        <div><strong>Invoice No:</strong> <%= billNumber %></div>
                        <div><strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(now) %></div>
                        <div><strong>Time:</strong> <%= new java.text.SimpleDateFormat("HH:mm:ss").format(now) %></div>
                        <div><strong>Staff:</strong> <%= user.getUsername() %></div>
                    </div>
                    <br>
                    <button type="submit" class="btn btn-primary">Save Invoice</button>
                </div>
            </div>
        </div>
    </form>
</div>
</body>
</html>
