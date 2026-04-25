<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Auction - Emarald Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #e0e0e0;
        }
        .auction-card {
            display: flex;
            background-color: white;
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            max-width: 1000px;
            width: 90%;
            height: auto;
            min-height: 500px;
        }
        .image-section {
            background-image: url('https://placehold.co/500x500/A06FD4/F4C84C?text=Auction+Item');
            background-size: cover;
            background-position: center;
        }
        @media (max-width: 768px) {
            .auction-card {
                flex-direction: column;
                height: auto;
            }
            .image-section {
                height: 200px;
                width: 100%;
            }
            .form-section {
                width: 100%;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">

<div class="auction-card">


    <div class="form-section flex-1 p-8 md:p-12 flex flex-col justify-center">
        <h2 class="text-3xl font-semibold text-gray-900 mb-6 text-center">Create New Auction</h2>
        <p class="text-gray-600 mb-8 text-sm text-center">Fill in the details to list your item for auction.</p>


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

        <form action="new-auction" method="post" class="space-y-6">
            <div>
                <label for="title" class="block text-gray-700 text-sm font-medium mb-1">Auction Title</label>
                <input
                        type="text"
                        id="title"
                        name="title"
                        placeholder="e.g., Vintage Diamond Necklace"
                        class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                        required
                >
            </div>
            <div>
                <label for="description" class="block text-gray-700 text-sm font-medium mb-1">Description</label>
                <textarea
                        id="description"
                        name="description"
                        placeholder="Provide a detailed description of your item..."
                        rows="4"
                        class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                        required
                ></textarea>
            </div>
            <div>
                <label for="startingPrice" class="block text-gray-700 text-sm font-medium mb-1">Starting Price</label>
                <input
                        type="number"
                        step="0.01"
                        id="startingPrice"
                        name="startingPrice"
                        placeholder="e.g., 100.00"
                        class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                        required
                >
            </div>
            <div>
                <label for="imageUrl" class="block text-gray-700 text-sm font-medium mb-1">Image URL</label>
                <input
                        type="url"
                        id="imageUrl"
                        name="imageUrl"
                        placeholder="https://example.com/item_image.jpg"
                        class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                        required
                >
            </div>
            <button
                    type="submit"
                    class="w-full bg-gray-900 hover:bg-gray-800 text-white font-semibold py-2.5 rounded-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-2 focus:ring-offset-white"
            >
                Create Auction
            </button>
        </form>

        <div class="mt-8 text-center text-gray-600 text-sm">
            <a href="/ee-app/" class="text-blue-600 hover:underline font-medium">Back to Auctions</a>
        </div>

        <p class="mt-8 text-gray-500 text-xs text-center">© <%= new java.util.Date().getYear() + 1900 %> Your Company. All rights reserved.</p>
    </div>
</div>

</body>
</html>
