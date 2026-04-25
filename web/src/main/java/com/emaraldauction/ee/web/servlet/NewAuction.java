package com.emaraldauction.ee.web.servlet;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.User;
import com.emaraldauction.ee.ejb.bean.AuctionJmsProducer;
import com.emaraldauction.ee.ejb.remote.AuctionManager;
import jakarta.ejb.EJB;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/new-auction")
public class NewAuction extends HttpServlet {

    @EJB
    private AuctionManager auctionManager;

    @Inject
    private AuctionJmsProducer auctionJmsProducer;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "You must be logged in to create an auction.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                request.setAttribute("error", "You must be logged in to create an auction.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            User owner = (User) session.getAttribute("user");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String startingPriceStr = request.getParameter("startingPrice");
            String imageUrl = request.getParameter("imageUrl");

            if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty() || startingPriceStr == null || startingPriceStr.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
                return;
            }

            double startingPrice;
            try {
                startingPrice = Double.parseDouble(startingPriceStr);
                if (startingPrice <= 0) {
                    request.setAttribute("error", "Starting price must be positive.");
                    request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid starting price format.");
                request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
                return;
            }

            Auction auction = auctionManager.createAuction(title, description, startingPrice, imageUrl, owner);
            if (auction == null) {
                request.setAttribute("error", "Failed to create auction. Please try again.");
                request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
                return;
            }

            auctionJmsProducer.sendAuctionMessage(auction);
            request.setAttribute("success", "Auction created successfully!");
            request.getRequestDispatcher("/new-auction.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the auction.");
            request.getRequestDispatcher("/new-auction.jsp").forward(request, response);
        }
    }
}