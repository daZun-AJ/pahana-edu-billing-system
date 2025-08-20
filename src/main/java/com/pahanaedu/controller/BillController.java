package com.pahanaedu.controller;

import com.pahanaedu.dao.*;
import com.pahanaedu.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/BillController")
public class BillController extends HttpServlet {
    private BillDAO billDAO;
    private CustomerDAO customerDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        billDAO = new BillDAO();
        customerDAO = new CustomerDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            req.setAttribute("customers", customerDAO.getAllCustomers());
            req.setAttribute("products", productDAO.getAllProducts());
            req.getRequestDispatcher("/views/add-bill.jsp").forward(req, resp);

        } else if ("view".equals(action)) {
            String billNumber = req.getParameter("billNumber");
            if (billNumber == null || billNumber.trim().isEmpty()) {
                resp.sendRedirect("BillController?action=list&msg=Invalid+Bill+Number");
                return;
            }

            Bill bill = billDAO.getBillByNumber(billNumber);
            if (bill == null) {
                resp.sendRedirect("BillController?action=list&msg=Bill+Not+Found");
                return;
            }

            req.setAttribute("bill", bill);
            req.getRequestDispatcher("/views/InvoiceView.jsp").forward(req, resp);

        } else if ("records".equals(action)) {
            List<Bill> bills = billDAO.getAllBills();
            req.setAttribute("bills", bills);

            req.setAttribute("totalSalesToday", billDAO.getTotalSalesToday());
            req.setAttribute("totalSales7Days", billDAO.getTotalSalesLast7Days());
            req.setAttribute("totalSales30Days", billDAO.getTotalSalesLast30Days());

            req.setAttribute("customersCount", new CustomerDAO().getAllCustomers().size());
            req.setAttribute("productsCount", new ProductDAO().getAllProducts().size());
            req.setAttribute("usersCount", new UserDAO().getAllUsers().size());

            req.getRequestDispatcher("/views/view-records.jsp").forward(req, resp);
        } else { // default or list
            List<Bill> bills = billDAO.getAllBills();
            req.setAttribute("bills", bills);

            req.setAttribute("totalSalesToday", billDAO.getTotalSalesToday());
            req.setAttribute("totalSales7Days", billDAO.getTotalSalesLast7Days());
            req.setAttribute("totalSales30Days", billDAO.getTotalSalesLast30Days());

            req.getRequestDispatcher("/views/bill-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("add".equals(req.getParameter("action"))) {
            try {
                HttpSession session = req.getSession(false);
                if (session == null || session.getAttribute("user") == null) {
                    resp.sendRedirect("login.jsp?msg=Please+login+first");
                    return;
                }

                User staff = (User) session.getAttribute("user");
                String billNumber = req.getParameter("billNumber");
                int customerId = Integer.parseInt(req.getParameter("customerId"));
                double totalAmount = Double.parseDouble(req.getParameter("totalAmount"));

                Bill bill = new Bill();
                bill.setBillNumber(billNumber);
                bill.setCustomer(customerDAO.getCustomerById(customerId));
                bill.setStaff(staff);
                bill.setBillDate(new Date());
                bill.setTotalAmount(totalAmount);

                List<BillItem> items = new ArrayList<>();
                String[] productIds = req.getParameterValues("productId");
                String[] quantities = req.getParameterValues("quantity");
                String[] unitPrices = req.getParameterValues("unitPrice");
                String[] totalPrices = req.getParameterValues("totalPrice");

                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int qty = Integer.parseInt(quantities[i]);
                    double unitPrice = Double.parseDouble(unitPrices[i]);
                    double totalPrice = Double.parseDouble(totalPrices[i]);

                    Product product = productDAO.getProductById(productId);
                    BillItem item = new BillItem();
                    item.setProduct(product);
                    item.setQuantity(qty);
                    item.setUnitPrice(unitPrice);
                    item.setTotalPrice(totalPrice);

                    items.add(item);
                }

                bill.setItems(items);

                // Server-side stock validation
                try {
                    billDAO.addBill(bill);
                    resp.sendRedirect("BillController?action=list&msg=Bill+Created");
                } catch (Exception e) {
                    resp.sendRedirect("BillController?action=new&msg=" + e.getMessage().replace(" ", "+"));
                }

            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("BillController?action=list&msg=Error+Creating+Bill");
            }
        }
    }
}
