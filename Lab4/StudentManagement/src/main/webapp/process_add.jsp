<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    // Original required field check
    if (studentCode == null || studentCode.trim().isEmpty() ||
        fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("add_student.jsp?error=Required fields are missing");
        return;
    }
    
    // --- NEW VALIDATION (6.2) ---
    // Validate student code pattern: 2 uppercase letters + 3+ digits
    String studentCodePattern = "[A-Z]{2}[0-9]{3,}";
    if (!studentCode.matches(studentCodePattern)) {
        response.sendRedirect("add_student.jsp?error=Invalid Code format (e.g., SV001)");
        return;
    }
    // --- END NEW VALIDATION (6.2) ---
    
    
    // --- NEW VALIDATION (6.1) ---
    // Validate email format if it's not empty
    // This new pattern requires a dot in the domain part (e.g., gmail.com)
    String emailPattern = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";

    if (email != null && !email.trim().isEmpty()) {
        if (!email.matches(emailPattern)) { // Check against the new pattern
            // Invalid email format
            response.sendRedirect("add_student.jsp?error=Invalid email format"); // or edit_student.jsp
            return;
        }
    }
    // --- END NEW VALIDATION (6.1) ---
    
    
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
        
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentCode);
        pstmt.setString(2, fullName);
        pstmt.setString(3, email);
        pstmt.setString(4, major);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student added successfully");
        } else {
            response.sendRedirect("add_student.jsp?error=Failed to add student");
        }
        
    } catch (ClassNotFoundException e) {
        response.sendRedirect("add_student.jsp?error=Driver not found");
        e.printStackTrace();
    } catch (SQLException e) {
    
        int errorCode = e.getErrorCode();

        // MSSQL error code for PRIMARY KEY violation is 2627
        // MSSQL error code for UNIQUE constraint violation is 2601
        if (errorCode == 2627 || errorCode == 2601) {
            response.sendRedirect("add_student.jsp?error=Student code already exists");
        } else {
            // Other database error
            response.sendRedirect("add_student.jsp?error=Database error: " + e.getMessage());
        }
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