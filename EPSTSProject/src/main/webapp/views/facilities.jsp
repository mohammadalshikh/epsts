<%@ page import="com.epsts.EPSTS.FacilityItem" %>
<%@ page import="java.util.ArrayList" %>
<% ArrayList<FacilityItem> facilityItems = (ArrayList<FacilityItem>) request.getAttribute("facilityItems"); %>
<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <title>EPSTS</title>

</head>
<body class="bg-light">
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
<br>
<br> <br>
<div class="container-fluid">
    <table class="table">
        <thead>
        <tr>
            <th style="font-size: 9px" scope="col">ID</th>
            <th style="font-size: 9px" scope="col">Name</th>
            <th style="font-size: 9px" scope="col">Belongs to</th>
            <th style="font-size: 9px" scope="col">Province</th>
            <th style="font-size: 9px" scope="col">Address</th>
            <th style="font-size: 9px" scope="col">City</th>
            <th style="font-size: 9px" scope="col">Capacity</th>
            <th style="font-size: 9px" scope="col">Postal code</th>
            <th style="font-size: 9px" scope="col">Website</th>
            <th style="font-size: 9px" scope="col">Type</th>
            <th style="font-size: 9px" scope="col">Email</th>
        </tr>
        </thead>

        <tbody>
        <% for (FacilityItem item : facilityItems) { %>
        <tr>
            <td style="font-size: 9px"><%= item.getFacilityID() %></td>
            <td style="font-size: 9px"><%= item.getName() %></td>
            <td style="font-size: 9px"><%= item.getMinistryName() %></td>
            <td style="font-size: 9px"><%= item.getProvince() %></td>
            <td style="font-size: 9px"><%= item.getAddress() %></td>
            <td style="font-size: 9px"><%= item.getCity() %></td>
            <td style="font-size: 9px"><%= item.getCapacity() %></td>
            <td style="font-size: 9px"><%= item.getPostalCode() %></td>
            <td style="font-size: 9px"><%= item.getWebAddress() %></td>
            <td style="font-size: 9px"><%= item.getType() %></td>
            <td style="font-size: 9px"><%= item.getEmail() %></td>
        </tr>
        <% } %>
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