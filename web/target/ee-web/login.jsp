<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #e0e0e0;
        }

        .login-card {
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
            background-image: url('https://images.unsplash.com/photo-1605143185597-9fe1a8065fbb?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'); /* Placeholder for the abstract image */
            background-size: cover;
            background-position: center;
        }

        @media (max-width: 768px) {
            .login-card {
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

<div class="login-card">

    <div class="image-section flex-1 hidden md:block">
    </div>


    <div class="form-section flex-1 p-8 md:p-12 flex flex-col justify-center">
        <h2 class="text-3xl font-semibold text-gray-900 mb-2">Welcome Back</h2>
        <p class="text-gray-600 mb-8 text-sm">Enter your email and password to access your account.</p>


        <c:if test="${not empty requestScope.message}">
            <div class="bg-red-500 text-white p-3 rounded-md mb-4 text-sm">
                <c:out value="${requestScope.message}"/>
            </div>
        </c:if>

        <form action="login" method="post" class="space-y-6">
            <div>
                <label for="email" class="block text-gray-700 text-sm font-medium mb-1">Email</label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email"
                        class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out"
                        required
                        value="jane@example.com"
                >
            </div>
            <div>
                <label for="password" class="block text-gray-700 text-sm font-medium mb-1">Password</label>
                <div class="relative">
                    <input
                            type="password"
                            id="password"
                            name="password"
                            value="password123"
                            placeholder="Enter your password"
                            class="w-full px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-200 ease-in-out pr-10"
                            required
                    >
                    <span class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400">
                        <i class="fas fa-eye-slash"></i>
                    </span>
                </div>
            </div>

            <button
                    type="submit"
                    class="w-full bg-gray-900 hover:bg-gray-800 text-white font-semibold py-2.5 rounded-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-2 focus:ring-offset-white"
            >
                Sign In
            </button>
        </form>


        <p class="mt-8 text-gray-500 text-xs text-center">© <%= new java.util.Date().getYear() + 1900 %> Emerald Auction.
            All rights reserved.</p>
    </div>
</div>

</body>
</html>
