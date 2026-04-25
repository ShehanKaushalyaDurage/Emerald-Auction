package com.emaraldauction.ee.web.servlet;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Bid;
import com.emaraldauction.ee.core.entity.User;
import com.emaraldauction.ee.ejb.remote.AuctionManager;
import com.emaraldauction.ee.ejb.remote.BidManager;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/add-bid")
public class BidServlet extends HttpServlet {

    @EJB
    private BidManager bidManager;

    @EJB
    private AuctionManager auctionManager;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                request.setAttribute("error", "You must be logged in to place a bidServlet.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            User bidder = (User) session.getAttribute("user");

            String auctionIdStr = request.getParameter("auction");
            Integer auctionId;
            try {
                auctionId = Integer.parseInt(auctionIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid auction ID.");
                request.getRequestDispatcher("/view").forward(request, response);
                return;
            }

            Auction auction = auctionManager.findAuctionById(auctionId);
            if (auction == null) {
                request.setAttribute("error", "Auction not found.");
                request.getRequestDispatcher("/view.jsp").forward(request, response);
                return;
            }

            String amountStr = request.getParameter("amount");
            double amount;
            try {
                amount = Double.parseDouble(amountStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid bidServlet amount.");
                request.getRequestDispatcher("/view.jsp").forward(request, response);
                return;
            }

            Bid bid = bidManager.createBid(auction, bidder, amount);
            System.out.println("\n=== BID Servlet CREATE BID START === "+bid.getAmount());
            if (bid == null) {
                request.setAttribute("error", "BidServlet could not be placed. Ensure the amount is higher than the current bidServlet plus the minimum increment.");
            } else {
                request.setAttribute("success", "BidServlet placed successfully. Awaiting processing...");
            }

            request.setAttribute("auction", auction);
            request.setAttribute("bid", bidManager.getHighestBid(auction));
            request.getRequestDispatcher("/view.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while placing the bid.");
        }
    }

}
