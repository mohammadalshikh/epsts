<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <title>EPSTS</title>
</head>

<body class="bg-dark">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
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
<div class="jumbotron text-center">
    <h1 class="display-4">Welcome Back, Admin</h1>
    <hr>
    <p>Manage your data from this Admin Panel</p>
</div>
<br>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-sm-3 pt-4">
            <div class="card" style="background-color: white;">
                <div class="card-body text-center">
                    <h4 class="card-title">Ministries</h4>
                    <p class="card-text">Manage all ministries here</p>
                    <a href="/admin/ministries" class="card-link btn btn-primary">Manage</a>
                </div>
            </div>
        </div>
        <div class="col-sm-3 pt-4">
            <div class="card" style="background-color: white;">
                <div class="card-body text-center">
                    <h4 class="card-title">Facilities</h4>
                    <p class="card-text">Manage all facilities here</p>
                    <a href="/admin/facilities" class="card-link btn btn-primary">Manage</a>
                </div>
            </div>
        </div>
        <div class="col-sm-3 pt-4">
            <div class="card" style="background-color: white;">
                <div class="card-body text-center">
                    <h4 class="card-title">Users</h4>
                    <p class="card-text">Manage all users here</p>
                    <a href="/admin/users" class="card-link btn btn-primary">Manage</a>
                </div>
            </div>
        </div>Z
    </div>
</div>

<br><br><br>
<script>
    function logout() {
        document.getElementById('logoutForm').submit();
    }
</script>

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
</body>
</html>