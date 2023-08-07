<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet"
          href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
          crossorigin="anonymous">

    <title>EPSTS</title>

    <style>
        .btn-action {
            background-color: #2980b9;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 100px;
        }

        .btn-action:hover {
            color: #fff;
        }

        .registration-form {
            display: block;
            margin-top: 20px;
        }

        .modal-dialog {
            top: 5%;
            transform: translateY(-95%);
        }

        .modal-content {
            background-color: white;
            border-radius: 10px;
        }

        .modal-title {
            font-size: 36px;
            color: #027BFF;
        }

        .modal-body {
            margin-top: -20px;
        }

        .btn-danger {
            background-color: #027BFF;
        }

        .btn-danger:hover {
            background-color: #005DFF;
        }

        .text-left {
            text-align: left;
        }

        #submitBtn[disabled],
        #submitBtn[disabled]:hover {
            background-color: #027BFF;
            color: #fff;
            cursor: default;
        }

        .register-container h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-container form .form-group {
            margin-bottom: 20px;
        }

        .register-container form .form-control {
            border-radius: 5px;
        }

        #opt > input::placeholder {
            font-size: 17px;
        }

    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#"> <img src="@{/images/logo.png}"
                                               src="../static/images/logo.png" width="auto" height="40"
                                               class="d-inline-block align-top" alt=""/>
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto"></ul>
            <ul class="navbar-nav">
                <li class="nav-item active"><a class="nav-link" href="/admin/home">Home</a></li>
                <li class="nav-item active"><a class="nav-link" href="#" onclick="logout()">Logout</a>
                </li>
                <form hidden id="logoutForm" method="POST" action="/logoutAdmin">
                </form>
            </ul>
        </div>
    </div>
</nav>
<br>
<div class="d-flex justify-content-end mb-3">
<a href="#" data-toggle="modal" class="btn btn-action" data-target="#registrationModal">Register a new user</a>
</div>
<div class="container-fluid">


    <table class="table">

        <tr>
            <th scope="col">User ID</th>
            <th scope="col">Username</th>
            <th scope="col">Email</th>
            <th scope="col">Address</th>
            <th scope="col">Coupons</th>
            <th scope="col">Cumulative Total</th>
        </tr>
        <tbody>
        <tr>

            <%
                try {
                    String url = "jdbc:mysql://localhost:3306/springproject";
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(url, "root", "12345678");
                    Statement stmt = con.createStatement();
                    Statement stmt2 = con.createStatement();
                    ResultSet rs = stmt.executeQuery("select * from users");
            %>
            <%
                while (rs.next()) {
            %>
            <td>
                <%= rs.getInt(1) %>
            </td>
            <td>
                <%= rs.getString(2) %>
            </td>
            <td>
                <%= rs.getString(6) %>
            </td>
            <td>
                <%= rs.getString(5) %>
            </td>
            <td>
                <%= rs.getInt(8)%>
            </td>
            <td>
                <%= rs.getInt(7)%>
            </td>

        </tr>
        <%
            }
        %>

        </tbody>
    </table>
    <%
        } catch (Exception ex) {
            out.println("Exception Occurred:: " + ex.getMessage());
        }
    %>

    <div class="modal fade" id="registrationModal" tabindex="-1" role="dialog" aria-labelledby="registrationModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="registrationModalLabel">Create an account</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="newuserregister" method="post" class="registration-form" id="registrationForm">
                        <div class="form-group">
                            <label for="email" style="display: block; width: 100%; text-align: left;">Email
                                address</label>
                            <input type="email" class="form-control form-control-lg" required minlength="6" required
                                   name="email" id="email"
                                   aria-describedby="emailHelp" oninput="validateEmail()">
                            <div class="text-left"><span id="emailError" class="error-message"></span></div>
                        </div>
                        <div class="form-group">
                            <label for="firstName"
                                   style="display: block; width: 100%; text-align: left;">Username</label>
                            <input type="text" name="username" id="firstName" required
                                   class="form-control form-control-lg" oninput="validateUsername()">
                            <div class="text-left"><span id="usernameError" class="error-message"></span></div>
                        </div>
                        <div class="form-group">
                            <label for="passwordd"
                                   style="display: block; width: 100%; text-align: left;">Password</label>
                            <input type="password" class="form-control form-control-lg" required name="password"
                                   id="passwordd"
                                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*?[~`!@#$%\^&*()\-_=+[\]{};:\x27.,\x22\\|/?><]).{8,}"
                                   title="Must contain: at least one number, one uppercase letter, one lowercase letter, one special character, and 8 or more characters"
                                   required>
                            <div style="margin-right: 70%;"><input type="checkbox" onclick="showPassword()">
                                <p style="display: inline;">Show password</p></div>
                        </div>
                        <div id="opt" class="form-group">
                            <label for="address" style="display: block; width: 100%; text-align: left;">Address</label>
                            <input class="form-control form-control-lg" rows="3" id="address" placeholder="Optional"
                                   name="address"></input>
                        </div>
                        <input id="submitBtn" type="submit" disabled value="Register"
                               class="btn btn-danger btn-block"><br>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
        crossorigin="anonymous"></script>
<script
        src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
        crossorigin="anonymous"></script>
<script
        src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
        crossorigin="anonymous"></script>

<script>
        function logout() {
        document.getElementById('logoutForm').submit();
    }
    function toggleRegistrationForm() {
        var loginContainer = document.querySelector('#loginContainer');
        var registrationForm = document.querySelector('#registrationForm');

        if (loginContainer.style.display === 'none') {
            loginContainer.style.display = 'block';
            registrationForm.style.display = 'none';
        } else {
            loginContainer.style.display = 'none';
            registrationForm.style.display = 'block';
        }
    }

    function showPassword() {
        var x = document.getElementById("passwordd");
        if (x.type === "password") {
            x.type = "text";
        } else {
            x.type = "password";
        }
    }

    function checkUsernameAvailability(username) {
        return $.ajax({
            type: "GET",
            url: "/checkUsernameAvailability",
            data: {username: username},
        });
    }

    function checkEmailAvailability(email) {
        return $.ajax({
            type: "GET",
            url: "/checkEmailAvailability",
            data: {email: email},
        });
    }

    function updateSubmitButtonState() {
        var username = document.getElementById("firstName").value;
        var email = document.getElementById("email").value;
        var password = document.getElementById("passwordd").value;
        var isValid = true;

        if (!username) {
            isValid = false;
        }

        if (!email) {
            isValid = false;
        } else {
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                isValid = false;
                document.getElementById("emailError").textContent = "Invalid email format";
            }
        }

        if (!password) {
            isValid = false;
        }

        var usernameErrorElement = document.getElementById("usernameError");
        var emailErrorElement = document.getElementById("emailError");
        if (usernameErrorElement.textContent || emailErrorElement.textContent) {
            isValid = false;
        }

        var submitButton = document.getElementById("submitBtn");
        submitButton.disabled = !isValid;
    }

    document.getElementById("firstName").addEventListener("input", function () {
        var username = this.value;
        if (username) {
            checkUsernameAvailability(username)
                .then(function (response) {
                    var errorElement = document.getElementById("usernameError");
                    if (response.exists) {
                        errorElement.textContent = "Username already exists";
                        updateSubmitButtonState();
                    } else {
                        errorElement.textContent = "";
                        var emailErrorElement = document.getElementById("emailError");
                        if (!emailErrorElement.textContent) {
                            updateSubmitButtonState();
                        }
                    }
                })
                .catch(function (error) {
                    console.error("Error checking username availability:", error);
                });
        } else {
            document.getElementById("usernameError").textContent = "";
            updateSubmitButtonState();
        }
    });

    document.getElementById("email").addEventListener("input", function () {
        var email = this.value;
        if (email) {
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                document.getElementById("emailError").textContent = "Invalid email format";
                updateSubmitButtonState();
                return;
            }

            checkEmailAvailability(email)
                .then(function (response) {
                    var errorElement = document.getElementById("emailError");
                    if (response.exists) {
                        errorElement.textContent = "Email already exists";
                        updateSubmitButtonState();
                    } else {
                        errorElement.textContent = "";
                        var usernameErrorElement = document.getElementById("usernameError");
                        if (!usernameErrorElement.textContent) {
                            updateSubmitButtonState();
                        }
                    }
                })
                .catch(function (error) {
                    console.error("Error checking email availability:", error);
                });
        } else {
            document.getElementById("emailError").textContent = "";
            updateSubmitButtonState();
        }
    });

    document.getElementById("passwordd").addEventListener("input", function () {
        updateSubmitButtonState();
    });
</script>
</body>
</html>