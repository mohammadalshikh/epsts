<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EPSTS</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #F8F9FA;
        }

        html, body {
            height: 100%;
        }

        .bg-image-wrapper {
            background-image: url('../bg.jpg'); /* Set the background image */
            background-size: cover; /* Adjust the background size to cover the entire container */
            background-repeat: no-repeat; /* Prevent the background from repeating */
            background-position: center top; /* Center the background image at the top */
        }

        .navbar {
            background-color: transparent;
            font-weight: 500;
            font-size: 17px;
        }

        .navbar-brand {
            font-size: 28px;
            color: #fff;
        }

        .navbar-brand:hover {
            font-size: 28px;
            color: #027BFF;
        }

        .navbar-nav .nav-link {
            color: #fff;
            transition: 0.5s ease;
        }

        .navbar-nav .nav-link:hover {
            color: #027BFF;
            font-weight: bold;
        }

        .footer {
            background-color: #292929;
            color: #fff;
            text-align: center;
            padding: 15px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
        }

        .footer a {
            color: #fff;
            font-weight: bold;
            text-decoration: none;
            margin: 5px;
        }

        .footer a:hover {
            color: #027BFF;
        }

    </style>
</head>
<body>
<div class="bg-image-wrapper">
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/home">
                EPSTS
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/schedule">Schedule</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/profile">Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="logout()">Logout</a>
                    </li>
                    <form hidden id="logoutForm" method="POST" action="/logoutUser">
                    </form>
                </ul>
            </div>
        </div>
    </nav>
</div>
<br>
<div class="container">
    <div class="row">
        <div class="col-sm-8 mx-auto">
            <h3 style="margin-top: 10px">User Profile</h3>
            <br>
            <form action="updateUser" method="post">
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="firstName">First name</label>
                        <input type="text" class="form-control form-control-lg" readonly value="${firstName}" name="firstName" id="firstName">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="lastName">Last name</label>
                        <input type="text" class="form-control form-control-lg" readonly value="${lastName}" name="lastName" id="lastName">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="username">Username</label>
                        <input type="text" name="username" id="username" required value="${username}" class="form-control form-control-lg">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="password">Password</label>
                        <input type="password" class="form-control form-control-lg" value="${password}" required name="password" id="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*?[~`!@#$%\^&*()\-_=+[\]{};:\x27.,\x22\\|/?><]).{8,}" title="Must contain: at least one number, one uppercase letter, one lowercase letter, one special character, and 8 or more characters">
                        <input type="checkbox" onclick="showPassword()"> Show password
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="type">Type</label>
                        <input type="text" name="type" id="type" readonly value="${type}" class="form-control form-control-lg">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="type">Works/Studies at</label>
                        <input type="text" name="workLocation" id="workLocation" readonly value="${workLocation}" class="form-control form-control-lg">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="address">Address</label>
                        <textarea class="form-control form-control-lg" rows="3" placeholder="Optional" name="address" id="address">${address}</textarea>
                    </div>
                    <div class="form-group col-md-6">
                        <label for="email">Email address</label>
                        <input type="email" class="form-control form-control-lg" required minlength="6" value="${email}" name="email" id="email" aria-describedby="emailHelp">
                    </div>
                </div>
                <div class="form-group">
                    <label for="medicareNumb">Medicare Number</label>
                    <input type="number" name="medicareNumb" id="medicareNumb" readonly value="${medicareNumb}" class="form-control form-control-lg">
                </div>
                <div class="form-group">
                    <input type="submit" value="Update Profile" class="btn btn-primary btn-block"><br>
                </div>
            </form>
        </div>
    </div>
</div>

<br> <br>
<footer class="footer">
    <p>&copy; 2023 EPSTS</p>
    <div>
        <a href="/contact">Contact Us</a>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
</script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

<script>
    function logout() {
        document.getElementById('logoutForm').submit();
    }
    function showPassword() {
        var x = document.getElementById("password");
        if (x.type === "password") {
            x.type = "text";
        } else {
            x.type = "password";
        }
    }
</script>

</body>
</html>