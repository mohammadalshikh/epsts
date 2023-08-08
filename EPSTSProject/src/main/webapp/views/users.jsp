<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import=" java.io.ObjectOutputStream" %>
<%@ page import="javax.swing.plaf.nimbus.State" %>
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
    <a href="/admin/products/add" id="addProduct" class="btn btn-action">Add product</a>
</div>
<div class="container-fluid">
    <table class="table">
        <thead>
            <tr>
                <th scope="col">UserID</th>
                <th scope="col">First name</th>
                <th scope="col">Last name</th>
                <th scope="col">Username</th>
                <th scope="col">Type</th>
                <th scope="col">Works/Studies at</th>
                <th scope="col">Address</th>
                <th scope="col">email</th>
                <th scope="col">Medicare number</th>
                <th scope="col">Delete</th>
                <th scope="col">Update</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <form action="/vaccinated" method="get">
                        <input type="hidden" name="vaccinated|">
                        <input type="submit" value="Declare vaccinated" class="btn btn-primary">
                    </form>
                </td>
                <td>
                    <form action="/infected" method="get">
                        <input type="hidden" name="infected|">
                        <input type="submit" value="Declare infected" class="btn btn-warning">
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
</div>


<script>
    function logout() {
        document.getElementById('logoutForm').submit();
    }
</script>
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>


</body>
</html>