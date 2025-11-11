<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }
        
        /* 7.2a: Improved Message Styling */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            display: flex; /* Added for icon alignment */
            align-items: center; /* Added for icon alignment */
        }
        .message::before {
            font-size: 1.2em;
            margin-right: 10px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .success::before {
            content: '✓'; /* Success icon */
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .error::before {
            content: '✗'; /* Error icon */
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        
        /* 7.2c: Responsive Table Wrapper */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px 15px;
            text-align: left;
            white-space: nowrap; /* Prevent headers from wrapping */
        }
        td {
            padding: 10px 15px;
            border-bottom: 1px solid #ddd;
            vertical-align: middle;
        }
        tr:hover { background-color: #f8f9fa; }
        td .action-link {
            white-space: nowrap; /* Prevent action links from wrapping */
        }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }

        /* Search Form Styles */
        .search-form {
            margin-bottom: 20px;
        }
        .search-form input[type="text"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 300px;
        }
        .search-form button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .search-form button:disabled { /* 7.2b: Loading state style */
            background-color: #6c757d;
        }
        .search-form a {
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 5px;
        }

        /* 7.1: Pagination Styles */
        .pagination {
            margin-top: 20px;
        }
        .pagination a, .pagination strong {
            display: inline-block;
            padding: 8px 12px;
            margin-right: 5px;
            border-radius: 5px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #007bff;
            background: white;
        }
        .pagination strong {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination a:hover {
            background-color: #f4f4f4;
        }

        /* 7.2c: Responsive Table Media Query */
        @media (max-width: 768px) {
            table {
                font-size: 12px; /* Smaller font on mobile */
            }
            th, td {
                padding: 8px 10px; /* Tighter padding */
            }
            .search-form input[type="text"] {
                width: 200px;
            }
        }
    </style>
</head>
<body>
    <h1>📚 Student Management System</h1>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="message success">
            <%= request.getParameter("message") %>
        </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
        <div class="message error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <%
        String keyword = request.getParameter("keyword");
        String searchParam = (keyword != null && !keyword.trim().isEmpty()) 
                           ? "&keyword=" + URLEncoder.encode(keyword, "UTF-8") 
                           : "";
    %>
    <div class="search-form">
        <form action="list_students.jsp" method="GET" onsubmit="return submitForm(this)">
            <input type="text" name="keyword" placeholder="Search by name or code..." 
                   value="<%= (keyword != null ? keyword : "") %>">
            <button type="submit">Search</button>
            <a href="list_students.jsp">Clear</a>
        </form>
    </div>
    
    <a href="add_student.jsp" class="btn">➕ Add New Student</a>
    
    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Code</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // --- 7.1: PAGINATION LOGIC ---
    PreparedStatement pstmtCount = null;
    ResultSet rsCount = null;

    int currentPage = 1;
    int recordsPerPage = 10;
    int offset = 0;
    int totalRecords = 0;
    int totalPages = 0;

    try {
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        offset = (currentPage - 1) * recordsPerPage;
    
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(
            "jdbc:sqlserver://localhost:1433;databaseName=student_management;encrypt=true;trustServerCertificate=true",
            "sa",
            "sa"
        );
        
        // --- 7.1: GET TOTAL RECORD COUNT (MUST HAPPEN FIRST) ---
        String sqlCount;
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlCount = "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ?";
            pstmtCount = conn.prepareStatement(sqlCount);
            pstmtCount.setString(1, "%" + keyword + "%");
            pstmtCount.setString(2, "%" + keyword + "%");
        } else {
            sqlCount = "SELECT COUNT(*) FROM students";
            pstmtCount = conn.prepareStatement(sqlCount);
        }
        
        rsCount = pstmtCount.executeQuery();
        if (rsCount.next()) {
            totalRecords = rsCount.getInt(1);
        }
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        // --- END COUNT LOGIC ---


        // --- 7.1: MODIFIED MAIN QUERY WITH PAGINATION (using MSSQL syntax) ---
        String sql;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search query with pagination
            sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? " +
                  "ORDER BY id DESC " +
                  "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setInt(3, offset);
            pstmt.setInt(4, recordsPerPage);
        } else {
            // Normal query with pagination
            sql = "SELECT * FROM students ORDER BY id DESC " +
                  "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, recordsPerPage);
        }
        
        rs = pstmt.executeQuery();
        // --- END OF MODIFIED LOGIC ---
        
        boolean studentsFound = false;
        while (rs.next()) {
            studentsFound = true;
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
%>
                <tr>
                    <td><%= id %></td>
                    <td><%= studentCode %></td>
                    <td><%= fullName %></td>
                    <td><%= email != null ? email : "N/A" %></td>
                    <td><%= major != null ? major : "N/A" %></td>
                    <td><%= createdAt %></td>
                    <td>
                        <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                        <a href="delete_student.jsp?id=<%= id %>" 
                           class="action-link delete-link"
                           onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                    </td>
                </tr>
<%
        }
        
        if (!studentsFound) {
             out.println("<tr><td colspan='7' style='text-align: center; color: #555;'>No students found.</td></tr>");
        }
        
    } catch (Exception e) { // Changed to generic Exception for NumberFormatException
        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            // 7.1: Close the count resources
            if (rsCount != null) rsCount.close();
            if (pstmtCount != null) pstmtCount.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
            </tbody>
        </table>
    </div> <div class="pagination">
        <% if (currentPage > 1) { %>
            <a href="list_students.jsp?page=<%= currentPage - 1 %><%= searchParam %>">Previous</a>
        <% } %>
        
        <% for (int i = 1; i <= totalPages; i++) { %>
            <% if (i == currentPage) { %>
                <strong><%= i %></strong>
            <% } else { %>
                <a href="list_students.jsp?page=<%= i %><%= searchParam %>"><%= i %></a>
            <% } %>
        <% } %>
        
        <% if (currentPage < totalPages) { %>
            <a href="list_students.jsp?page=<%= currentPage + 1 %><%= searchParam %>">Next</a>
        <% } %>
    </div>

    <script>
        // 7.2a: Auto-hide messages
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                // Simple fade out
                msg.style.transition = 'opacity 0.5s';
                msg.style.opacity = '0';
                setTimeout(function() { msg.style.display = 'none'; }, 500);
            });
        }, 3000); // 3 seconds

        // 7.2b: Loading state for form submission
        function submitForm(form) {
            var btn = form.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = 'Processing...';
            return true; // Allows the form to submit
        }
    </script>
</body>
</html>