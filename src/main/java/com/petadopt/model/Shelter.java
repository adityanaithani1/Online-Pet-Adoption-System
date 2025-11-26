package com.petadopt.model;

import java.sql.Timestamp;

public class Shelter {
    private int shelterId;
    private String name;
    private String address;
    private String contact;
    private int userId;
    private Timestamp createdAt;

    public Shelter() {}

    public Shelter(int shelterId, String name, String address, String contact, int userId) {
        this.shelterId = shelterId;
        this.name = name;
        this.address = address;
        this.contact = contact;
        this.userId = userId;
    }

    public int getShelterId() {
        return shelterId;
    }

    public void setShelterId(int shelterId) {
        this.shelterId = shelterId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
