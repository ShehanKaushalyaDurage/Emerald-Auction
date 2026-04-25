<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Details - Emarald Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #e0e0e0; /* Light gray background to match theme */
        }
        .main-card {
            display: flex;
            background-color: white;
            border-radius: 1rem; /* rounded-2xl */
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); /* shadow-2xl */
            overflow: hidden; /* Ensures rounded corners apply to children */
            max-width: 1200px; /* Wider for better content display */
            width: 95%; /* Responsive width */
            min-height: 600px; /* Minimum height to maintain structure */
        }
        .image-section {
            /* Placeholder for the main illustration/branding */
            background-image: url('https://placehold.co/500x700/D4A06F/4C84F4?text=Emarald+Auctions');
            background-size: cover;
            background-position: center;
        }
        @media (max-width: 768px) {
            .main-card {
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

<div class="main-card flex items-center justify-center">

    <!-- Right Section (Auction Details Content) -->
    <div class="content-section flex-2 p-8 md:p-12 flex flex-col">
        <h2 class="text-3xl font-semibold text-gray-900 mb-6 text-center">Auction Details</h2>

        <!-- JSP for error/success messages -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-500 text-white p-3 rounded-md mb-4 text-sm">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
        <div class="bg-green-500 text-white p-3 rounded-md mb-4 text-sm">
            <%= request.getAttribute("success") %>
        </div>
        <% } %>
        <!-- Notification area for WebSocket updates -->
        <div id="notifications" class="bg-blue-100 text-blue-800 p-3 rounded-md mb-4 text-sm hidden" role="alert"></div>

        <div class="flex flex-col md:flex-row gap-6 mb-8 flex-grow">
            <!-- Auction Item Card -->
            <div class="border border-gray-200 rounded-lg p-6 shadow-md bg-white flex-1">
                <img src="${auction.imageUrl}" alt="${auction.name}" onerror="this.onerror=null;this.src='https://placehold.co/600x300/cccccc/333333?text=No+Image';" class="w-full h-64 object-cover rounded-md mb-4"/>
                <h3 class="text-2xl font-semibold text-gray-900 mb-2">${auction.name}</h3>
                <p class="text-gray-600 text-base mb-4">${auction.description}</p>
                <div class="text-gray-800 text-base mb-6">
                    <p class="mb-2"><strong>Starting Price:</strong> $<c:out value="${auction.startingPrice}"/></p>
                    <%--                    <p class="text-lg"><strong>Current Bid:</strong> <span id="currentBid-${auction.id}" class="font-bold text-green-700">$<c:out value="${auction.currentHighestBid}"/></span></p>--%>
                    <p class="text-lg"><strong>Current Bid:</strong> <span
                            id="currentBid-${auction.id}">${auction.currentHighestBid}</span></p>
                    <br/><br/>
                </div>

                <!-- Bid Form -->
                <form action="add-bid" method="post" class="space-y-4">
                    <div>
                        <label for="amount" class="block text-gray-700 text-sm font-medium mb-1">Your Bid Amount</label>
                        <input
                                type="number"
                                step="0.01"
                                name="amount"
                                id="amount"
                                placeholder="Enter your bid"
                                class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                                required
                                min="<c:out value="${auction.currentHighestBid + 0.01}"/>" <%-- Ensure bid is higher than current --%>
                        />
                    </div>
                    <input type="hidden" name="auction" value="${auction.id}"/>
                    <% if (request.getAttribute("success") != null) { %>
                    <div class="bg-green-500 text-white p-3 rounded-md mb-4 text-sm">
                        <%= request.getAttribute("success") %>
                    </div>
                    <% } %>
                    <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2.5 rounded-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-white">
                        Place Bid
                    </button>
                </form>
            </div>
        </div>

        <div class="mt-auto text-center text-gray-600 text-sm">
            <a href="/ee-app/" class="text-blue-600 hover:underline font-medium">Back to All Auctions</a>
        </div>

        <!-- Example of a simple JSP expression to display current year -->
        <p class="mt-4 text-gray-500 text-xs text-center">© <%= new java.util.Date().getYear() + 1900 %> Your Company. All rights reserved.</p>
    </div>
</div>

<script>
    const notificationsDiv = document.getElementById('notifications');
    const auctionId = document.querySelector('input[name="auction"]')?.value; // Get the current auction ID from the hidden input

    console.log('Attempting to connect to:', 'ws://' + window.location.host + '/ee-app/ws/bids');
    console.log('Current location:', window.location);
    console.log('Current Auction ID:', auctionId);

    const ws = new WebSocket('ws://' + window.location.host + '/ee-app/ws/bids');

    ws.onopen = function () {
        console.log('WebSocket connected');
        notificationsDiv.textContent = 'Connected to real-time updates.';
        notificationsDiv.classList.remove('hidden');
        notificationsDiv.classList.remove('bg-blue-100', 'text-blue-800');
        notificationsDiv.classList.add('bg-green-100', 'text-green-800');
        setTimeout(() => notificationsDiv.classList.add('hidden'), 3000);
    };

    ws.onclose = function () {
        console.log('WebSocket disconnected');
        notificationsDiv.textContent = 'Disconnected from real-time updates. Please refresh.';
        notificationsDiv.classList.remove('hidden');
        notificationsDiv.classList.remove('bg-green-100', 'text-green-800');
        notificationsDiv.classList.add('bg-red-100', 'text-red-800');
    };

    ws.onerror = function (error) {
        console.error('WebSocket error:', error);
        notificationsDiv.textContent = 'WebSocket error occurred. Please refresh.';
        notificationsDiv.classList.remove('hidden');
        notificationsDiv.classList.remove('bg-green-100', 'text-green-800');
        notificationsDiv.classList.add('bg-red-100', 'text-red-800');
    };

    ws.onmessage = function (event) {
        console.log('WebSocket onmessage:', event.data);
        const data = JSON.parse(event.data);

        // Clear previous styles and ensure notification div is visible for new message
        notificationsDiv.classList.remove('hidden', 'bg-red-100', 'text-red-800', 'bg-green-100', 'text-green-800', 'bg-blue-100', 'text-blue-800');
        notificationsDiv.classList.add('bg-blue-100', 'text-blue-800'); // Default notification style

        if (data.type === 'bid') {
            const incomingAuctionId = data.auctionId;
            const bidElement = document.getElementById('currentBid-' + incomingAuctionId);

            // Only update if the bid is for the current auction being viewed
            if (bidElement && incomingAuctionId == auctionId) {
                bidElement.textContent = `$${data.bidAmount}`; // Ensure '$' prefix
                notificationsDiv.textContent = `New bid of $${data.bidAmount} placed by ${data.bidderName || 'Someone'}!`;
                setTimeout(() => notificationsDiv.classList.add('hidden'), 5000); // Hide after 5 seconds
            }
        } else if (data.type === 'auction') {
            // New auction created notification - might not be as critical on a details page
            // unless we want to redirect or show a list of new auctions.
            // For now, just show a notification if it's not the current auction.
            if (data.auctionId != auctionId) {
                notificationsDiv.textContent = `New auction "${data.name}" created by ${data.ownerName || 'Someone'}!`;
                setTimeout(() => notificationsDiv.classList.add('hidden'), 5000); // Hide after 5 seconds
            }
        } else {
            notificationsDiv.textContent = 'Received unknown WebSocket message.';
            setTimeout(() => notificationsDiv.classList.add('hidden'), 5000); // Hide after 5 seconds
        }
    };
</script>

</body>
</html>
