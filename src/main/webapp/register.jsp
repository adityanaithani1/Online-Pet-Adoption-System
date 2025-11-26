<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Peto Care</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .register-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 500px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
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

        input, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
            margin-top: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .shelter-fields {
            display: none;
            background: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .shelter-fields.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>🐾 Create Account</h1>
        <p class="subtitle">Join our pet adoption community</p>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="register" method="post">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required placeholder="John Doe">
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="your@email.com">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Create a password" minlength="6">
            </div>

            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" required placeholder="+1234567890">
            </div>

            <div class="form-group">
                <label for="role">Register As</label>
                <select id="role" name="role" required onchange="toggleShelterFields(this.value)">
                    <option value="">Select Role</option>
                    <option value="adopter">Adopter</option>
                    <option value="shelter">Shelter Staff</option>
                </select>
            </div>

            <div id="shelterFields" class="shelter-fields">
                <div class="form-group">
                    <label for="shelterName">Shelter Name</label>
                    <input type="text" id="shelterName" name="shelterName" placeholder="Happy Paws Shelter">
                </div>

                <div class="form-group">
                    <label for="shelterAddress">Shelter Address</label>
                    <input type="text" id="shelterAddress" name="shelterAddress" placeholder="123 Main Street, City">
                </div>
            </div>

            <button type="submit" class="btn">Create Account</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>

    <script>
        function toggleShelterFields(role) {
            const shelterFields = document.getElementById('shelterFields');
            const shelterName = document.getElementById('shelterName');
            const shelterAddress = document.getElementById('shelterAddress');

            if (role === 'shelter') {
                shelterFields.classList.add('active');
                shelterName.required = true;
                shelterAddress.required = true;
            } else {
                shelterFields.classList.remove('active');
                shelterName.required = false;
                shelterAddress.required = false;
            }
        }
    </script>
</body>
</html>
