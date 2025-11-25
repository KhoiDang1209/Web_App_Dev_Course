<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .container { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); width: 100%; max-width: 400px; }
        h2 { text-align: center; color: #333; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #555; font-weight: 600; font-size: 14px; }
        input[type="password"] { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        
        .btn-submit {
            display: block;
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .btn-submit:hover { transform: translateY(-2px); }

        /* Message Styles */
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; font-weight: 500; font-size: 14px; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .link-back { display: block; text-align: center; margin-top: 20px; color: #666; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔒 Change Password</h2>
        
        <c:if test="${not empty message}">
            <div class="message success">
                ✅ ${message}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="message error">
                ❌ ${error}
            </div>
        </c:if>

        <form action="change-password" method="post">
            
            <div class="form-group">
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" required 
                       placeholder="Enter current password">
            </div>

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required 
                       placeholder="Enter new password">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required 
                       placeholder="Re-enter new password">
            </div>

            <button type="submit" class="btn-submit">Change Password</button>
        </form>
        
        <a href="student?action=list" class="link-back">← Back to Dashboard</a>
    </div>
</body>
</html>