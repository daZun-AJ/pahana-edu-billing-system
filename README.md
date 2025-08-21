# Pahana Edu Billing System

## Technologies Used:
- **Frontend**: Java (JSP, Servlets)
- **Backend**: MySQL, Tomcat
- **Database**: MySQL

## Project Overview
The Pahana Edu Billing System is a web-based application designed to manage customer accounts, generate bills, and automate various billing processes for Pahana Edu Bookstore. Built using Java (JSP, Servlets), MySQL, and Tomcat, this system streamlines the management of customers, products, and bills.

### Key Features:
- **User Management**: Admins can manage both admin and staff user accounts.
- **User Online Status**: Monitor if users are currently logged in.
- **Product Management**: Admins can add, update, and delete products in the inventory.
- **Customer Management**: Manage customer details and accounts.
- **Report Viewing**: Only admins can view reports based on customer activity and sales.
- **Log Viewing**: Track system activities.
- **Bill Creation**: Admins and staff can create bills, view them, and generate invoices for customers.
- **Help Section**: Provides assistance for system users.

## Database Schema

```sql
-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff') NOT NULL,
    isLogin BOOLEAN DEFAULT FALSE
);

-- Customers Table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(100)
);

-- Products Table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    category VARCHAR(50)
);

-- Bill Table
CREATE TABLE bill (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bill_number VARCHAR(100) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    staff_id INT NOT NULL,
    bill_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DOUBLE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bill Item Table
CREATE TABLE bill_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bill(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
