package com.petadopt.servlet;

import com.petadopt.dao.UserDAO;
import com.petadopt.dao.ShelterDAO;
import com.petadopt.model.User;
import com.petadopt.model.Shelter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Login Servlet
 * Demonstrates: Servlet basics, Request/Response handling, Session management
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private ShelterDAO shelterDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        shelterDAO = new ShelterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Validate login
        User user = userDAO.login(email, password, role);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getName());

            // If shelter user, store shelter info
            if ("shelter".equals(user.getRole())) {
                Shelter shelter = shelterDAO.getShelterByUserId(user.getUserId());
                if (shelter != null) {
                    session.setAttribute("shelterId", shelter.getShelterId());
                    session.setAttribute("shelterName", shelter.getName());
                }
            }

            // Redirect based on role
            // Redirect based on role
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
                    break;
                case "shelter":
                    response.sendRedirect(request.getContextPath() + "/shelter-dashboard.jsp");
                    break;
                case "adopter":
                    response.sendRedirect(request.getContextPath() + "/adopter-dashboard.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
            }

        } else {
            // Login failed
            request.setAttribute("error", "Invalid credentials or role mismatch!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
