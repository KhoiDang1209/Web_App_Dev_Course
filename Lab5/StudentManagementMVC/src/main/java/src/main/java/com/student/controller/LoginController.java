package src.main.java.com.student.controller;

import src.main.java.com.student.dao.UserDAO;
import src.main.java.com.student.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie; // NEW IMPORT
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    
    private UserDAO userDAO;
    
    // Define constants for the "Remember Me" cookie
    private static final String REMEMBER_ME_COOKIE = "remember_user";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 30; // 30 days
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    /**
     * Display login page (and optionally handle auto-login via cookie in a production environment)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // If already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        String rememberedUsername = getRememberMeUsername(request);
        
        if (rememberedUsername != null) {
            // 3. Cookie found, try to fetch and authenticate the user by username
            User user = userDAO.getUserByUsername(rememberedUsername);
            
            if (user != null && user.isActive()) {
                // 4. Auto-login successful: Create new session
                session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());
                session.setAttribute("fullName", user.getFullName());
                session.setMaxInactiveInterval(30 * 60);
                
                // 5. Redirect to dashboard
                response.sendRedirect("dashboard");
                return;
            } else {
                // 6. User not found or inactive: Delete the stale cookie
                clearRememberMeCookie(request, response);
            }
        }
        // Show login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    private String getRememberMeUsername(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
    
    /**
     * Helper method to clear the "Remember Me" cookie.
     */
    private void clearRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
    }
    /**
     * Process login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");
        
        // Validate input (Existing Code)
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user (Existing Code)
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            // Authentication successful
            
            // Invalidate old session (prevent session fixation) - Existing Code
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            
            // Create new session - Existing Code
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60);
            
            // --- START: Implement Remember Me (Cookie Logic) ---
            if ("on".equals(rememberMe)) {
                // Set a persistent cookie with the username
                Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, username);
                cookie.setMaxAge(COOKIE_MAX_AGE); // 30 days
                cookie.setPath(request.getContextPath()); // Cookie visible across the entire application
                cookie.setHttpOnly(true); // Recommended security practice
                response.addCookie(cookie);
            } else {
                // If "Remember Me" was unchecked, delete any existing cookie
                Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
                cookie.setMaxAge(0);
                cookie.setPath(request.getContextPath());
                response.addCookie(cookie);
            }
            // --- END: Implement Remember Me (Cookie Logic) ---
            
            // Redirect based on role (Existing Code)
            if (user.isAdmin()) {
                response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("student?action=list");
            }
            
        } else {
            // Authentication failed (Existing Code)
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}