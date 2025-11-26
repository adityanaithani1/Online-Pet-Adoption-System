package com.petadopt.servlet;

import com.petadopt.dao.PetDAO;
import com.petadopt.dao.ShelterDAO;
import com.petadopt.model.Pet;
import com.petadopt.model.Shelter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Pet Management Servlet
 * Handles: List, Add, Edit, Delete, Filter pets
 */
@WebServlet("/pets")
public class PetServlet extends HttpServlet {

    private PetDAO petDAO;
    private ShelterDAO shelterDAO;

    @Override
    public void init() throws ServletException {
        petDAO = new PetDAO();
        shelterDAO = new ShelterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listPets(request, response);
                break;
            case "filter":
                filterPets(request, response);
                break;
            case "view":
                viewPet(request, response);
                break;
            case "delete":
                deletePet(request, response);
                break;
            default:
                listPets(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addPet(request, response);
        } else if ("update".equals(action)) {
            updatePet(request, response);
        }
    }

    private void listPets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        List<Pet> pets = petDAO.getAllPets();
        List<Shelter> shelters = shelterDAO.getAllShelters();

        request.setAttribute("pets", pets);
        request.setAttribute("shelters", shelters);
        request.getRequestDispatcher("pets.jsp").forward(request, response);
    }

    private void filterPets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");

        List<Pet> pets = petDAO.filterPets(type, gender, status);
        List<Shelter> shelters = shelterDAO.getAllShelters();

        request.setAttribute("pets", pets);
        request.setAttribute("shelters", shelters);
        request.getRequestDispatcher("pets.jsp").forward(request, response);
    }

    private void viewPet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int petId = Integer.parseInt(request.getParameter("id"));
        Pet pet = petDAO.getPetById(petId);
        Shelter shelter = shelterDAO.getShelterById(pet.getShelterId());

        request.setAttribute("pet", pet);
        request.setAttribute("shelter", shelter);
        request.getRequestDispatcher("pet-details.jsp").forward(request, response);
    }

    private void addPet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer shelterId = (Integer) session.getAttribute("shelterId");

        if (shelterId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Pet pet = new Pet();
        pet.setName(request.getParameter("name"));
        pet.setType(request.getParameter("type"));
        pet.setBreed(request.getParameter("breed"));
        pet.setAge(Double.parseDouble(request.getParameter("age")));
        pet.setGender(request.getParameter("gender"));
        pet.setDescription(request.getParameter("description"));
        pet.setHealthStatus(request.getParameter("healthStatus"));
        pet.setVaccinationStatus(request.getParameter("vaccinationStatus"));
        pet.setStatus("available");
        pet.setShelterId(shelterId);

        boolean added = petDAO.addPet(pet);

        if (added) {
            request.setAttribute("success", "Pet added successfully!");
        } else {
            request.setAttribute("error", "Failed to add pet!");
        }

        response.sendRedirect("shelter-dashboard.jsp");
    }

    private void updatePet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int petId = Integer.parseInt(request.getParameter("petId"));

        Pet pet = new Pet();
        pet.setPetId(petId);
        pet.setName(request.getParameter("name"));
        pet.setType(request.getParameter("type"));
        pet.setBreed(request.getParameter("breed"));
        pet.setAge(Double.parseDouble(request.getParameter("age")));
        pet.setGender(request.getParameter("gender"));
        pet.setDescription(request.getParameter("description"));
        pet.setHealthStatus(request.getParameter("healthStatus"));
        pet.setVaccinationStatus(request.getParameter("vaccinationStatus"));
        pet.setStatus(request.getParameter("status"));

        boolean updated = petDAO.updatePet(pet);

        if (updated) {
            request.setAttribute("success", "Pet updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update pet!");
        }

        response.sendRedirect("shelter-dashboard.jsp");
    }

    private void deletePet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int petId = Integer.parseInt(request.getParameter("id"));
        boolean deleted = petDAO.deletePet(petId);

        if (deleted) {
            request.setAttribute("success", "Pet deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete pet!");
        }

        response.sendRedirect("shelter-dashboard.jsp");
    }
}
