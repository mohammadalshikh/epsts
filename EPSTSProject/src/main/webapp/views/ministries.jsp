<%@ page import="com.epsts.EPSTS.MinistryItem" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.epsts.EPSTS.Facility" %>
<% ArrayList<MinistryItem> ministryItems = (ArrayList<MinistryItem>) request.getAttribute("ministryItems"); %>
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
<br> <br>
<div class="container-fluid">
    <table class="table">
        <thead>
        <tr>
            <% for (MinistryItem item : ministryItems) { %>
            <th style="text-align: center; font-size: 10px"><%= item.getName() %></th>
            <% } %>
        </tr>
        </thead>
        <tbody>
        <tr>
            <% for (MinistryItem item : ministryItems) { %>
            <td style="text-align: center; font-size: 10px;">
                <%= item.getHeadOfficeFacility().getFacilityName() %> (ID: <%=item.getHeadOfficeFacility().getFacilityID()%>)<br>
                <% for (Facility facility : item.getFacilities()) { %>
                <%= facility.getFacilityName() %> (ID: <%= facility.getFacilityID() %>)<br>
                <% } %>
            </td>
            <% } %>
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