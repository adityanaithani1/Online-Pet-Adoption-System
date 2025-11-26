<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.PetDAO, com.petadopt.model.Pet, java.util.List" %>
<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    if (pets == null) {
        PetDAO petDAO = new PetDAO();
        pets = petDAO.getAllPets();
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Pets - Pet Adoption System</title>
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

        h1 {
            margin-bottom: 30px;
            color: #333;
        }

        .filter-bar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .filter-bar form {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: end;
        }

        .filter-group {
            flex: 1;
            min-width: 150px;
        }

        .filter-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            font-size: 14px;
            color: #555;
        }

        select {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-reset {
            background: #6c757d;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
        }

        .card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
        }

        .card-body {
            padding: 20px;
        }

        .card-body h3 {
            margin-bottom: 10px;
            color: #333;
        }

        .card-body p {
            color: #666;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 10px;
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

        .card-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }

        .btn-small {
            flex: 1;
            padding: 8px 16px;
            font-size: 13px;
            text-align: center;
            text-decoration: none;
            color: white;
            background: #667eea;
            border-radius: 6px;
            border: none;
            cursor: pointer;
        }

        .btn-small:hover {
            background: #5568d3;
        }

        .no-pets {
            text-align: center;
            padding: 60px 20px;
            color: #999;
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
                    <% if ("adopter".equals(userRole)) { %>
                        <a href="adopter-dashboard.jsp">Dashboard</a>
                    <% } else if ("shelter".equals(userRole)) { %>
                        <a href="shelter-dashboard.jsp">Dashboard</a>
                    <% } else if ("admin".equals(userRole)) { %>
                        <a href="admin-dashboard.jsp">Dashboard</a>
                    <% } %>
                    <a href="logout">Logout</a>
                <% } else { %>
                    <a href="login.jsp">Login</a>
                <% } %>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1>Browse Available Pets</h1>

        <div class="filter-bar">
            <form action="pets" method="get">
                <input type="hidden" name="action" value="filter">
                <div class="filter-group">
                    <label for="type">Pet Type</label>
                    <select id="type" name="type">
                        <option value="">All Types</option>
                        <option value="Dog">Dogs</option>
                        <option value="Cat">Cats</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="">All Genders</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="">All Status</option>
                        <option value="available">Available</option>
                        <option value="pending">Pending</option>
                        <option value="adopted">Adopted</option>
                    </select>
                </div>
                <button type="submit" class="btn">Apply Filters</button>
                <button type="button" class="btn btn-reset" onclick="window.location.href='pets'">Reset</button>
            </form>
        </div>

        <% if (pets == null || pets.isEmpty()) { %>
            <div class="no-pets">
                <h2>No pets found</h2>
                <p>Try adjusting your filters or check back later!</p>
            </div>
        <% } else { %>
            <div class="grid">
                <% for (Pet pet : pets) { %>
                    <div class="card">
                        <div class="card-image">
                            <%= pet.getType().equals("Dog") ? "🐕" : "🐱" %>
                        </div>
                        <div class="card-body">
                            <h3><%= pet.getName() %></h3>
                            <p><strong><%= pet.getBreed() %></strong></p>
                            <p><%= pet.getAge() %> years old • <%= pet.getGender() %></p>
                            <p><%= pet.getDescription().length() > 100 ? 
                                   pet.getDescription().substring(0, 100) + "..." : 
                                   pet.getDescription() %></p>
                            <span class="badge badge-<%= pet.getStatus() %>">
                                <%= pet.getStatus().toUpperCase() %>
                            </span>
                            <div class="card-actions">
                                <a href="pet-details.jsp?id=<%= pet.getPetId() %>" class="btn-small">View Details</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
