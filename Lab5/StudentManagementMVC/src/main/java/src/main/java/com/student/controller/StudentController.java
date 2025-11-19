package src.main.java.com.student.controller;

import src.main.java.com.student.dao.StudentDAO;
import src.main.java.com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search": 
                searchStudents(request, response);
                break;
            // NEW CASES: Route sorting and filtering to the main list method
            case "sort":
            case "filter":
            case "list":
            default:
                listStudents(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }
    
    // List all students
    // Unified method for Listing, Sorting, and Filtering
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get Parameters from URL or Form
        String major = request.getParameter("major");
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        
        // 2. Set Defaults if parameters are missing
        // If major is empty string (from "All Majors" option), treat as null
        if (major != null && major.trim().isEmpty()) {
            major = null;
        }
        
        // Default sort: ID descending (newest first)
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "id";
        }
        
        if (order == null || order.trim().isEmpty()) {
            order = "desc"; // Default to newest first
        }
        
        // 3. Call the Unified DAO Method (Created in 7.1)
        List<Student> students = studentDAO.getStudentsFiltered(major, sortBy, order);
        
        // 4. Set Attributes (CRITICAL for "Sticky" UI)
        request.setAttribute("students", students);
        
        // Send these back so the View knows what is currently selected
        request.setAttribute("selectedMajor", major); // Keeps dropdown selected
        request.setAttribute("sortBy", sortBy);       // Shows arrow on correct column
        request.setAttribute("order", order);         // Knows which way to flip next
        
        // 5. Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        
        request.setAttribute("student", existingStudent);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student newStudent = new Student(studentCode, fullName, email, major);
        
        // CALL VALIDATION HERE
        if (validateStudent(newStudent, request)) {
            // Validation passed -> Save to DB
            if (studentDAO.addStudent(newStudent)) {
                response.sendRedirect("student?action=list&message=Student added successfully");
            } else {
                response.sendRedirect("student?action=list&error=Database error: Failed to add student");
            }
        } else {
            // Validation failed -> Go back to form with errors and input data
            request.setAttribute("student", newStudent); // Keep what they typed
            RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
        
        // CALL VALIDATION HERE
        if (validateStudent(student, request)) {
            if (studentDAO.updateStudent(student)) {
                response.sendRedirect("student?action=list&message=Student updated successfully");
            } else {
                response.sendRedirect("student?action=list&error=Failed to update student");
            }
        } else {
            // Validation failed -> Go back to form
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("student-form.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }
    // Search students
    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get keyword parameter from the form
        String keyword = request.getParameter("keyword");
        
        List<Student> students;
        
        // 2. Decide which DAO method to call
        // If keyword is null or empty, just show all students
        if (keyword != null && !keyword.trim().isEmpty()) {
            students = studentDAO.searchStudents(keyword);
        } else {
            students = studentDAO.getAllStudents();
        }
        
        // 3. Set request attributes
        // We send the list of students found
        request.setAttribute("students", students);
        
        // We ALSO send the keyword back so we can keep it in the search box (sticky form)
        request.setAttribute("keyword", keyword);
        
        // 4. Forward to view
        RequestDispatcher dispatcher = request.getRequestDispatcher("student-list.jsp");
        dispatcher.forward(request, response);
    }
    // Validation Method
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        // 1. Validate Student Code
        String code = student.getStudentCode();
        String codePattern = "[A-Z]{2}[0-9]{3,}"; // e.g., SV001, IT123
        
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else if (!code.matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 uppercase letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }

        // 2. Validate Full Name
        String name = student.getFullName();
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else if (name.trim().length() < 2) {
            request.setAttribute("errorName", "Name must be at least 2 characters");
            isValid = false;
        }

        // 3. Validate Email (Optional but must be valid format if provided)
        String email = student.getEmail();
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        
        if (email != null && !email.trim().isEmpty()) {
            if (!email.matches(emailPattern)) {
                request.setAttribute("errorEmail", "Invalid email format");
                isValid = false;
            }
        }

        // 4. Validate Major
        String major = student.getMajor();
        if (major == null || major.trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }

        return isValid;
    }
}
