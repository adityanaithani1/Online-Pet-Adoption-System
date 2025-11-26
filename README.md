# 🐾 Pet Adoption System

A full-featured pet adoption web application built with Java Servlets, JSP, JDBC, and MySQL. It supports admin, shelter, and adopter dashboards for efficient pet management and adoption workflows.

## 🚀 Features

- User Registration & Login (Admin, Shelter, Adopter roles)

### Admin Dashboard
- User management
- Shelter management
- Pet management
- Adoption request tracking

### Shelter Dashboard
- Manage shelter info
- Add/edit pets
- Review requests

### Adopter Dashboard
- Search pets
- View own requests
- Track adoption status

### Pet Management
- Create/update/delete pets
- Search and filter
- Status: available / adopted / pending

### Adoption Request Workflow
- Request pet adoption
- Approve / reject requests

### Responsive UI
- Modern look using custom CSS styles and gradients

## 📦 Tech Stack

- Backend: Java Servlet API, JSP
- Frontend: HTML, CSS (custom, responsive)
- Database: MySQL (JDBC)
- Server: Apache Tomcat 9.0+
- Build: IntelliJ IDEA Artifacts / WAR packaging
- Java Version: Java 8+

## 🗃️ Directory Structure

```text
PetAdoptionSystem/
├── src/
│   └── main/
│       ├── java/
│       └── webapp/
│           └── WEB-INF/
├── sql/
│   └── schema.sql
├── pom.xml / build.gradle
└── README.md
```

🔧 Setup & Installation
```
1. Clone the repo
   
    git clone https://github.com/your-username/pet-adoption-system.git
    cd pet-adoption-system

3. Set up MySQL

    Import sql/schema.sql

    Configure DB credentials in DAO classes

4. Configure and Build

    Open project in IntelliJ IDEA

    Build Artifact → Create WAR

5. Deploy to Tomcat

    Copy .war to Tomcat webapps folder

    Run startup.bat

6. Access in browser

http://localhost:8080/PetAdoptionSystem/home.jsp
```

🖥️ Screenshots

![WhatsApp Image 2025-11-25 at 14 44 19_a9027658](https://github.com/user-attachments/assets/58a5e1a8-005b-4325-8c0f-016fd587a0e7)

![WhatsApp Image 2025-11-25 at 14 44 19_612ee921](https://github.com/user-attachments/assets/f3f45903-70d3-4fb6-b7f2-bb3237b62d01)

![WhatsApp Image 2025-11-25 at 14 44 19_e326b44f](https://github.com/user-attachments/assets/426d8047-7883-41d4-939d-14eadbc49195)

![WhatsApp Image 2025-11-25 at 14 44 19_10ad3bbb](https://github.com/user-attachments/assets/bc0e132a-82ae-480a-b757-1a0b567ce469)

📝 Usage
Roles

    Admin: Manage users, shelters, and pets

    Shelter: Add/manage pets, respond to requests

    Adopter: Search pets, request adoption

Authentication

    Register and login according to role

    Role-based dashboard shown after login

🩹 Troubleshooting
Common Issues

404 errors

    Ensure JSP files are inside WAR

    Avoid using request as loop variable in JSP

JSP compile errors

    Check Tomcat logs

Database errors

    Ensure MySQL is running

    Verify DB credentials in DAO classes

Session issues

    Check session attribute names (userId, userRole)

💡 Contributing

Pull requests are welcome.
📄 License

MIT License
🙋‍♂️ Author

Aditya Naithani
