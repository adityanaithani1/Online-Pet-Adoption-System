-- Pet Adoption System Database Schema

-- Drop existing tables if they exist
DROP TABLE IF EXISTS adoption_requests;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS shelters;
DROP TABLE IF EXISTS users;

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('adopter', 'shelter', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shelters Table
CREATE TABLE shelters (
    shelter_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact VARCHAR(20),
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Pets Table
CREATE TABLE pets (
    pet_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL,
    breed VARCHAR(50),
    age DECIMAL(3,1),
    gender VARCHAR(10),
    description TEXT,
    health_status VARCHAR(50),
    vaccination_status VARCHAR(50),
    status ENUM('available', 'pending', 'adopted') DEFAULT 'available',
    shelter_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shelter_id) REFERENCES shelters(shelter_id) ON DELETE CASCADE
);

-- Adoption Requests Table
CREATE TABLE adoption_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    pet_id INT NOT NULL,
    adopter_id INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (adopter_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert sample data
-- Admin user
INSERT INTO users (name, email, password, phone, role) 
VALUES ('Admin User', 'admin@petadopt.com', 'admin123', '+1234567890', 'admin');

-- Shelter and shelter user
INSERT INTO users (name, email, password, phone, role) 
VALUES ('Shelter Manager', 'shelter@petadopt.com', 'shelter123', '+1234567891', 'shelter');

INSERT INTO shelters (name, address, contact, user_id) 
VALUES ('Happy Paws Shelter', '123 Main Street, Cityville', '+1234567891', 2);

-- Adopter user
INSERT INTO users (name, email, password, phone, role) 
VALUES ('John Adopter', 'adopter@petadopt.com', 'adopter123', '+1234567892', 'adopter');

-- Sample pets
INSERT INTO pets (name, type, breed, age, gender, description, health_status, vaccination_status, shelter_id) VALUES
('Max', 'Dog', 'Golden Retriever', 2.0, 'Male', 'Friendly and energetic golden retriever. Loves to play fetch!', 'Excellent', 'Up to Date', 1),
('Luna', 'Cat', 'Siamese', 1.0, 'Female', 'Calm and affectionate cat. Great with kids.', 'Good', 'Up to Date', 1),
('Charlie', 'Dog', 'Beagle', 3.0, 'Male', 'Playful and loyal companion.', 'Excellent', 'Up to Date', 1),
('Bella', 'Cat', 'Persian', 2.0, 'Female', 'Beautiful fluffy cat with gentle nature.', 'Good', 'Partial', 1),
('Rocky', 'Dog', 'German Shepherd', 4.0, 'Male', 'Protective and intelligent. Needs experienced owner.', 'Excellent', 'Up to Date', 1),
('Whiskers', 'Cat', 'Tabby', 1.5, 'Male', 'Curious and playful kitten.', 'Excellent', 'Up to Date', 1);
