<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <title>EPSTS</title>
    <style>
        body {
            background-image: url("../bg.jpg");
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-wrapper {
            text-align: center;
            position: relative;
        }

        .website-name-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            position: absolute;
            top: -130px;
            left: 0;
            right: 0;
        }

        .website-name {
            font-size: 80px;
            font-weight: bold;
            color: white;
            white-space: nowrap;
        }

        .login-container {
            max-width: 400px;
            background-color: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 10px;
            position: relative;
        }

        .login-container h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-container form .form-group {
            margin-bottom: 20px;
        }

        .login-container form .form-control {
            border-radius: 5px;
        }

        .login-container form .btn-login {
            background-color: #027BFF;
            color: #fff;
            border: none;
            border-radius: 5px;
            width: 100%;
        }

        .login-container form .btn-login:hover {
            background-color: #005DFF;
        }

        .error-message {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-top: 10px;
        }

        .linkControl {
            color: #027BFF;
        }

        .linkControl:hover {
            color: #027BFF;
        }

    </style>
</head>
<body>
<div class="login-wrapper">
    <div class="website-name-wrapper">
        <h1 class="website-name">EPSTS</h1>
    </div>
    <div class="login-container" id="loginContainer">
        <h2>User Login</h2>
        <form action="/" method="post">
            <div class="form-group">
                <input type="text" name="username" id="username" placeholder="Username" required
                       class="form-control form-control-lg">
            </div>
            <div class="form-group">
                <input type="password" class="form-control form-control-lg" placeholder="Password" required
                       name="password" id="password">
            </div>
            <p class="error-message">${failMessage}</p>
            <button type="submit" class="btn btn-login">Log in</button>
            <br><br>
            <span>Admin login page from <a class="linkControl" href="/admin">here</a></span>
        </form>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>

</script>
</body>
</html>
