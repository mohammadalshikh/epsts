<%@ page import="com.epsts.EPSTS.ScheduleItem" %>
<%@ page import="java.util.ArrayList" %>
<% ArrayList<ScheduleItem> scheduleItems = (ArrayList<ScheduleItem>) request.getAttribute("scheduleItems"); %>
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
            display: flex;
            flex-direction: column;
        }

        html, body {
            height: 100%;
        }

        .container {
            flex: 1;
        }

        .bg-image-wrapper {
            background-image: url('../bg.jpg'); /* Set the background image */
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center top;
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

        .btn-action {
            background-color: #2980b9;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }

        .btn-action:hover {
            color: #fff;
        }

        .empty-schedule-message {
            display: none;
            text-align: center;
            font-size: 18px;
            margin-top: 20px;
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

<div class="container">
    <br><br>
    <h1>My Schedule</h1>

    <div class="d-flex justify-content-end mb-3">
        <form action="/report" method="get">
            <button type="submit" id="report" class="btn btn-action">Report COVID-19 symptoms</button>
        </form>
    </div>
    ${reportMessage}
    <br> <br>
    <form action="/updateCartItemQuantity" id="updateQuantity" method="get">
        <table class="table" id="scheduleTable">
            <thead>
            <tr>
                <th></th>
                <th style="text-align: center;">Date</th>
                <th style="text-align: center;">Facility</th>
                <th style="text-align: center;">Start time</th>
                <th style="text-align: center;">End time</th>
                <th></th>
            </tr>
            </thead>
            <tbody>

            <%-- Loop through the cart items and populate the table --%>
            <% for (ScheduleItem item : scheduleItems) { %>
            <tr>
                <td style="width: 50px;"></td>
                <td style="width: 150px; text-align: center;" id="1"><%= item.getDate() %>
                </td>
                <td style="width: 150px; text-align: center;" ><%= item.getFacility() %>
                </td>
                <td style="width: 100px; text-align: center;"><%= item.getStartTime() %>
                </td>
                <td style="width: 100px; text-align: center;"><%= item.getEndTime() %>
                </td>
                <td style="width: 50px;"></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </form>

    <br>
    <p class="empty-schedule-message" id="emptyScheduleMessage">Your schedule is currently empty, add some assignments to view them
        here.</p>
</div>

<br><br>

<footer class="footer">
    <p>&copy; 2023 EPSTS</p>
    <div>
        <a href="/contact">Contact Us</a>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
    function logout() {
        document.getElementById('logoutForm').submit();
    }
    const emptyScheduleMessage = document.getElementById("emptyScheduleMessage");
    const scheduleTable = document.getElementById('scheduleTable');
    const tdFirst = document.getElementById("1");

    if (tdFirst == null) {
        emptyScheduleMessage.style.display = 'block';
        scheduleTable.style.display = 'none';
    }


    function cancel() {
        location.reload();
    }

</script>
</body>
</html>
