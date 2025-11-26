<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.*, com.petadopt.model.*, java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");

    if (userId == null || !"admin".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    PetDAO petDAO = new PetDAO();
    ShelterDAO shelterDAO = new ShelterDAO();
    AdoptionRequestDAO requestDAO = new AdoptionRequestDAO();

    List<User> allUsers = userDAO.getAllUsers();
    List<Pet> allPets = petDAO.getAllPets();
    List<Shelter> allShelters = shelterDAO.getAllShelters();
    List<AdoptionRequest> allRequests = requestDAO.getAllRequests();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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
            max-width: 1400px;
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
            max-width: 1400px;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-value {
            font-size: 40px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            background: white;
            padding: 10px;
            border-radius: 12px;
            overflow-x: auto;
        }

        .tab {
            flex: 1;
            padding: 15px;
            background: transparent;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            color: #666;
            transition: all 0.3s;
            white-space: nowrap;
        }

        .tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section h2 {
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        thead {
            background: #f8f9fa;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            font-weight: 600;
            color: #555;
        }

        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge-adopter {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-shelter {
            background: #d4edda;
            color: #155724;
        }

        .badge-admin {
            background: #f8d7da;
            color: #721c24;
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
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">🐾 Peto Care - Admin</div>
            <div class="nav-links">
                <a href="home.jsp">Home</a>
                <a href="pets">Browse Pets</a>
                <a href="admin-dashboard.jsp">Dashboard</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-card">
            <h1>Admin Dashboard 👨‍💼</h1>
            <p>System Overview and Management</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= allUsers.size() %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= allShelters.size() %></div>
                <div class="stat-label">Shelters</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= allPets.size() %></div>
                <div class="stat-label">Total Pets</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= allPets.stream().filter(p -> "available".equals(p.getStatus())).count() %>
                </div>
                <div class="stat-label">Available Pets</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= allRequests.size() %></div>
                <div class="stat-label">Total Requests</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= allRequests.stream().filter(r -> "pending".equals(r.getStatus())).count() %>
                </div>
                <div class="stat-label">Pending Requests</div>
            </div>
        </div>

        <div class="tabs">
            <button class="tab active" onclick="showTab('users')">Users</button>
            <button class="tab" onclick="showTab('shelters')">Shelters</button>
            <button class="tab" onclick="showTab('pets')">Pets</button>
            <button class="tab" onclick="showTab('requests')">Adoption Requests</button>
        </div>

        <!-- Users Tab -->
        <div id="users-tab" class="tab-content active">
            <div class="section">
                <h2>All Users (<%= allUsers.size() %>)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Registered</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User user : allUsers) { %>
                            <tr>
                                <td><%= user.getUserId() %></td>
                                <td><strong><%= user.getName() %></strong></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhone() %></td>
                                <td>
                                    <span class="badge badge-<%= user.getRole() %>">
                                        <%= user.getRole().toUpperCase() %>
                                    </span>
                                </td>
                                <td><%= user.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Shelters Tab -->
        <div id="shelters-tab" class="tab-content">
            <div class="section">
                <h2>All Shelters (<%= allShelters.size() %>)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Shelter Name</th>
                            <th>Address</th>
                            <th>Contact</th>
                            <th>Pets Count</th>
                            <th>Created</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Shelter shelter : allShelters) { 
                            int petCount = petDAO.getPetsByShelterId(shelter.getShelterId()).size();
                        %>
                            <tr>
                                <td><%= shelter.getShelterId() %></td>
                                <td><strong><%= shelter.getName() %></strong></td>
                                <td><%= shelter.getAddress() %></td>
                                <td><%= shelter.getContact() %></td>
                                <td><%= petCount %> pets</td>
                                <td><%= shelter.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pets Tab -->
        <div id="pets-tab" class="tab-content">
            <div class="section">
                <h2>All Pets (<%= allPets.size() %>)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Breed</th>
                            <th>Age</th>
                            <th>Shelter</th>
                            <th>Status</th>
                            <th>Added</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Pet pet : allPets) { 
                            Shelter shelter = shelterDAO.getShelterById(pet.getShelterId());
                        %>
                            <tr>
                                <td><%= pet.getPetId() %></td>
                                <td><strong><%= pet.getName() %></strong></td>
                                <td><%= pet.getType() %></td>
                                <td><%= pet.getBreed() %></td>
                                <td><%= pet.getAge() %> yrs</td>
                                <td><%= shelter.getName() %></td>
                                <td>
                                    <span class="badge badge-<%= pet.getStatus() %>">
                                        <%= pet.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td><%= pet.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Requests Tab -->
        <div id="requests-tab" class="tab-content">
            <div class="section">
                <h2>All Adoption Requests (<%= allRequests.size() %>)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Pet</th>
                            <th>Adopter</th>
                            <th>Shelter</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AdoptionRequest adoptionRequest : allRequests) {
                            Pet pet = petDAO.getPetById(adoptionRequest.getPetId());
                            User adopter = userDAO.getUserById(adoptionRequest.getAdopterId());
                            Shelter shelter = shelterDAO.getShelterById(pet.getShelterId());
                        %>
                            <tr>
                                <td><%= adoptionRequest.getRequestId() %></td>
                                <td><strong><%= pet.getName() %></strong> (<%= pet.getBreed() %>)</td>
                                <td><%= adopter.getName() %><br>
                                    <small style="color: #666;"><%= adopter.getEmail() %></small>
                                </td>
                                <td><%= shelter.getName() %></td>
                                <td>
                                    <span class="badge badge-<%= adoptionRequest.getStatus() %>">
                                        <%= adoptionRequest.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td><%= adoptionRequest.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(content => content.classList.remove('active'));

            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));

            document.getElementById(tabName + '-tab').classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
