package com.pahanaedu.dao;

import com.pahanaedu.model.*;

import java.sql.*;
import java.util.*;

public class BillDAO {
    private final Connection conn = DBConnectionFactory.getConnection();

    public void addBill(Bill bill) throws Exception {
        String billSQL = "INSERT INTO bill (bill_number, customer_id, staff_id, bill_date, total_amount) VALUES (?, ?, ?, ?, ?)";
        String itemSQL = "INSERT INTO bill_item (bill_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false);

            // Insert into bill table
            PreparedStatement psBill = conn.prepareStatement(billSQL, Statement.RETURN_GENERATED_KEYS);
            psBill.setString(1, bill.getBillNumber());
            psBill.setInt(2, bill.getCustomer().getId());
            psBill.setInt(3, bill.getStaff().getId());
            psBill.setTimestamp(4, new Timestamp(bill.getBillDate().getTime()));
            psBill.setDouble(5, bill.getTotalAmount());
            psBill.executeUpdate();

            ResultSet rs = psBill.getGeneratedKeys();
            if (!rs.next()) throw new SQLException("Failed to retrieve bill ID.");
            int billId = rs.getInt(1);

            // Insert bill items and update stock
            PreparedStatement psItem = conn.prepareStatement(itemSQL);
            for (BillItem item : bill.getItems()) {
                // Check stock before adding
                int currentStock = getProductStock(item.getProduct().getId());
                if (item.getQuantity() > currentStock) {
                    throw new Exception("Insufficient stock for product: " + item.getProduct().getName());
                }

                psItem.setInt(1, billId);
                psItem.setInt(2, item.getProduct().getId());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getUnitPrice());
                psItem.setDouble(5, item.getTotalPrice());
                psItem.addBatch();

                updateStockAfterSale(item.getProduct().getId(), item.getQuantity());
            }

            psItem.executeBatch();
            conn.commit();
        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ignored) {}
        }
    }

    public List<Bill> getAllBills() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM bill ORDER BY bill_date DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            CustomerDAO cdao = new CustomerDAO();
            UserDAO udao = new UserDAO();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setBillNumber(rs.getString("bill_number"));
                bill.setBillDate(rs.getTimestamp("bill_date"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setCustomer(cdao.getCustomerById(rs.getInt("customer_id")));
                bill.setStaff(udao.getUserById(rs.getInt("staff_id")));
                list.add(bill);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Bill getBillByNumber(String billNumber) {
        Bill bill = null;

        try {
            String sql = "SELECT * FROM bill WHERE bill_number = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, billNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setBillNumber(billNumber);
                bill.setBillDate(rs.getTimestamp("bill_date"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setCustomer(new CustomerDAO().getCustomerById(rs.getInt("customer_id")));
                bill.setStaff(new UserDAO().getUserById(rs.getInt("staff_id")));

                List<BillItem> items = new ArrayList<>();
                PreparedStatement psi = conn.prepareStatement("SELECT * FROM bill_item WHERE bill_id = ?");
                psi.setInt(1, bill.getId());
                ResultSet rsi = psi.executeQuery();

                while (rsi.next()) {
                    BillItem item = new BillItem();
                    item.setQuantity(rsi.getInt("quantity"));
                    item.setUnitPrice(rsi.getDouble("unit_price"));
                    item.setTotalPrice(rsi.getDouble("total_price"));
                    item.setProduct(new ProductDAO().getProductById(rsi.getInt("product_id")));
                    items.add(item);
                }

                bill.setItems(items);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bill;
    }

    public double getTotalSalesToday() {
        String sql = "SELECT SUM(total_amount) FROM bill WHERE DATE(bill_date) = CURDATE()";
        return getSalesTotal(sql);
    }

    public double getTotalSalesLast7Days() {
        String sql = "SELECT SUM(total_amount) FROM bill WHERE bill_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        return getSalesTotal(sql);
    }

    public double getTotalSalesLast30Days() {
        String sql = "SELECT SUM(total_amount) FROM bill WHERE bill_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
        return getSalesTotal(sql);
    }

    private double getSalesTotal(String sql) {
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public int getProductStock(int productId) {
        String sql = "SELECT quantity FROM products WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("quantity");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void updateStockAfterSale(int productId, int quantitySold) {
        String sql = "UPDATE products SET quantity = quantity - ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantitySold);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
