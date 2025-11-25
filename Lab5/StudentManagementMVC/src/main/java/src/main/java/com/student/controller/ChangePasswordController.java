package src.main.java.com.student.controller;

// Don't forget this import
import src.main.java.com.student.dao.UserDAO;
import src.main.java.com.student.model.User;
import org.mindrot.jbcrypt.BCrypt; // Add this import for hashing

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simple forward to the form
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get current user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login"); // Redirect if not logged in
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        
        // 2. Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 3. Validation
        if (currentPassword == null || newPassword == null || confirmPassword == null || 
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) { // Simple length validation
            request.setAttribute("error", "New password must be at least 6 characters long.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // 4. Validate current password (against the hash stored in the database)
        // Since the current user object only has the password hash, we use BCrypt.checkpw
        if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
            request.setAttribute("error", "Invalid current password.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // 5. Hash new password
        String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // 6. Update in database
        if (userDAO.updatePassword(currentUser.getId(), newHashedPassword)) {
            
            // 7. Update the password hash in the session object to reflect the change
            currentUser.setPassword(newHashedPassword);
            session.setAttribute("user", currentUser); 
            
            // 8. Show success message and redirect
            request.setAttribute("message", "Password successfully changed!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            
        } else {
            // Database failure
            request.setAttribute("error", "Failed to update password due to a database error.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        }
    }
}