<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EPSTS</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
          crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
          integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ"
          crossorigin="anonymous">
    <style>

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #F8F9FA;
            display: flex;
            flex-direction: column;
        }

        .bg-image-wrapper {
            background-image: url('../bg.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center top;
        }

        .container {
            flex: 1;
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

        .hero-section {
            text-align: center;
            padding: 120px 0;
        }

        .hero-text {
            font-size: 36px;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            margin-bottom: 20px;
            color: white;
        }

        .search-container {
            max-width: 500px;
            margin: 0 auto;
            text-align: center;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 30px;
            font-size: 16px;
            outline: none;
        }

        #searchResults {
            position: absolute;
            z-index: 1;
            background-color: #fff;
            border: 1px solid #ddd;
            width: 100%;
            max-height: 200px;
            overflow-y: auto;
            display: none;
            list-style: none;
            padding-left: 0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        #searchResults li {
            padding: 8px;
            cursor: pointer;
            color: #292929;
        }

        #searchResults li:hover {
            background-color: #f2f2f2;
        }

        #viewAllBtn {
            display: none;
        }

        .search-btn {
            background-color: #027BFF;
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 15px 30px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }

        .search-btn:hover {
            color: white;
            text-decoration: none;
            background-color: #005DFF;
        }

        .some-item img {
            width: 300px;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
        }

        .some-item h4 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .some-item p {
            font-size: 16px;
            color: #555;
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

        html, body {
            height: 100%;
        }

    </style>
</head>
<body>
<div style="height: 100%;" class="bg-image-wrapper">
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
    <section class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <h1 class="hero-text">Education Personnel Status Tracking System</h1>
                    <div class="search-container">
                        <input type="text" class="search-input" placeholder="Search..." id="searchInput">
                        <ul style="color: #292929" id="searchResults"></ul>
                        <a class="search-btn" href="#" id="viewAllBtn">View all results</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
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
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');

    searchInput.addEventListener('input', handleSearch);

    function handleSearch() {
        const query = searchInput.value.trim();

        if (query !== '') {
            const sampleResults = [
            ];

            const filteredResults = sampleResults.filter(result => result.toLowerCase().includes(query.toLowerCase()));

            displaySearchResults(filteredResults);
        } else {
            searchResults.style.display = 'none';
        }
    }

    function displaySearchResults(results) {
        searchResults.innerHTML = ''; // Clear previous results

        if (results.length > 0) {
            for (let i = 0; i < Math.min(results.length, 3); i++) {
                const li = document.createElement('li');
                li.textContent = results[i];
                searchResults.appendChild(li);
            }
            if (results.length > 3) {
                const viewAllLi = document.createElement('li');
                viewAllLi.textContent = 'View all results';
                viewAllLi.addEventListener('click', () => {
                    // Add your logic for handling the form submission here
                    // For example, you can redirect to a search results page or handle it via AJAX.
                    console.log('View all results clicked.');
                });
                searchResults.appendChild(viewAllLi);
            }
            searchResults.style.display = 'block';
        } else {
            const li = document.createElement('li');
            li.textContent = 'No results found.';
            searchResults.appendChild(li);
            searchResults.style.display = 'block';
        }
    }

    searchResults.addEventListener('click', function (event) {
        if (event.target.tagName === 'LI') {
            searchInput.value = event.target.textContent;
            searchResults.style.display = 'none';
        }
    });

    document.addEventListener('click', function (event) {
        const target = event.target;
        if (!target.matches('.search-input') && !target.matches('#searchResults li')) {
            searchResults.style.display = 'none';
        }
    });

    searchInput.addEventListener('keypress', function (event) {
        if (event.key === 'Enter') {
            event.preventDefault();
            const query = searchInput.value.trim();
            // Add your logic for handling the search here
            // For example, you can redirect to a search results page or handle it via AJAX.
        }
    });
</script>

<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
        crossorigin="anonymous"></script>
</body>
</html>