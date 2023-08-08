<%@ page import="com.epsts.EPSTS.UserItem" %>
<%@ page import="java.util.ArrayList" %>
<% ArrayList<UserItem> userItems = (ArrayList<UserItem>) request.getAttribute("userItems"); %>
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
${infectedMessage}
${vaccinatedMessage}
<br> <br>
<div class="container-fluid">
    <table class="table">
        <thead>
            <tr>
                <th style="font-size: 10px" scope="col">UserID</th>
                <th style="font-size: 10px" scope="col">First name</th>
                <th style="font-size: 10px" scope="col">Last name</th>
                <th style="font-size: 10px" scope="col">Username</th>
                <th style="font-size: 10px" scope="col">Type</th>
                <th style="font-size: 10px" scope="col">Works/Studies at</th>
                <th style="font-size: 10px" scope="col">Address</th>
                <th style="font-size: 10px" scope="col">Email</th>
                <th style="font-size: 10px" scope="col">Medicare number</th>
                <th style="font-size: 10px" scope="col">Declare vaccinated</th>
                <th style="font-size: 10px" scope="col">Declare infected</th>
            </tr>
        </thead>

        <tbody>
        <% for (UserItem item : userItems) { %>
            <tr>
                <td style="font-size: 10px"><%= item.getUserID() %></td>
                <td style="font-size: 10px"><%= item.getFirstName() %></td>
                <td style="font-size: 10px"><%= item.getLastName() %></td>
                <td style="font-size: 10px"><%= item.getUsername() %></td>
                <td style="font-size: 10px"><%= item.getType() %></td>
                <td style="font-size: 10px"><%= item.getWorkLocation() %></td>
                <td style="font-size: 10px"><%= item.getAddress() %></td>
                <td style="font-size: 10px"><%= item.getEmail() %></td>
                <td style="font-size: 10px"><%= item.getMedicareNumb() %></td>
                <td style="font-size: 10px">
                    <form action="/vaccinated" method="get">
                        <input type="number" hidden name="vaccinated" value="<%= item.getMedicareNumb() %>">
                        <input style="font-size: 10px" type="submit" value="Declare vaccinated" class="btn btn-primary">
                    </form>
                </td>
                <td>
                    <form action="/infected" method="get">
                        <input type="number" hidden name="infected" value="<%= item.getMedicareNumb() %>">
                        <input style="font-size: 10px" type="submit" value="Declare infected" class="btn btn-warning">
                    </form>
                </td>
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