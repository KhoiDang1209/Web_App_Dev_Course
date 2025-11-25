package src.main.java.com.student.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    // Must match the constant used in LoginController
    private static final String REMEMBER_ME_COOKIE = "remember_user";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        // 1. Invalidate the current session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // 2. Clear the persistent "Remember Me" cookie
        clearRememberMeCookie(request, response);

        // 3. Redirect to the login page
        response.sendRedirect(request.getContextPath() + "/login?message=You have been successfully logged out.");
    }
    
    /**
     * Helper method to clear the "Remember Me" cookie.
     */
    private void clearRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
        cookie.setMaxAge(0); // MaxAge 0 tells the browser to delete the cookie immediately
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
    }
}