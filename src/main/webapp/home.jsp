<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.PetDAO, com.petadopt.model.Pet, java.util.List" %>
<%
    PetDAO petDAO = new PetDAO();
    List<Pet> recentPets = petDAO.getAllPets();
    if (recentPets.size() > 6) {
        recentPets = recentPets.subList(0, 6);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pet Adoption System - Find Your Perfect Pet</title>
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
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: #667eea;
        }

        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 20px;
            text-align: center;
        }

        .hero h1 {
            font-size: 48px;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 20px;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        .btn {
            padding: 14px 30px;
            background: white;
            color: #667eea;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .container {
            max-width: 1200px;
            margin: 60px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 40px;
            font-size: 32px;
            color: #333;
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

        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 30px 20px;
            margin-top: 60px;
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
                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>
            </div>
        </div>
    </nav>

    <section class="hero">
        <h1>Find Your Perfect Companion</h1>
        <p>Give a loving home to pets in need. Browse our available pets and start your adoption journey today.</p>
        <a href="pets" class="btn">Browse All Pets</a>
    </section>

    <div class="container">
        <h2>Recently Added Pets</h2>
        <div class="grid">
            <% for (Pet pet : recentPets) { %>
                <div class="card">
                    <div class="card-image">
                        <%= pet.getType().equals("Dog") ? "🐕" : "🐱" %>
                    </div>
                    <div class="card-body">
                        <h3><%= pet.getName() %></h3>
                        <p><strong><%= pet.getBreed() %></strong></p>
                        <p><%= pet.getAge() %> years old • <%= pet.getGender() %></p>
                        <p><%= pet.getDescription().length() > 80 ? 
                               pet.getDescription().substring(0, 80) + "..." : 
                               pet.getDescription() %></p>
                        <span class="badge badge-<%= pet.getStatus() %>">
                            <%= pet.getStatus().toUpperCase() %>
                        </span>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <footer>
        <p>&copy; 2025 Peto Care. All rights reserved.</p>
        <p>Made with ❤️ for pets in need</p>
    </footer>
</body>
</html>
