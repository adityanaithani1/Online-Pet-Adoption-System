package com.petadopt.servlet;

import com.petadopt.dao.AdoptionRequestDAO;
import com.petadopt.dao.PetDAO;
import com.petadopt.dao.UserDAO;
import com.petadopt.model.AdoptionRequest;
import com.petadopt.model.Pet;
import com.petadopt.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Adoption Request Management Servlet
 * Demonstrates: Transaction handling, Role-based operations
 */
@WebServlet("/adoption")
public class AdoptionServlet extends HttpServlet {

    private AdoptionRequestDAO requestDAO;
    private PetDAO petDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        requestDAO = new AdoptionRequestDAO();
        petDAO = new PetDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            listRequests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("apply".equals(action)) {
            applyForAdoption(request, response);
        } else if ("updateStatus".equals(action)) {
            updateRequestStatus(request, response);
        }
    }

    private void applyForAdoption(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        if (userId == null || !"adopter".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int petId = Integer.parseInt(request.getParameter("petId"));

        // Check if already applied
        if (requestDAO.hasPendingRequest(petId, userId)) {
            request.setAttribute("error", "You have already applied for this pet!");
            response.sendRedirect("pets?action=view&id=" + petId);
            return;
        }

        AdoptionRequest adoptionRequest = new AdoptionRequest();
        adoptionRequest.setPetId(petId);
        adoptionRequest.setAdopterId(userId);
        adoptionRequest.setStatus("pending");

        boolean created = requestDAO.createRequest(adoptionRequest);

        if (created) {
            // Update pet status to pending
            petDAO.updatePetStatus(petId, "pending");
            request.setAttribute("success", "Application submitted successfully!");
        } else {
            request.setAttribute("error", "Failed to submit application!");
        }

        response.sendRedirect("adopter-dashboard.jsp");
    }

    private void updateRequestStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (!"shelter".equals(role) && !"admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        int petId = Integer.parseInt(request.getParameter("petId"));
        String status = request.getParameter("status");

        // Use transaction to update both request and pet status
        boolean updated = requestDAO.updateRequestStatus(requestId, status, petId);

        if (updated) {
            request.setAttribute("success", "Request " + status + " successfully!");
        } else {
            request.setAttribute("error", "Failed to update request!");
        }

        if ("shelter".equals(role)) {
            response.sendRedirect("shelter-dashboard.jsp");
        } else {
            response.sendRedirect("admin-dashboard.jsp");
        }
    }

    private void listRequests(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<AdoptionRequest> requests = null;

        if ("adopter".equals(role)) {
            requests = requestDAO.getRequestsByAdopter(userId);
        } else if ("shelter".equals(role)) {
            Integer shelterId = (Integer) session.getAttribute("shelterId");
            requests = requestDAO.getRequestsByShelter(shelterId);
        } else if ("admin".equals(role)) {
            requests = requestDAO.getAllRequests();
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("adoption-requests.jsp").forward(request, response);
    }
}
