<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petadopt.dao.*, com.petadopt.model.*, java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    Integer shelterId = (Integer) session.getAttribute("shelterId");

    if (userId == null || !"shelter".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }

    PetDAO petDAO = new PetDAO();
    AdoptionRequestDAO requestDAO = new AdoptionRequestDAO();
    UserDAO userDAO = new UserDAO();

    List<Pet> myPets = petDAO.getPetsByShelterId(shelterId);
    List<AdoptionRequest> requests = requestDAO.getRequestsByShelter(shelterId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shelter Dashboard</title>
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

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            background: white;
            padding: 10px;
            border-radius: 12px;
        }

        .tab {
            flex: 1;
            padding: 15px;
            background: transparent;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            color: #666;
            transition: all 0.3s;
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

        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-success {
            background: #28a745;
        }

        .btn-danger {
            background: #dc3545;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 13px;
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

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
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

        .action-buttons {
            display: flex;
            gap: 10px;
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
                <a href="shelter-dashboard.jsp">Dashboard</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-card">
            <h1>Welcome, <%= userName %>! 🏠</h1>
            <p>Manage your shelter's pets and adoption requests</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= myPets.size() %></div>
                <div class="stat-label">Total Pets</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= myPets.stream().filter(p -> "available".equals(p.getStatus())).count() %>
                </div>
                <div class="stat-label">Available</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= requests.stream().filter(r -> "pending".equals(r.getStatus())).count() %>
                </div>
                <div class="stat-label">Pending Requests</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= myPets.stream().filter(p -> "adopted".equals(p.getStatus())).count() %>
                </div>
                <div class="stat-label">Adopted</div>
            </div>
        </div>

        <div class="tabs">
            <button class="tab active" onclick="showTab('pets')">My Pets</button>
            <button class="tab" onclick="showTab('add')">Add New Pet</button>
            <button class="tab" onclick="showTab('requests')">Adoption Requests</button>
        </div>

        <!-- Pets Tab -->
        <div id="pets-tab" class="tab-content active">
            <div class="section">
                <h2>My Pets</h2>
                <% if (myPets.isEmpty()) { %>
                    <div class="no-data">
                        <p>No pets added yet.</p>
                        <br>
                        <button class="btn" onclick="showTab('add')">Add Your First Pet</button>
                    </div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Breed</th>
                                <th>Age</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Pet pet : myPets) { %>
                                <tr>
                                    <td><strong><%= pet.getName() %></strong></td>
                                    <td><%= pet.getType() %></td>
                                    <td><%= pet.getBreed() %></td>
                                    <td><%= pet.getAge() %> yrs</td>
                                    <td>
                                        <span class="badge badge-<%= pet.getStatus() %>">
                                            <%= pet.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="pet-details.jsp?id=<%= pet.getPetId() %>" class="btn btn-small">View</a>
                                            <form action="pets" method="get" style="display: inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= pet.getPetId() %>">
                                                <button type="submit" class="btn btn-small btn-danger" 
                                                        onclick="return confirm('Delete this pet?')">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>

        <!-- Add Pet Tab -->
        <div id="add-tab" class="tab-content">
            <div class="section">
                <h2>Add New Pet</h2>
                <form action="pets" method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Pet Name *</label>
                            <input type="text" id="name" name="name" required placeholder="Max">
                        </div>
                        <div class="form-group">
                            <label for="type">Type *</label>
                            <select id="type" name="type" required>
                                <option value="">Select Type</option>
                                <option value="Dog">Dog</option>
                                <option value="Cat">Cat</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="breed">Breed *</label>
                            <input type="text" id="breed" name="breed" required placeholder="Golden Retriever">
                        </div>
                        <div class="form-group">
                            <label for="age">Age (years) *</label>
                            <input type="number" id="age" name="age" step="0.1" min="0" max="20" required placeholder="2.5">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="gender">Gender *</label>
                            <select id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="healthStatus">Health Status *</label>
                            <select id="healthStatus" name="healthStatus" required>
                                <option value="">Select Status</option>
                                <option value="Excellent">Excellent</option>
                                <option value="Good">Good</option>
                                <option value="Fair">Fair</option>
                                <option value="Needs Attention">Needs Attention</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="vaccinationStatus">Vaccination Status *</label>
                        <select id="vaccinationStatus" name="vaccinationStatus" required>
                            <option value="">Select Status</option>
                            <option value="Up to Date">Up to Date</option>
                            <option value="Partial">Partial</option>
                            <option value="Not Vaccinated">Not Vaccinated</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Description *</label>
                        <textarea id="description" name="description" required 
                                  placeholder="Tell us about this pet's personality, behavior, and any special needs..."></textarea>
                    </div>

                    <button type="submit" class="btn">Add Pet</button>
                </form>
            </div>
        </div>

        <!-- Adoption Requests Tab -->
        <div id="requests-tab" class="tab-content">
            <div class="section">
                <h2>Adoption Requests</h2>
                <% if (requests.isEmpty()) { %>
                    <div class="no-data">
                        <p>No adoption requests yet.</p>
                    </div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Pet Name</th>
                                <th>Adopter</th>
                                <th>Applied On</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (AdoptionRequest adoptionRequest : requests) {
                                Pet pet = petDAO.getPetById(adoptionRequest.getPetId());
                                User adopter = userDAO.getUserById(adoptionRequest.getAdopterId());
                            %>
                                <tr>
                                    <td><strong><%= pet.getName() %></strong></td>
                                    <td><%= adopter.getName() %><br>
                                        <small style="color: #666;"><%= adopter.getEmail() %></small><br>
                                        <small style="color: #666;">📞 <%= adopter.getPhone() %></small>
                                    </td>
                                    <td><%= adoptionRequest.getCreatedAt() %></td>
                                    <td>
                                        <span class="badge badge-<%= adoptionRequest.getStatus() %>">
                                            <%= adoptionRequest.getStatus().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if ("pending".equals(adoptionRequest.getStatus())) { %>
                                            <div class="action-buttons">
                                                <form action="adoption" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="requestId" value="<%= adoptionRequest.getRequestId() %>">
                                                    <input type="hidden" name="petId" value="<%= adoptionRequest.getPetId() %>">
                                                    <input type="hidden" name="status" value="approved">
                                                    <button type="submit" class="btn btn-small btn-success">Approve</button>
                                                </form>
                                                <form action="adoption" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="requestId" value="<%= adoptionRequest.getRequestId() %>">
                                                    <input type="hidden" name="petId" value="<%= adoptionRequest.getPetId() %>">
                                                    <input type="hidden" name="status" value="rejected">
                                                    <button type="submit" class="btn btn-small btn-danger">Reject</button>
                                                </form>
                                            </div>
                                        <% } else { %>
                                            <span style="color: #999;">Processed</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabName) {
            // Hide all tab contents
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(content => content.classList.remove('active'));

            // Deactivate all tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));

            // Show selected tab content
            document.getElementById(tabName + '-tab').classList.add('active');

            // Activate clicked tab
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
