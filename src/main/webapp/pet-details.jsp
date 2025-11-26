<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.*, com.petadopt.model.*" %>
<%
    int petId = Integer.parseInt(request.getParameter("id"));
    PetDAO petDAO = new PetDAO();
    ShelterDAO shelterDAO = new ShelterDAO();

    Pet pet = petDAO.getPetById(petId);
    Shelter shelter = shelterDAO.getShelterById(pet.getShelterId());

    Integer userId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole");

    // Check if user already applied
    boolean alreadyApplied = false;
    if (userId != null && "adopter".equals(userRole)) {
        AdoptionRequestDAO requestDAO = new AdoptionRequestDAO();
        alreadyApplied = requestDAO.hasPendingRequest(petId, userId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pet.getName() %> - Pet Details</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }

        .navbar {
            background: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }

        .nav-links a {
            margin-left: 30px;
            text-decoration: none;
            color: #333;
            font-weight: 500;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .pet-detail-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .pet-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 40px;
            text-align: center;
        }

        .pet-icon {
            font-size: 100px;
            margin-bottom: 20px;
        }

        .pet-header h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .pet-header p {
            font-size: 18px;
            opacity: 0.9;
        }

        .pet-body {
            padding: 40px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }

        .info-label {
            font-size: 13px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .info-value {
            font-size: 18px;
            color: #333;
            font-weight: 600;
        }

        .section {
            margin-bottom: 30px;
        }

        .section h2 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #333;
        }

        .section p {
            color: #666;
            line-height: 1.6;
            font-size: 16px;
        }

        .badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .badge-available {
            background: #d4edda;
            color: #155724;
        }

        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }

        .badge-adopted {
            background: #cce5ff;
            color: #004085;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            flex: 1;
            padding: 16px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .shelter-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .shelter-info h3 {
            margin-bottom: 10px;
            color: #333;
        }

        .shelter-info p {
            color: #666;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">🐾 Peto Care</div>
            <div class="nav-links">
                <a href="home.jsp">Home</a>
                <a href="pets">Browse Pets</a>
                <% if (userId != null) { %>
                    <a href="logout">Logout</a>
                <% } else { %>
                    <a href="login.jsp">Login</a>
                <% } %>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="pet-detail-card">
            <div class="pet-header">
                <div class="pet-icon">
                    <%= pet.getType().equals("Dog") ? "🐕" : "🐱" %>
                </div>
                <h1><%= pet.getName() %></h1>
                <p><%= pet.getBreed() %></p>
            </div>

            <div class="pet-body">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Age</div>
                        <div class="info-value"><%= pet.getAge() %> years</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Gender</div>
                        <div class="info-value"><%= pet.getGender() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Type</div>
                        <div class="info-value"><%= pet.getType() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <span class="badge badge-<%= pet.getStatus() %>">
                                <%= pet.getStatus().toUpperCase() %>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <h2>About <%= pet.getName() %></h2>
                    <p><%= pet.getDescription() %></p>
                </div>

                <div class="section">
                    <h2>Health Information</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Health Status</div>
                            <div class="info-value"><%= pet.getHealthStatus() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Vaccination Status</div>
                            <div class="info-value"><%= pet.getVaccinationStatus() %></div>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <h2>Shelter Information</h2>
                    <div class="shelter-info">
                        <h3><%= shelter.getName() %></h3>
                        <p>📍 <%= shelter.getAddress() %></p>
                        <p>📞 <%= shelter.getContact() %></p>
                    </div>
                </div>

                <% if (alreadyApplied) { %>
                    <div class="alert alert-info">
                        You have already applied for this pet. Check your dashboard for status updates.
                    </div>
                <% } %>

                <div class="action-buttons">
                    <% if (userId != null && "adopter".equals(userRole) && "available".equals(pet.getStatus())) { %>
                        <% if (!alreadyApplied) { %>
                            <form action="adoption" method="post" style="flex: 1;">
                                <input type="hidden" name="action" value="apply">
                                <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                                <button type="submit" class="btn btn-primary">Apply for Adoption</button>
                            </form>
                        <% } else { %>
                            <button class="btn btn-primary" disabled>Already Applied</button>
                        <% } %>
                    <% } else if (userId == null) { %>
                        <a href="login.jsp" class="btn btn-primary">Login to Adopt</a>
                    <% } else if (!"available".equals(pet.getStatus())) { %>
                        <button class="btn btn-primary" disabled>Not Available</button>
                    <% } %>
                    <a href="pets" class="btn btn-secondary">Back to Browse</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
