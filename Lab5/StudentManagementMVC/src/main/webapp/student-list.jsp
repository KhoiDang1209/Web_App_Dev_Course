<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        /* --- EXISTING STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        h1 { color: #333; margin-bottom: 10px; font-size: 32px; }
        .subtitle { color: #666; margin-bottom: 30px; font-style: italic; }
        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: 500; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { display: inline-block; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: 500; transition: all 0.3s; border: none; cursor: pointer; font-size: 14px; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-danger { background-color: #dc3545; color: white; padding: 8px 16px; font-size: 13px; }
        .btn-danger:hover { background-color: #c82333; }
        
        /* --- TOOLBAR & FILTER STYLES --- */
        .toolbar {
            display: flex;
            flex-wrap: wrap; /* Allows wrapping on small screens */
            gap: 15px;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .form-control {
            padding: 10px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 14px;
        }
        
        select.form-control {
            cursor: pointer;
            min-width: 180px;
        }

        /* --- SORTABLE HEADER STYLES --- */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        thead { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        
        th a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        th a:hover { text-decoration: underline; }
        
        .sort-icon { font-size: 12px; opacity: 0.8; }
        
        .actions { display: flex; gap: 10px; }
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state-icon { font-size: 64px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
        <c:if test="${not empty param.message}"><div class="message success">✅ ${param.message}</div></c:if>
        <c:if test="${not empty param.error}"><div class="message error">❌ ${param.error}</div></c:if>
        
        <div class="toolbar">
            <form action="student" method="get" class="filter-group">
                <input type="hidden" name="action" value="list">
                
                <select name="major" class="form-control">
                    <option value="">-- All Majors --</option>
                    <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                    <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                    <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                </select>
                
                <input type="text" name="keyword" class="form-control" 
                       placeholder="Search..." value="${keyword}">
                
                <button type="submit" class="btn btn-primary">Apply Filter</button>
                
                <c:if test="${not empty selectedMajor or not empty keyword}">
                    <a href="student?action=list" class="btn btn-secondary">Clear</a>
                </c:if>
            </form>

            <a href="student?action=new" class="btn btn-primary">➕ Add New</a>
        </div>

        <c:if test="${not empty selectedMajor or not empty keyword}">
            <p style="margin-bottom: 15px; color: #666;">
                <c:if test="${not empty selectedMajor}">Filter: <strong>${selectedMajor}</strong></c:if>
                <c:if test="${not empty selectedMajor and not empty keyword}"> | </c:if>
                <c:if test="${not empty keyword}">Search: <strong>"${keyword}"</strong></c:if>
            </p>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <a href="student?action=list&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}&major=${selectedMajor}&keyword=${keyword}">
                                    ID
                                    <c:if test="${sortBy == 'id'}"><span class="sort-icon">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                                </a>
                            </th>
                            
                            <th>
                                <a href="student?action=list&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}&major=${selectedMajor}&keyword=${keyword}">
                                    Student Code
                                    <c:if test="${sortBy == 'student_code'}"><span class="sort-icon">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                                </a>
                            </th>
                            
                            <th>
                                <a href="student?action=list&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}&major=${selectedMajor}&keyword=${keyword}">
                                    Full Name
                                    <c:if test="${sortBy == 'full_name'}"><span class="sort-icon">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                                </a>
                            </th>
                            
                            <th>
                                <a href="student?action=list&sortBy=email&order=${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}&major=${selectedMajor}&keyword=${keyword}">
                                    Email
                                    <c:if test="${sortBy == 'email'}"><span class="sort-icon">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                                </a>
                            </th>
                            
                            <th>
                                <a href="student?action=list&sortBy=major&order=${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}&major=${selectedMajor}&keyword=${keyword}">
                                    Major
                                    <c:if test="${sortBy == 'major'}"><span class="sort-icon">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                                </a>
                            </th>
                            
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <td>
                                    <div class="actions">
                                        <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">✏️ Edit</a>
                                        <a href="student?action=delete&id=${student.id}" class="btn btn-danger" onclick="return confirm('Delete this student?')">🗑️ Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Try adjusting your filters or add a new student.</p>
                    <br>
                    <a href="student?action=list" class="btn btn-secondary">Clear All Filters</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>