<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.*, com.petadopt.model.*, java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");

    if (userId == null || !"adopter".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    AdoptionRequestDAO requestDAO = new AdoptionRequestDAO();
    PetDAO petDAO = new PetDAO();

    List<AdoptionRequest> myRequests = requestDAO.getRequestsByAdopter(userId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adopter Dashboard</title>
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
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 16px;
            margin-bottom: 30px;
        }

        .welcome-card h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 16px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8f9fa;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            font-weight: 600;
            color: #555;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-pending {
            background: #fff3cd;
            color: #856404;
        }

        .badge-approved {
            background: #d4edda;
            color: #155724;
        }

        .badge-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
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
            <a href="adopter-dashboard.jsp">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="welcome-card">
        <h1>Welcome, <%= userName %>! 👋</h1>
        <p>Track your adoption applications and find your perfect pet companion</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value"><%= myRequests.size() %></div>
            <div class="stat-label">Total Applications</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <%= myRequests.stream().filter(r -> "pending".equals(r.getStatus())).count() %>
            </div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <%= myRequests.stream().filter(r -> "approved".equals(r.getStatus())).count() %>
            </div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <%= myRequests.stream().filter(r -> "rejected".equals(r.getStatus())).count() %>
            </div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <div class="section">
        <h2>My Adoption Applications</h2>
        <% if (myRequests.isEmpty()) { %>
        <div class="no-data">
            <p>You haven't applied for any pets yet.</p>
            <br>
            <a href="pets" class="btn">Browse Available Pets</a>
        </div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>Pet Name</th>
                <th>Breed</th>
                <th>Applied On</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (AdoptionRequest adoptionRequest : myRequests) {
                Pet pet = petDAO.getPetById(adoptionRequest.getPetId());
            %>
            <tr>
                <td><strong><%= pet.getName() %></strong></td>
                <td><%= pet.getBreed() %></td>
                <td><%= adoptionRequest.getCreatedAt() %></td>
                <td>
                                    <span class="badge badge-<%= adoptionRequest.getStatus() %>">
                                        <%= adoptionRequest.getStatus().toUpperCase() %>
                                    </span>
                </td>
                <td>
                    <a href="pet-details.jsp?id=<%= pet.getPetId() %>" style="color: #667eea; text-decoration: none;">View Pet</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>
