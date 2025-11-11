<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idParam = request.getParameter("id");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Original required field check
    if (idParam == null || fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid data");
        return;
    }
    
    // --- NEW VALIDATION (6.1) ---
    // Validate email format if it's not empty
    if (email != null && !email.trim().isEmpty()) {
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            // Redirect back to the edit page with the ID and error
            response.sendRedirect("edit_student.jsp?id=" + idParam + "&error=Invalid email format");
            return;
        }
    }
    // --- END NEW VALIDATION (6.1) ---
    
    
    int studentId = Integer.parseInt(idParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // 2. Get the connection using the MSSQL URL format
        conn = DriverManager.getConnection(
            "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=true;trustServerCertificate=true",
            "sa", // 'sa' is a common default username for MSSQL
            "sa"
        );
        
        String sql = "UPDATE students SET full_name = ?, email = ?, major = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName);
        pstmt.setString(2, email);
        pstmt.setString(3, major);
        pstmt.setInt(4, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student updated successfully");
        } else {
            response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Update failed");
        }
        
    } catch (Exception e) {
        response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Error occurred");
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>