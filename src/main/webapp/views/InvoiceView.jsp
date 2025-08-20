<%@ page import="java.util.*, com.pahanaedu.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    List<BillItem> items = bill.getItems();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Invoice - <%= bill.getBillNumber() %></title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
    body {
        font-family: ui-sans-serif, system-ui, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        background: #fff;
        color: #0f172a;
        margin: 30px auto;
        max-width: 900px;
        padding: 0 20px;
    }

    h1, h2, h3 {
        margin: 0 0 10px 0;
        font-weight: 600;
        color: #1d4ed8;
    }

    .header, .customer-info, .invoice-items, .footer {
        margin-bottom: 30px;
        padding-bottom: 10px;
        border-bottom: 1px solid #e5e7eb;
    }

    .header p, .customer-info p {
        margin: 4px 0;
        font-size: 15px;
        color: #334155;
    }

    .btn-primary {
        background: #1d4ed8;
        color: #fff;
        border: none;
        padding: 12px 24px;
        border-radius: 9999px;
        cursor: pointer;
        font-weight: 600;
        font-size: 16px;
        transition: background 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 20px;
        user-select: none;
    }
    .btn-primary:hover {
        background: #2563eb;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 15px;
        box-shadow: 0 2px 6px rgba(29, 78, 216, 0.1);
        border-radius: 10px;
        overflow: hidden;
    }

    thead {
        background: #1d4ed8;
        color: #fff;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 0.05em;
    }

    th, td {
        padding: 14px 18px;
        text-align: left;
    }

    tbody tr:nth-child(even) {
        background: #f9fafb;
    }

    tbody tr:hover {
        background: #e0e7ff;
        cursor: default;
    }

    tfoot td {
        font-weight: 700;
        border-top: 3px solid #1d4ed8;
        font-size: 16px;
        color: #1e40af;
    }

    tfoot td[colspan="3"] {
        text-align: right;
    }

    .footer {
        text-align: center;
        font-style: italic;
        color: #64748b;
        font-size: 14px;
    }

    /* Print styles */
    @media print {
        body {
            margin: 10mm;
            color: #000;
            max-width: 100%;
            padding: 0;
        }
        .btn-primary {
            display: none;
        }
        table, thead, tbody, th, td {
            border: 1px solid #000 !important;
        }
        thead {
            background: #ccc !important;
            color: #000 !important;
        }
    }
</style>
</head>
<body>

<button class="btn-primary" onclick="window.print()">🖨️ Print / Save PDF</button>

<div class="header">
    <h1>Invoice</h1>
    <p><strong>Bill Number:</strong> <%= bill.getBillNumber() %></p>
    <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(bill.getBillDate()) %></p>
</div>

<div class="customer-info">
    <h2>Customer Details</h2>
    <p><strong>Name:</strong> <%= bill.getCustomer().getName() %></p>
    <p><strong>Account Number:</strong> <%= bill.getCustomer().getAccountNumber() %></p>
</div>

<div class="invoice-items">
    <h2>Invoice Items</h2>
    <table>
        <thead>
            <tr>
                <th>Product</th>
                <th>Quantity</th>
                <th>Unit Price (LKR)</th>
                <th>Total (LKR)</th>
            </tr>
        </thead>
        <tbody>
            <%
                double grandTotal = 0;
                for (BillItem item : items) {
                    double totalPrice = item.getQuantity() * item.getUnitPrice();
                    grandTotal += totalPrice;
            %>
            <tr>
                <td><%= item.getProduct().getName() %></td>
                <td><%= item.getQuantity() %></td>
                <td><%= String.format("%,.2f", item.getUnitPrice()) %></td>
                <td><%= String.format("%,.2f", totalPrice) %></td>
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3">Grand Total (LKR):</td>
                <td><%= String.format("%,.2f", grandTotal) %></td>
            </tr>
        </tfoot>
    </table>
</div>

<div class="footer">
    <p>Thank you for your business!</p>
</div>

</body>
</html>
