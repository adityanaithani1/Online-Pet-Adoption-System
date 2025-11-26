package com.petadopt.dao;

import com.petadopt.model.AdoptionRequest;
import com.petadopt.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Adoption Request Data Access Object
 * Demonstrates: Transaction Management, JDBC Operations
 */
public class AdoptionRequestDAO {

    /**
     * Create new adoption request
     * @param request AdoptionRequest object
     * @return true if successful
     */
    public boolean createRequest(AdoptionRequest request) {
        String query = "INSERT INTO adoption_requests (pet_id, adopter_id, status) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, request.getPetId());
            stmt.setInt(2, request.getAdopterId());
            stmt.setString(3, request.getStatus());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        request.setRequestId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error creating request: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get requests by adopter ID
     * @param adopterId Adopter's user ID
     * @return List of adoption requests
     */
    public List<AdoptionRequest> getRequestsByAdopter(int adopterId) {
        List<AdoptionRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM adoption_requests WHERE adopter_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, adopterId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(extractRequestFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching adopter requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    /**
     * Get requests for pets in a specific shelter
     * @param shelterId Shelter ID
     * @return List of adoption requests
     */
    public List<AdoptionRequest> getRequestsByShelter(int shelterId) {
        List<AdoptionRequest> requests = new ArrayList<>();
        String query = "SELECT ar.* FROM adoption_requests ar " +
                      "JOIN pets p ON ar.pet_id = p.pet_id " +
                      "WHERE p.shelter_id = ? ORDER BY ar.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, shelterId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    requests.add(extractRequestFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching shelter requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    /**
     * Get all adoption requests (Admin)
     * @return List of all requests
     */
    public List<AdoptionRequest> getAllRequests() {
        List<AdoptionRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM adoption_requests ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                requests.add(extractRequestFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching all requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    /**
     * Update request status with transaction
     * Demonstrates: Transaction Management (commit/rollback)
     * @param requestId Request ID
     * @param status New status
     * @param petId Pet ID
     * @return true if successful
     */
    public boolean updateRequestStatus(int requestId, String status, int petId) {
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Update adoption request status
            String updateRequestQuery = "UPDATE adoption_requests SET status = ? WHERE request_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateRequestQuery)) {
                stmt.setString(1, status);
                stmt.setInt(2, requestId);
                stmt.executeUpdate();
            }

            // If approved, update pet status to adopted
            if ("approved".equals(status)) {
                String updatePetQuery = "UPDATE pets SET status = 'adopted' WHERE pet_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updatePetQuery)) {
                    stmt.setInt(1, petId);
                    stmt.executeUpdate();
                }

                // Reject all other pending requests for this pet
                String rejectOthersQuery = "UPDATE adoption_requests SET status = 'rejected' " +
                                          "WHERE pet_id = ? AND request_id != ? AND status = 'pending'";
                try (PreparedStatement stmt = conn.prepareStatement(rejectOthersQuery)) {
                    stmt.setInt(1, petId);
                    stmt.setInt(2, requestId);
                    stmt.executeUpdate();
                }
            }

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            System.err.println("Error updating request status: " + e.getMessage());
            e.printStackTrace();

            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back: " + ex.getMessage());
                }
            }

        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }

        return false;
    }

    /**
     * Check if user already has pending request for pet
     * @param petId Pet ID
     * @param adopterId Adopter ID
     * @return true if pending request exists
     */
    public boolean hasPendingRequest(int petId, int adopterId) {
        String query = "SELECT COUNT(*) FROM adoption_requests " +
                      "WHERE pet_id = ? AND adopter_id = ? AND status = 'pending'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, petId);
            stmt.setInt(2, adopterId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error checking pending request: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Helper method to extract AdoptionRequest from ResultSet
     */
    private AdoptionRequest extractRequestFromResultSet(ResultSet rs) throws SQLException {
        AdoptionRequest request = new AdoptionRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setPetId(rs.getInt("pet_id"));
        request.setAdopterId(rs.getInt("adopter_id"));
        request.setStatus(rs.getString("status"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        return request;
    }
}
