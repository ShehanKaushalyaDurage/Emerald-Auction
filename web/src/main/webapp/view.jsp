<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Auction Details - Emarald Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet"
    />
    <style>
        body {
            font-family: "Inter", sans-serif;
            background-color: #e0e0e0;
        }

        .main-card {
            display: flex;
            background-color: white;
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            max-width: 1200px;
            width: 95%;
            min-height: 600px;
        }

        .image-section {
            background-image: url("https://placehold.co/500x700/D4A06F/4C84F4?text=Emarald+Auctions");
            background-size: cover;
            background-position: center;
        }

        @media (max-width: 768px) {
            .main-card {
                height: auto;
            }

            .image-section {
                height: 200px;
                width: 100%;
            }

            .content-section {
                width: 100%;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">
<div class="main-card flex items-center justify-center">
    <div class="content-section flex-2 p-8 md:p-12 flex flex-col">
        <h2 class="text-3xl font-semibold text-gray-900 mb-6 text-center">
            Auction Details
        </h2>
        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-500 text-white p-3 rounded-md mb-4 text-sm">
            <%= request.getAttribute("error") %>
        </div>
        <% } %> <% if (request.getAttribute("success") != null) { %>
        <div class="bg-green-500 text-white p-3 rounded-md mb-4 text-sm">
            <%= request.getAttribute("success") %>
        </div>
        <% } %>
        <div
                id="notifications"
                class="bg-blue-100 text-blue-800 p-3 rounded-md mb-4 text-sm hidden"
                role="alert"
        ></div>

        <div class="flex flex-col md:flex-row gap-6 mb-8 flex-grow">
            <div
                    class="border border-gray-200 rounded-lg p-6 shadow-md bg-white flex-1"
            >
                <img
                        src="${auction.imageUrl}"
                        alt="${auction.name}"
                        onerror="this.onerror=null;this.src='https://placehold.co/600x300/cccccc/333333?text=No+Image';"
                        class="w-full h-64 object-cover rounded-md mb-4"
                />
                <h3 class="text-2xl font-semibold text-gray-900 mb-2">
                    ${auction.name}
                </h3>
                <p class="text-gray-600 text-base mb-4">${auction.description}</p>
                <div class="text-gray-800 text-base mb-6">
                    <p><strong>Starting Price:</strong> ${auction.startingPrice}</p>
                    <p>
                        <strong>Current Bid:</strong>
                        <span id="currentBid-${auction.id}"
                        >${auction.currentHighestBid}</span
                        >
                    </p>
                    <br/><br/>
                </div>
                <form action="add-bid" method="post" class="space-y-4">
                    <div>
                        <label
                                for="amount"
                                class="block text-gray-700 text-sm font-medium mb-1"
                        >Your Bid Amount</label
                        >
                        <input type="number" step="0.01" name="amount" id="amount"
                               placeholder="Enter your bid"
                               class="w-full px-4 py-2 rounded-md border border-gray-300
              focus:outline-none focus:ring-2 focus:ring-blue-500
              transition duration-200 ease-in-out"
                               required
                               min="<c:out value='${auction.currentHighestBid + 0.01}' />"/>
                    </div>
                    <input type="hidden" name="auction" value="${auction.id}"/>

                    <button
                            type="submit"
                            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2.5 rounded-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-white"
                    >
                        Place Bid
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
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
            const currentAuctionId = document.querySelector('input[name="auction"]')?.value;

            if (bidElement) {
                bidElement.textContent = data.bidAmount;
                if (!currentAuctionId || parseInt(currentAuctionId) === auctionId) { // Convert to number
                    notification.textContent = `New bid of $${data.bidAmount} placed on auction ${auctionId} by ${data.bidderName}`;
                    notification.classList.remove("hidden");
                    setTimeout(() => {
                        notification.textContent = "";
                        notification.classList.add("hidden");
                    }, 3000);
                }
            }
        } else if (data.type === "auction") {
            notification.textContent = `New auction "${data.title}" created by ${data.ownerName} (ID: ${data.auctionId})`;
            notification.classList.remove("hidden");
            setTimeout(() => {
                notification.textContent = "";
                notification.classList.add("hidden");
            }, 3000);
        }
    };
</script>
</body>
</html>
