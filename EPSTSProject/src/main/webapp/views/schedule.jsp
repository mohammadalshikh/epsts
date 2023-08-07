<%@ page import="com.epsts.EPSTS.CartItem" %>
<%@ page import="java.util.ArrayList" %>
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

        .btn-delete {
            background-color: #027BFF;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
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

        .btn-delete:hover {
            color: #fff;
        }

        .empty-cart-message {
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


        .disabled-input {
            background-color: transparent;
            border: none;
            pointer-events: none;
            font-size: inherit;
            color: black;
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
        <form action="/clearcart" method="get">
            <button type="submit" id="clearCart" class="btn btn-action">Clear cart</button>
        </form>
        <form action="/movecustomtocart" method="get">
            <button id="add" type="submit" class="btn btn-action">Add custom cart to cart</button>
        </form>
        <a id="show" href="/custom-cart" class="btn btn-action">Show custom cart</a>
        <input id="edit" type="button" value="Edit quantities" class="btn btn-action" onClick="editMode()">

        <button id="confirm" hidden type="submit" form="updateQuantity" class="btn btn-action">Confirm changes</button>
        <input hidden id="cancel" type="button" value="Cancel" class="btn btn-action" onClick="cancel()">
    </div>
    <br>
    <form action="/updateCartItemQuantity" id="updateQuantity" method="get">
        <table class="table" id="cartTable">
            <thead>
            <tr>
                <th></th>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Total Price</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <%-- Get the cartItems ArrayList from the Model object --%>
            <% ArrayList<CartItem> cartItems = (ArrayList<CartItem>) request.getAttribute("cartItems"); %>

            <%-- Loop through the cart items and populate the table --%>
            <% for (CartItem item : cartItems) { %>
            <tr>
                <td></td>
                <td style="width: 250px" id="1"><%= item.getProductName() %>
                </td>
                <td style="width: 250px">
                    <input pattern="[1-9][0-9]*" min="1" style="width: 80px" class="disabled-input" disabled
                           type="number" name="<%= item.getProductID() %>|quantity" value="<%= item.getQuantity() %>">
                    <!-- Add a hidden input to store the productID -->
                    <input type="hidden" name="productIDs" value="<%= item.getProductID() %>">
                </td>
                <td style="width: 250px">$<%= item.getTotalPrice() %>
                </td>
                <td>
                    <form action="/deleteitem" method="get">
                        <input type="hidden" name="productID" value="<%= item.getProductID() %>">
                        <button type="submit" class="btn btn-delete">Remove</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </form>

    <br>
    <p class="empty-cart-message" id="emptyCartMessage">Your schedule is currently empty, add some assignments to view them
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
    const cartTable = document.getElementById("cartTable");
    const clearCartButton = document.getElementById("clearCart");
    const emptyCartMessage = document.getElementById("emptyCartMessage");
    const tdFirst = document.getElementById("1");
    const total = document.getElementById('total');
    const checkOut = document.getElementById('checkOut');

    if (tdFirst == null) {
        cartTable.style.display = 'none';
        clearCartButton.style.display = 'none';
        emptyCartMessage.style.display = 'block';
        total.style.display = 'none';
        checkOut.style.display = 'none';
        document.getElementById("edit").hidden = true;
    }

    function editMode() {
        document.getElementById("add").hidden = true;
        document.getElementById("clearCart").hidden = true;
        document.getElementById("show").hidden = true;
        document.getElementById("edit").hidden = true;
        document.getElementById("confirm").hidden = false;
        document.getElementById("cancel").hidden = false;

        const quantityInputs = document.querySelectorAll('input[name*="|quantity"]');

        // Loop through each quantity input and update its attributes and styles
        quantityInputs.forEach((input) => {
            // Remove the "disabled" attribute from the input
            input.removeAttribute("disabled");
            input.classList.remove("disabled-input");
            input.style.backgroundColor = "white";
            input.style.border = "1px solid #ccc";
        });
    }


    function cancel() {
        location.reload();
    }

</script>
</body>
</html>
