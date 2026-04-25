<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib
        prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>All Auctions - Emarald Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet"
    />
    <style>
        body {
            font-family: "Inter", sans-serif;
            background-color: #e0e0e0; /* Light gray background to match theme */
        }

        .main-card {
            display: flex;
            background-color: white;
            border-radius: 1rem; /* rounded-2xl */
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); /* shadow-2xl */
            overflow: hidden; /* Ensures rounded corners apply to children */
            max-width: 1200px; /* Wider for auction list */
            width: 95%; /* Responsive width */
            min-height: 600px; /* Minimum height to maintain structure */
        }

        .image-section {
            /* Using a different placeholder for variety, consistent style */
            background-image: url("https://placehold.co/500x700/D4A06F/4C84F4?text=Emarald+Auctions");
            background-size: cover;
            background-position: center;
        }

        @media (max-width: 768px) {
            .main-card {
                flex-direction: column; /* Stack columns on small screens */
                height: auto;
            }

            .image-section {
                height: 200px; /* Smaller height for image on mobile */
                width: 100%;
            }

            .content-section {
                width: 100%;
                padding: 1.5rem; /* Adjust padding for mobile */
            }
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">
<div class="main-card">
    <div class="content-section flex-2 p-8 md:p-12 flex flex-col">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-semibold text-gray-900">Active Auctions</h2>
            <a href="new-auction.jsp">
                <button
                        class="bg-gray-900 hover:bg-gray-800 text-white font-semibold py-2 px-4 rounded-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-2 focus:ring-offset-white"
                >
                    New Auction
                </button>
            </a>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-500 text-white p-3 rounded-md mb-4 text-sm">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <div
                id="notifications"
                class="bg-blue-100 text-blue-800 p-3 rounded-md mb-4 text-sm hidden"
                role="alert"
        ></div>

        <div
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 flex-grow"
        >
            <c:choose>
                <c:when test="${not empty auctions}">
                    <c:forEach var="auction" items="${auctions}">
                        <div
                                class="border border-gray-200 rounded-lg p-4 shadow-md bg-white flex flex-col justify-between"
                        >
                            <img
                                    src="${auction.imageUrl}"
                                    alt="${auction.name}"
                                    onerror="this.onerror=null;this.src='https://placehold.co/400x200/cccccc/333333?text=No+Image';"
                                    class="w-full h-48 object-cover rounded-md mb-4"
                            />
                            <h3 class="text-xl font-semibold text-gray-900 mb-2">
                                    ${auction.name}
                            </h3>
                            <p class="text-gray-600 text-sm mb-3 line-clamp-3">
                                    ${auction.description}
                            </p>

                            <div class="text-gray-800 text-sm mb-4">
                                <p class="mb-1">
                                    <strong>Starting Price:</strong> $<c:out
                                        value="${auction.startingPrice}"
                                />
                                </p>
                                <p>
                                    <strong>Current Bid:</strong>
                                    <span id="currentBid-${auction.id}"
                                          class="font-bold text-green-700"
                                    >${auction.currentHighestBid}</span>
                                </p>
                            </div>
                            <a
                                    href="view?this=${auction.id}"
                                    class="mt-auto inline-block rounded-md bg-blue-600 px-4 py-2 text-sm font-semibold text-white text-center hover:bg-blue-700 transition duration-300 ease-in-out"
                            >
                                View Auction
                            </a>

                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise
                >
                    <div class="col-span-full text-center text-gray-600 py-8">
                        No active auctions available. Why not
                        <a href="new-auction.jsp" class="text-blue-600 hover:underline"
                        >create one</a
                        >?
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <p class="mt-8 text-gray-500 text-xs text-center">
            © <%= new java.util.Date().getYear() + 1900 %> Your Company. All
            rights reserved.
        </p>
    </div>
</div>

<script>
    console.log(
        "Attempting to connect to:",
        "ws://" + window.location.host + "/ee-app/ws/bids"
    );

    console.log("Current location:", window.location);

    console.log(
        "Attempting to connect to:",
        "ws://" + window.location.host + "/ee-app/ws/bids"
    );

    console.log("Current location:", window.location);

    const ws = new WebSocket(
        "ws://" + window.location.host + "/ee-app/ws/bids"
    );

    ws.onopen = function () {
        console.log("WebSocket connected");
    };

    ws.onclose = function () {
        console.log("WebSocket disconnected");
    };

    ws.onerror = function (error) {
        console.error("WebSocket error:", error);
    };

    ws.onmessage = function (event) {
        console.log("WebSocket onmessage");

        const data = JSON.parse(event.data);

        const notification = document.getElementById("notifications");

        if (data.type === "bid") {
            const auctionId = data.auctionId;

            const bidElement = document.getElementById("currentBid-" + auctionId);

            const currentAuctionId = document.querySelector(
                'input[name="auction"]'
            )?.value;

            if (bidElement) {
                bidElement.textContent = data.bidAmount;

                if (!currentAuctionId || currentAuctionId == auctionId) {
                    notification.textContent = `New bid of $${data.bidAmount} placed on auction ${auctionId} by ${data.bidderName}`;

                    setTimeout(() => (notification.textContent = ""), 3000);
                }
            }
        } else if (data.type === "auction") {
            notification.textContent = `New auction "${data.title}" created by ${data.ownerName} (ID: ${data.auctionId})`;

            setTimeout(() => (notification.textContent = ""), 3000);
        }
        z;
    };
</script>
</body>
</html>
