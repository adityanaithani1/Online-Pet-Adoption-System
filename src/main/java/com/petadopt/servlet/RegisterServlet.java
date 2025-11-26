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
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        // Check if email exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole(role);

        // Register user
        boolean userCreated = userDAO.register(user);

        if (userCreated) {
            // If shelter, create shelter entry
            if ("shelter".equals(role)) {
                String shelterName = request.getParameter("shelterName");
                String shelterAddress = request.getParameter("shelterAddress");

                Shelter shelter = new Shelter();
                shelter.setName(shelterName);
                shelter.setAddress(shelterAddress);
                shelter.setContact(phone);
                shelter.setUserId(user.getUserId());

                shelterDAO.addShelter(shelter);
            }

            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
