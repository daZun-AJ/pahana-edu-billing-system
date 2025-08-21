<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Pahana edu — Welcome</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
    :root{
        --bg:#ffffff; --text:#0f172a; --muted:#64748b; --primary:#1d4ed8;
        --card:#ffffff; --card-border:#e5e7eb; --danger:#ef4444; --badge:#22c55e; --badge-text:#ffffff;
    }
    *{box-sizing:border-box;}
    html,body{margin:0;background:var(--bg);color:var(--text);font-family:ui-sans-serif,system-ui,Segoe UI,Roboto,"Helvetica Neue",Arial,sans-serif;height:100vh;}
    a{color:inherit;text-decoration:none;}
    
    .container{
        height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;
        max-width:600px;margin:0 auto;padding:0 20px;text-align:center;
    }
    
    /* Brand header */
    .brand{
        font-weight:700;letter-spacing:.2px; font-size:24px;margin-bottom:60px;
        animation:fadeInDown 0.8s ease-out;
    }
    
    /* Main title */
    .title{
        font-size:48px;font-weight:600;margin:0 0 20px;
        animation:fadeInUp 0.8s ease-out 0.2s both;
    }
    
    /* Subtitle */
    .subtitle{
        font-size:20px;color:var(--muted);margin:0 0 16px;
        animation:fadeInUp 0.8s ease-out 0.4s both;
    }
    
    /* Description */
    .description{
        font-size:16px;color:var(--muted);margin:0 0 50px;line-height:1.6;
        animation:fadeInUp 0.8s ease-out 0.6s both;
    }
    
    /* Login button */
    .login-btn{
        display:inline-flex; align-items:center; gap:10px; padding:16px 32px; border-radius:9999px; 
        background:var(--primary); color:#fff; font-size:16px; font-weight:500; border:0; cursor:pointer;
        transition:all 0.2s ease;
        animation:fadeInUp 0.8s ease-out 0.8s both;
    }
    .login-btn:hover{
        background:#1e40af;
        transform:translateY(-2px);
        box-shadow:0 8px 20px rgba(29,78,216,0.3);
    }
    .login-btn:active{transform:translateY(0);}
    
    /* Simple animations */
    @keyframes fadeInDown {
        from{opacity:0;transform:translateY(-20px);}
        to{opacity:1;transform:translateY(0);}
    }
    
    @keyframes fadeInUp {
        from{opacity:0;transform:translateY(20px);}
        to{opacity:1;transform:translateY(0);}
    }

    /* Responsive */
    @media (max-width:768px){ 
        .title{font-size:36px} 
        .subtitle{font-size:18px}
        .brand{font-size:20px;margin-bottom:40px;}
        .container{padding:0 24px;}
    }
    @media (max-width:520px){ 
        .title{font-size:28px} 
        .subtitle{font-size:16px}
        .description{font-size:15px;}
        .login-btn{padding:14px 28px;font-size:15px;}
    }
</style>
</head>
<body>

<div class="container">
    <div class="brand">Pahana edu</div>
    
    <h1 class="title">Welcome to Pahana edu</h1>
    <div class="subtitle">Management Portal</div>
    <p class="description">
        Access your dashboard to manage customers, products, and billing operations efficiently.
    </p>
    
    <a href="views/login.jsp" class="login-btn">
        Login to Dashboard →
    </a>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const loginBtn = document.querySelector('.login-btn');
    
    // Simple click animation
    loginBtn.addEventListener('click', function(e) {
        this.style.transform = 'scale(0.95)';
        setTimeout(() => {
            this.style.transform = '';
        }, 100);
    });
});
</script>
</body>
</html>