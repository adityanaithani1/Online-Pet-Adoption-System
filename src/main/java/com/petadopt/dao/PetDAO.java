package com.petadopt.dao;

import com.petadopt.model.Pet;
import com.petadopt.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Pet Data Access Object
 * Demonstrates: JDBC CRUD Operations, Filtering, Collections
 */
public class PetDAO {

    /**
     * Add new pet
     * @param pet Pet object
     * @return true if successful
     */
    public boolean addPet(Pet pet) {
        String query = "INSERT INTO pets (name, type, breed, age, gender, description, " +
                      "health_status, vaccination_status, status, shelter_id) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, pet.getName());
            stmt.setString(2, pet.getType());
            stmt.setString(3, pet.getBreed());
            stmt.setDouble(4, pet.getAge());
            stmt.setString(5, pet.getGender());
            stmt.setString(6, pet.getDescription());
            stmt.setString(7, pet.getHealthStatus());
            stmt.setString(8, pet.getVaccinationStatus());
            stmt.setString(9, pet.getStatus());
            stmt.setInt(10, pet.getShelterId());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        pet.setPetId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error adding pet: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get all pets
     * @return List of all pets
     */
    public List<Pet> getAllPets() {
        List<Pet> pets = new ArrayList<>();
        String query = "SELECT * FROM pets ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                pets.add(extractPetFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching pets: " + e.getMessage());
            e.printStackTrace();
        }

        return pets;
    }

    /**
     * Get pet by ID
     * @param petId Pet ID
     * @return Pet object
     */
    public Pet getPetById(int petId) {
        String query = "SELECT * FROM pets WHERE pet_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, petId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractPetFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching pet: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get pets by shelter ID
     * @param shelterId Shelter ID
     * @return List of pets in that shelter
     */
    public List<Pet> getPetsByShelterId(int shelterId) {
        List<Pet> pets = new ArrayList<>();
        String query = "SELECT * FROM pets WHERE shelter_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, shelterId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    pets.add(extractPetFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching shelter pets: " + e.getMessage());
            e.printStackTrace();
        }

        return pets;
    }

    /**
     * Filter pets by criteria
     * @param type Pet type (null for all)
     * @param gender Gender (null for all)
     * @param status Status (null for all)
     * @return Filtered list of pets
     */
    public List<Pet> filterPets(String type, String gender, String status) {
        List<Pet> pets = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM pets WHERE 1=1");

        if (type != null && !type.isEmpty()) {
            query.append(" AND type = ?");
        }
        if (gender != null && !gender.isEmpty()) {
            query.append(" AND gender = ?");
        }
        if (status != null && !status.isEmpty()) {
            query.append(" AND status = ?");
        }

        query.append(" ORDER BY created_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            int paramIndex = 1;
            if (type != null && !type.isEmpty()) {
                stmt.setString(paramIndex++, type);
            }
            if (gender != null && !gender.isEmpty()) {
                stmt.setString(paramIndex++, gender);
            }
            if (status != null && !status.isEmpty()) {
                stmt.setString(paramIndex++, status);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    pets.add(extractPetFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error filtering pets: " + e.getMessage());
            e.printStackTrace();
        }

        return pets;
    }

    /**
     * Update pet details
     * @param pet Pet object with updated details
     * @return true if successful
     */
    public boolean updatePet(Pet pet) {
        String query = "UPDATE pets SET name = ?, type = ?, breed = ?, age = ?, gender = ?, " +
                      "description = ?, health_status = ?, vaccination_status = ?, status = ? " +
                      "WHERE pet_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, pet.getName());
            stmt.setString(2, pet.getType());
            stmt.setString(3, pet.getBreed());
            stmt.setDouble(4, pet.getAge());
            stmt.setString(5, pet.getGender());
            stmt.setString(6, pet.getDescription());
            stmt.setString(7, pet.getHealthStatus());
            stmt.setString(8, pet.getVaccinationStatus());
            stmt.setString(9, pet.getStatus());
            stmt.setInt(10, pet.getPetId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating pet: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update only pet status
     * @param petId Pet ID
     * @param status New status
     * @return true if successful
     */
    public boolean updatePetStatus(int petId, String status) {
        String query = "UPDATE pets SET status = ? WHERE pet_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);
            stmt.setInt(2, petId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating pet status: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete pet
     * @param petId Pet ID
     * @return true if successful
     */
    public boolean deletePet(int petId) {
        String query = "DELETE FROM pets WHERE pet_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, petId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting pet: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Helper method to extract Pet from ResultSet
     */
    private Pet extractPetFromResultSet(ResultSet rs) throws SQLException {
        Pet pet = new Pet();
        pet.setPetId(rs.getInt("pet_id"));
        pet.setName(rs.getString("name"));
        pet.setType(rs.getString("type"));
        pet.setBreed(rs.getString("breed"));
        pet.setAge(rs.getDouble("age"));
        pet.setGender(rs.getString("gender"));
        pet.setDescription(rs.getString("description"));
        pet.setHealthStatus(rs.getString("health_status"));
        pet.setVaccinationStatus(rs.getString("vaccination_status"));
        pet.setStatus(rs.getString("status"));
        pet.setShelterId(rs.getInt("shelter_id"));
        pet.setCreatedAt(rs.getTimestamp("created_at"));
        return pet;
    }
}
