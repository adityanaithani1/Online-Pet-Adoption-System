package com.petadopt.model;

import java.sql.Timestamp;

public class AdoptionRequest {
    private int requestId;
    private int petId;
    private int adopterId;
    private String status; // pending, approved, rejected
    private Timestamp createdAt;

    public AdoptionRequest() {}

    public AdoptionRequest(int requestId, int petId, int adopterId, String status) {
        this.requestId = requestId;
        this.petId = petId;
        this.adopterId = adopterId;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getPetId() {
        return petId;
    }

    public void setPetId(int petId) {
        this.petId = petId;
    }

    public int getAdopterId() {
        return adopterId;
    }

    public void setAdopterId(int adopterId) {
        this.adopterId = adopterId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
