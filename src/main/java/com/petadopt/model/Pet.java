package com.petadopt.model;

import java.sql.Timestamp;

public class Pet {
    private int petId;
    private String name;
    private String type;
    private String breed;
    private double age;
    private String gender;
    private String description;
    private String healthStatus;
    private String vaccinationStatus;
    private String status; // available, pending, adopted
    private int shelterId;
    private Timestamp createdAt;

    public Pet() {}

    public Pet(int petId, String name, String type, String breed, double age, 
               String gender, String description, String healthStatus, 
               String vaccinationStatus, String status, int shelterId) {
        this.petId = petId;
        this.name = name;
        this.type = type;
        this.breed = breed;
        this.age = age;
        this.gender = gender;
        this.description = description;
        this.healthStatus = healthStatus;
        this.vaccinationStatus = vaccinationStatus;
        this.status = status;
        this.shelterId = shelterId;
    }

    // Getters and Setters
    public int getPetId() {
        return petId;
    }

    public void setPetId(int petId) {
        this.petId = petId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getBreed() {
        return breed;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public double getAge() {
        return age;
    }

    public void setAge(double age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
    }

    public String getVaccinationStatus() {
        return vaccinationStatus;
    }

    public void setVaccinationStatus(String vaccinationStatus) {
        this.vaccinationStatus = vaccinationStatus;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getShelterId() {
        return shelterId;
    }

    public void setShelterId(int shelterId) {
        this.shelterId = shelterId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
