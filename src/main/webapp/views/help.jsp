<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pahanaedu.model.User" %>
<%
    // Session guard
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
<title>Pahana edu — Help & Support</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    :root{
        --bg:#ffffff; --text:#0f172a; --muted:#64748b; --primary:#1d4ed8;
        --card:#ffffff; --card-border:#e5e7eb; --danger:#ef4444; --badge:#e6f0ff; --badge-text:#0b61ff;
        --success:#22c55e; --warning:#f59e0b; --info:#3b82f6;
    }
    *{box-sizing:border-box;}
    html,body{margin:0;background:var(--bg);color:var(--text);font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif;}
    a{color:inherit;text-decoration:none;}
    .wrap{max-width:1000px;margin:28px auto;padding:0 20px;}

    /* Top bar */
    .topbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;}
    .brand{font-weight:700;letter-spacing:.2px; font-size:18px;}
    .right{display:flex;gap:40px;align-items:center;}
    .userbox{font-size:14px;line-height:1.1;}
    .username {font-size: 16px;}
    .badge{display:inline-block;font-size:12px;padding:3px 8px;border-radius:9999px;background:var(--badge);color:var(--badge-text);margin-top:6px;}
    .logout{
        border:0;background:var(--danger);color:#fff;padding:15px 20px;border-radius:9999px;
        cursor:pointer; font-size: 14px;  display: inline-flex; align-items: center; justify-content: center; gap: 6px;
    }

    /* Heading */
    .title{font-size:42px;font-weight:600;text-align:center;margin:30px 0 8px;}
    .subtitle{font-size:20px;font-weight:500;text-align:center;margin:0 0 28px;color:var(--muted);}

    /* Navigation */
    .nav{display:flex;gap:20px;margin:30px 0;flex-wrap:wrap;justify-content:center;}
    .nav-item{
        padding:12px 24px;border-radius:9999px;background:var(--card);border:2px solid var(--card-border);
        cursor:pointer;transition:all 0.3s;font-weight:500;color:var(--text);
    }
    .nav-item:hover{border-color:var(--primary);color:var(--primary);transform:translateY(-2px);}
    .nav-item.active{background:var(--primary);color:#fff;border-color:var(--primary);}

    /* Help content */
    .help-section{display:none;margin-bottom:30px;}
    .help-section.active{display:block;}
    
    .card{
        background:var(--card); border:1px solid var(--card-border); border-radius:18px; padding:24px; margin-bottom:22px;
        transition:box-shadow 0.3s,border-color 0.3s;
    }
    .card:hover{box-shadow:0 8px 25px rgba(0,0,0,0.1);border-color:var(--primary);}
    .card h3{margin:0 0 14px;font-size:20px;display:flex;align-items:center;gap:10px;}
    .card .icon{width:24px;height:24px;background:var(--primary);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:12px;font-weight:bold;}
    
    /* FAQ styling */
    .faq{margin-bottom:16px;border:1px solid var(--card-border);border-radius:12px;overflow:hidden;}
    .faq summary{
        cursor:pointer;font-weight:600;font-size:16px;padding:16px 20px;background:var(--card);
        display:flex;align-items:center;justify-content:space-between;transition:background 0.3s;
        list-style:none;
    }
    .faq summary::-webkit-details-marker{display:none;}
    .faq summary:hover{background:#f8fafc;}
    .faq summary::after{content:"▼";transition:transform 0.3s;color:var(--muted);}
    .faq[open] summary::after{transform:rotate(180deg);}
    .faq-content{padding:16px 20px;background:#fafbfc;border-top:1px solid var(--card-border);}
    .faq-content p{margin:0 0 10px;color:var(--muted);line-height:1.6;}
    .faq-content ul{margin:10px 0;padding-left:20px;}
    .faq-content li{margin:6px 0;color:var(--muted);}

    /* Step by step guides */
    .steps{list-style:none;padding:0;margin:0;}
    .step{
        display:flex;align-items:flex-start;gap:16px;padding:16px 0;border-bottom:1px solid #f1f5f9;
        position:relative;
    }
    .step:last-child{border-bottom:none;}
    .step-number{
        background:var(--primary);color:#fff;border-radius:50%;width:32px;height:32px;
        display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:14px;flex-shrink:0;
    }
    .step-content h4{margin:0 0 8px;font-size:16px;font-weight:600;}
    .step-content p{margin:0;color:var(--muted);line-height:1.6;}

    /* Contact cards */
    .contact-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;}
    .contact-card{
        background:linear-gradient(135deg,var(--primary) 0%,#3b82f6 100%);color:#fff;
        border-radius:18px;padding:24px;text-align:center;position:relative;overflow:hidden;
    }
    .contact-card::before{
        content:"";position:absolute;top:-50%;right:-50%;width:100%;height:100%;
        background:rgba(255,255,255,0.1);transform:rotate(45deg);
    }
    .contact-card h4{margin:0 0 12px;font-size:18px;}
    .contact-card p{margin:0 0 16px;opacity:0.9;}
    .contact-card a{
        background:rgba(255,255,255,0.2);color:#fff;padding:10px 20px;border-radius:9999px;
        font-weight:600;display:inline-block;transition:background 0.3s;
    }
    .contact-card a:hover{background:rgba(255,255,255,0.3);}

    /* Alert boxes */
    .alert{
        padding:16px 20px;border-radius:12px;margin:16px 0;display:flex;align-items:center;gap:12px;
        font-weight:500;
    }
    .alert-info{background:#eff6ff;color:#1e40af;border-left:4px solid var(--info);}
    .alert-warning{background:#fffbeb;color:#92400e;border-left:4px solid var(--warning);}
    .alert-success{background:#f0fdf4;color:#166534;border-left:4px solid var(--success);}
    .alert-icon{font-weight:bold;font-size:18px;}

    /* Search */
    .search-box{margin:20px 0;text-align:center;}
    .search-input{
        padding:14px 20px;font-size:16px;border:2px solid var(--card-border);border-radius:9999px;
        width:100%;max-width:500px;transition:border-color 0.3s;
    }
    .search-input:focus{outline:none;border-color:var(--primary);}

    /* Back button */
    .back{
        display:inline-flex; align-items:center; gap:10px; padding:12px 24px; border-radius:9999px; 
        background:var(--primary); color:#fff; cursor:pointer; text-decoration:none; font-weight:600;
        transition:all 0.3s;
    }
    .back:hover{transform:translateY(-2px);box-shadow:0 4px 12px rgba(29,78,216,0.3);}

    /* Responsive */
    @media (max-width:768px){
        .title{font-size:32px;}
        .nav{gap:10px;}
        .nav-item{padding:10px 16px;font-size:14px;}
        .contact-grid{grid-template-columns:1fr;}
        .wrap{padding:0 15px;}
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
    			<div class="badge">
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
    <h1 class="title">Help & Support Center</h1>
    <div class="subtitle">Everything you need to know about managing Pahana edu system</div>

    <!-- Search -->
    <div class="search-box">
        <input type="text" class="search-input" id="searchInput" placeholder="Search for help topics, features, or questions...">
    </div>
    
    <!-- Back to Dashboard -->
    <div style="text-align:center;margin:40px 0;">
        <a href="<%= user.getRole().equalsIgnoreCase("admin") ? "admin-dashboard.jsp" : "staff-dashboard.jsp" %>" class="back">
            ← Back to Dashboard
        </a>
    </div>

    <!-- Navigation -->
    <div class="nav">
        <div class="nav-item active" onclick="showSection('getting-started')">Getting Started</div>
        <div class="nav-item" onclick="showSection('user-management')">User Management</div>
        <div class="nav-item" onclick="showSection('product-management')">Products</div>
        <div class="nav-item" onclick="showSection('customer-management')">Customers</div>
        <div class="nav-item" onclick="showSection('billing')">Billing</div>
        <div class="nav-item" onclick="showSection('reports')">Reports</div>
        <div class="nav-item" onclick="showSection('troubleshooting')">Troubleshooting</div>
        <div class="nav-item" onclick="showSection('contact')">Contact Support</div>
    </div>

    <!-- Getting Started Section -->
    <div id="getting-started" class="help-section active">
        <div class="card">
            <h3><span class="icon">🚀</span>Welcome to Pahana edu Admin</h3>
            <div class="alert alert-info">
                <span class="alert-icon">ℹ️</span>
                <span>This guide will help you understand all the features available in the admin dashboard.</span>
            </div>
            
            <ol class="steps">
                <li class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Dashboard Overview</h4>
                        <p>Access your main dashboard to see system statistics, recent activities, and quick actions.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Navigation Menu</h4>
                        <p>Use the top navigation to access different sections: Users, Products, Customers, Billing, and Records.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Quick Actions</h4>
                        <p>Most common tasks are available directly from the dashboard for quick access.</p>
                    </div>
                </li>
            </ol>
        </div>

        <div class="card">
            <h3><span class="icon">📊</span>Dashboard Features</h3>
            <details class="faq">
                <summary>What information is shown on the dashboard?</summary>
                <div class="faq-content">
                    <p>The admin dashboard displays:</p>
                    <ul>
                        <li>Total users, products, and customers count</li>
                        <li>Recent billing activities</li>
                        <li>System statistics and metrics</li>
                        <li>Quick access buttons for common tasks</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>How often is the dashboard data updated?</summary>
                <div class="faq-content">
                    <p>Dashboard data is updated in real-time. Refresh your browser to see the latest information.</p>
                </div>
            </details>
        </div>
    </div>

    <!-- User Management Section -->
    <div id="user-management" class="help-section">
        <div class="card">
            <h3><span class="icon">👥</span>Managing System Users</h3>
            
            <ol class="steps">
                <li class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Adding New Users</h4>
                        <p>Go to User Management → Add New User. Fill in username, password, and select role (Admin or Staff).</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Editing User Details</h4>
                        <p>Click the edit icon next to any user to modify their information or change their role.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>User Status Monitoring</h4>
                        <p>View which users are currently logged in through the online/offline status indicators.</p>
                    </div>
                </li>
            </ol>
        </div>

        <div class="card">
            <h3><span class="icon">🔐</span>User Roles & Permissions</h3>
            <details class="faq">
                <summary>What's the difference between Admin and Staff roles?</summary>
                <div class="faq-content">
                    <p><strong>Admin users can:</strong></p>
                    <ul>
                        <li>Manage all users (create, edit, delete)</li>
                        <li>Access detailed reports and analytics</li>
                        <li>Manage system settings</li>
                        <li>Full access to all features</li>
                    </ul>
                    <p><strong>Staff users can:</strong></p>
                    <ul>
                        <li>Manage products and customers</li>
                        <li>Process billing and transactions</li>
                        <li>View basic reports</li>
                        <li>Limited administrative access</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>How do I reset a user's password?</summary>
                <div class="faq-content">
                    <p>Go to User Management, find the user, click Edit, and enter a new password. The user will need to use the new password on their next login.</p>
                </div>
            </details>
        </div>

        <div class="alert alert-warning">
            <span class="alert-icon">⚠️</span>
            <span>Be careful when deleting users - this action cannot be undone and will remove all associated data.</span>
        </div>
    </div>

    <!-- Product Management Section -->
    <div id="product-management" class="help-section">
        <div class="card">
            <h3><span class="icon">📦</span>Managing Products</h3>
            
            <ol class="steps">
                <li class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Adding Products</h4>
                        <p>Navigate to Product Management → Add New Product. Enter product code, name, price, quantity, and category.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Updating Inventory</h4>
                        <p>Edit existing products to update prices, quantities, or other details as needed.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Product Categories</h4>
                        <p>Organize products using predefined categories: Books, Stationery, Paper Products, Office Supplies, Art and Craft, School Accessories.</p>
                    </div>
                </li>
            </ol>
        </div>

        <div class="card">
            <h3><span class="icon">🔍</span>Product Management FAQs</h3>
            
            <details class="faq">
                <summary>How do I track low stock items?</summary>
                <div class="faq-content">
                    <p>Use the search function in Product Management to filter and sort products by quantity. Consider setting up alerts for items below a certain threshold.</p>
                </div>
            </details>
            
            <details class="faq">
                <summary>Can I import products in bulk?</summary>
                <div class="faq-content">
                    <p>Currently, products need to be added individually through the Add New Product form. For large inventories, contact support for bulk import options.</p>
                </div>
            </details>
            
            <details class="faq">
                <summary>What happens when I delete a product?</summary>
                <div class="faq-content">
                    <p>Deleting a product removes it from your inventory permanently. Historical billing records will retain the product information for reporting purposes.</p>
                </div>
            </details>
        </div>
    </div>

    <!-- Customer Management Section -->
    <div id="customer-management" class="help-section">
        <div class="card">
            <h3><span class="icon">👤</span>Customer Management</h3>
            
            <ol class="steps">
                <li class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Adding Customers</h4>
                        <p>Go to Customer Management → Add New Customer. Fill in account number, name, address, phone, and email.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Customer Search</h4>
                        <p>Use the search bar to quickly find customers by name or account number.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Updating Customer Info</h4>
                        <p>Click the edit icon to update customer details, contact information, or addresses.</p>
                    </div>
                </li>
            </ol>
        </div>

        <div class="card">
            <h3><span class="icon">📋</span>Customer Data Guidelines</h3>
            <details class="faq">
                <summary>What information is required for new customers?</summary>
                <div class="faq-content">
                    <p>Required fields include:</p>
                    <ul>
                        <li>Unique account number</li>
                        <li>Full name</li>
                        <li>Address</li>
                        <li>Phone number</li>
                        <li>Valid email address</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>How should account numbers be formatted?</summary>
                <div class="faq-content">
                    <p>Account numbers should be unique identifiers. Consider using a consistent format like "CUST001", "CUST002" or a date-based system.</p>
                </div>
            </details>
        </div>
    </div>

    <!-- Billing Section -->
    <div id="billing" class="help-section">
        <div class="card">
            <h3><span class="icon">💳</span>Billing & Transactions</h3>
            
            <ol class="steps">
                <li class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h4>Creating Bills</h4>
                        <p>From the dashboard, click "Create New Bill" and select customer, add products, and process payment.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h4>Bill Management</h4>
                        <p>View all bills, search by date or customer, and generate reports for accounting purposes.</p>
                    </div>
                </li>
                <li class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h4>Payment Processing</h4>
                        <p>Record payments, track outstanding amounts, and maintain transaction history.</p>
                    </div>
                </li>
            </ol>
        </div>

        <div class="alert alert-info">
            <span class="alert-icon">💡</span>
            <span>Always verify product availability and customer information before finalizing bills to avoid errors.</span>
        </div>
    </div>

    <!-- Reports Section -->
    <div id="reports" class="help-section">
        <div class="card">
            <h3><span class="icon">📊</span>Reports & Analytics</h3>
            <p>Access comprehensive reports through the Records section of your dashboard.</p>
            
            <details class="faq">
                <summary>What reports are available?</summary>
                <div class="faq-content">
                    <ul>
                        <li>Daily, weekly, and monthly sales reports</li>
                        <li>Product inventory status</li>
                        <li>Customer transaction history</li>
                        <li>Revenue analytics and trends</li>
                        <li>User activity logs</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>How can I export report data?</summary>
                <div class="faq-content">
                    <p>Currently, reports are displayed on-screen. For data exports, contact support or use your browser's print function to save as PDF.</p>
                </div>
            </details>
        </div>
    </div>

    <!-- Troubleshooting Section -->
    <div id="troubleshooting" class="help-section">
        <div class="card">
            <h3><span class="icon">🔧</span>Common Issues & Solutions</h3>
            
            <details class="faq">
                <summary>I can't log in to my account</summary>
                <div class="faq-content">
                    <p>Try these steps:</p>
                    <ul>
                        <li>Verify your username and password are correct</li>
                        <li>Check if Caps Lock is enabled</li>
                        <li>Clear your browser cache and cookies</li>
                        <li>Contact another admin to reset your password</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>The system is running slowly</summary>
                <div class="faq-content">
                    <p>Performance issues can be caused by:</p>
                    <ul>
                        <li>Browser cache - try clearing it</li>
                        <li>Multiple browser tabs - close unnecessary ones</li>
                        <li>Large datasets - use search filters to narrow results</li>
                        <li>Network connectivity - check your internet connection</li>
                    </ul>
                </div>
            </details>
            
            <details class="faq">
                <summary>I accidentally deleted important data</summary>
                <div class="faq-content">
                    <p>Contact support immediately with details about what was deleted and when. Depending on the type of data and timing, recovery may be possible.</p>
                </div>
            </details>
            
            <details class="faq">
                <summary>Error messages when creating bills</summary>
                <div class="faq-content">
                    <p>Common causes include:</p>
                    <ul>
                        <li>Insufficient product quantity</li>
                        <li>Invalid customer selection</li>
                        <li>Missing required fields</li>
                        <li>Network timeout - try refreshing and resubmitting</li>
                    </ul>
                </div>
            </details>
        </div>

        <div class="alert alert-warning">
            <span class="alert-icon">⚠️</span>
            <span>If you encounter persistent issues, check system logs under the admin tools or contact technical support.</span>
        </div>
    </div>

    <!-- Contact Support Section -->
    <div id="contact" class="help-section">
        <div class="card">
            <h3><span class="icon">📞</span>Get Help When You Need It</h3>
            <p>Our support team is here to help you with any questions or technical issues.</p>
        </div>

        <div class="contact-grid">
            <div class="contact-card">
                <h4>📧 Email Support</h4>
                <p>Get detailed help with your questions</p>
                <a>support@pahanaedu.com</a>
            </div>
            
            <div class="contact-card">
                <h4>📱 Phone Support</h4>
                <p>Immediate assistance for urgent issues</p>
                <a>+94 77 123 4567</a>
            </div>
            
            <div class="contact-card">
                <h4>🕒 Business Hours</h4>
                <p>Monday - Friday<br>8:00 AM - 6:00 PM</p>
                <a href="#" onclick="alert('Support available during business hours')">Check Status</a>
            </div>
        </div>

        <div class="card">
            <h3><span class="icon">📝</span>Before Contacting Support</h3>
            <p>To help us assist you quickly, please have the following information ready:</p>
            <ul>
                <li>Your username and role</li>
                <li>Description of the issue you're experiencing</li>
                <li>Steps you've already tried</li>
                <li>Any error messages you've seen</li>
                <li>Browser and operating system information</li>
            </ul>
        </div>

        <div class="alert alert-success">
            <span class="alert-icon">✅</span>
            <span>Most common questions are answered in this help center. Try searching above before contacting support.</span>
        </div>
    </div>

    
</div>

<script>
    function confirmLogout(){
        return confirm("Log out from the admin session?");
    }

    function showSection(sectionId) {
        // Hide all sections
        document.querySelectorAll('.help-section').forEach(section => {
            section.classList.remove('active');
        });
        
        // Remove active class from nav items
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        
        // Show selected section
        document.getElementById(sectionId).classList.add('active');
        
        // Add active class to clicked nav item
        event.target.classList.add('active');
        
        // Scroll to top of content
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    // Search functionality
    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const allContent = document.querySelectorAll('.help-section');
        
        if (searchTerm === '') {
            // Reset to show current active section only
            return;
        }
        
        // Hide all sections first
        allContent.forEach(section => {
            section.classList.remove('active');
        });
        
        // Show sections that match search term
        let hasResults = false;
        allContent.forEach(section => {
            const text = section.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                section.classList.add('active');
                hasResults = true;
            }
        });
        
        // Remove active from nav items during search
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        
        if (!hasResults) {
            // Show a "no results" message
            document.querySelector('.help-section').innerHTML = `
                <div class="card" style="text-align:center;padding:40px;">
                    <h3>🔍 No results found</h3>
                    <p>Try different keywords or browse the categories above.</p>
                </div>
            `;
            document.querySelector('.help-section').classList.add('active');
        }
    });

    // Highlight search terms in FAQ
    function highlightSearchTerm(text, term) {
        if (!term) return text;
        const regex = new RegExp(`(${term})`, 'gi');
        return text.replace(regex, '<mark style="background:#fef3c7;padding:2px 4px;border-radius:4px;">$1</mark>');
    }

    // Keyboard navigation
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.getElementById('searchInput').value = '';
            showSection('getting-started');
        }
    });

    // Auto-expand FAQ items that match search
    function expandMatchingFAQs(searchTerm) {
        if (!searchTerm) return;
        
        document.querySelectorAll('.faq').forEach(faq => {
            const text = faq.textContent.toLowerCase();
            if (text.includes(searchTerm.toLowerCase())) {
                faq.setAttribute('open', 'true');
            }
        });
    }

    // Enhanced search with FAQ expansion
    let searchTimeout;
    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            expandMatchingFAQs(searchTerm);
        }, 300);
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Toast notification for contact actions
    function showToast(message) {
        const toast = document.createElement('div');
        toast.style.cssText = `
            position: fixed; top: 20px; right: 20px; background: #22c55e; color: white;
            padding: 12px 20px; border-radius: 8px; z-index: 1000; font-weight: 600;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15); transform: translateX(100%);
            transition: transform 0.3s ease;
        `;
        toast.textContent = message;
        document.body.appendChild(toast);
        
        setTimeout(() => toast.style.transform = 'translateX(0)', 100);
        setTimeout(() => {
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => document.body.removeChild(toast), 300);
        }, 3000);
    }

    // Add click handlers for contact cards
    document.querySelectorAll('.contact-card a').forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.href.startsWith('mailto:')) {
                showToast('Opening email client...');
            } else if (this.href.startsWith('tel:')) {
                showToast('Initiating phone call...');
            }
        });
    });

    // Print functionality
    function printHelp() {
        window.print();
    }

    // Add print styles
    const printStyles = document.createElement('style');
    printStyles.textContent = `
        @media print {
            .topbar, .logout, .nav, .search-box { display: none !important; }
            .card { break-inside: avoid; margin-bottom: 20px; }
            .help-section { display: block !important; }
            body { font-size: 12pt; line-height: 1.4; }
            .title { font-size: 24pt; }
        }
    `;
    document.head.appendChild(printStyles);
</script>
</body>
</html>