package com.petadopt.dao;

import com.petadopt.model.Shelter;
import com.petadopt.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShelterDAO {

    public boolean addShelter(Shelter shelter) {
        String query = "INSERT INTO shelters (name, address, contact, user_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, shelter.getName());
            stmt.setString(2, shelter.getAddress());
            stmt.setString(3, shelter.getContact());
            stmt.setInt(4, shelter.getUserId());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        shelter.setShelterId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error adding shelter: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public List<Shelter> getAllShelters() {
        List<Shelter> shelters = new ArrayList<>();
        String query = "SELECT * FROM shelters ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                shelters.add(extractShelterFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching shelters: " + e.getMessage());
            e.printStackTrace();
        }

        return shelters;
    }

    public Shelter getShelterById(int shelterId) {
        String query = "SELECT * FROM shelters WHERE shelter_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, shelterId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractShelterFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching shelter: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public Shelter getShelterByUserId(int userId) {
        String query = "SELECT * FROM shelters WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractShelterFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching shelter by user: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean deleteShelter(int shelterId) {
        String query = "DELETE FROM shelters WHERE shelter_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, shelterId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting shelter: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private Shelter extractShelterFromResultSet(ResultSet rs) throws SQLException {
        Shelter shelter = new Shelter();
        shelter.setShelterId(rs.getInt("shelter_id"));
        shelter.setName(rs.getString("name"));
        shelter.setAddress(rs.getString("address"));
        shelter.setContact(rs.getString("contact"));
        shelter.setUserId(rs.getInt("user_id"));
        shelter.setCreatedAt(rs.getTimestamp("created_at"));
        return shelter;
    }
}
