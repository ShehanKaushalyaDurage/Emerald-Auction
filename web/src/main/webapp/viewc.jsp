<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Auction Details - WhimsiWord</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Auction Details</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %>
    </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %>
    </div>
    <% } %>
    <div id="notifications" class="mb-4"></div>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <div class="col">
            <div class="card h-100">
                <div class="card-body">
                    <img src="${auction.imageUrl}" alt="${auction.name}" class="w-full h-48 object-cover rounded-md mb-3"/>
                    <h5 class="card-title">${auction.name}</h5>
                    <p class="card-text">${auction.description}</p>
                    <p><strong>Starting Price:</strong> ${auction.startingPrice}</p>
                    <p><strong>Current Bid:</strong> <span
                            id="currentBid-${auction.id}">${auction.currentHighestBid}</span></p>
                    <br/><br/>
                    <form action="add-bid" method="get">
                        <div class="mb-3">
                            <label for="amount" class="form-label">Bid Amount</label>
                            <input type="number" step="0.01" name="amount" id="amount" class="form-control" required/>
                        </div>
                        <input type="hidden" name="auction" value="${auction.id}"/>
                        <button type="submit" class="btn btn-primary">Place Bid</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
    console.log('Attempting to connect to:', 'ws://' + window.location.host + '/ee-app/ws/bids');
    console.log('Current location:', window.location);

    const ws = new WebSocket('ws://' + window.location.host + '/ee-app/ws/bids');
    ws.onopen = function () {
        console.log('WebSocket connected');
    };

    ws.onclose = function () {
        console.log('WebSocket disconnected');
    };

    ws.onerror = function (error) {
        console.error('WebSocket error:', error);
    };

    ws.onmessage = function (event) {
        console.log('WebSocket onmessage');
        const data = JSON.parse(event.data);
        const notification = document.getElementById('notifications');

        if (data.type === 'bid') {
            const auctionId = data.auctionId;
            const bidElement = document.getElementById('currentBid-' + auctionId);
            const currentAuctionId = document.querySelector('input[name="auction"]')?.value;

            if (bidElement) {
                bidElement.textContent = data.bidAmount;
                if (!currentAuctionId || currentAuctionId == auctionId) {
                    notification.textContent = `New bid of $${data.bidAmount} placed on auction ${auctionId} by ${data.bidderName}`;
                    setTimeout(() => notification.textContent = '', 3000);
                }
            }
        } else if (data.type === 'auction') {
            notification.textContent = `New auction "${data.title}" created by ${data.ownerName} (ID: ${data.auctionId})`;
            setTimeout(() => notification.textContent = '', 3000);
        }
    };
</script>

</body>
</html>