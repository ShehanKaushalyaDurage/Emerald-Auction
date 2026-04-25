package com.emaraldauction.ee.web.servlet;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.ejb.remote.AuctionManager;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/view")
public class ViewAuction extends HttpServlet {

    @EJB
    private AuctionManager auctionManager;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String auctionIdStr = request.getParameter("this");
            Integer auctionId;
            try {
                auctionId = Integer.parseInt(auctionIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid auction ID.");
                request.getRequestDispatcher("/").forward(request, response);
                return;
            }

            Auction auction = auctionManager.findAuctionById(auctionId);
            if (auction == null) {
                request.setAttribute("error", "Auction not found.");
                request.getRequestDispatcher("/").forward(request, response);
                return;
            }

            request.setAttribute("auction", auction);
            request.getRequestDispatcher("/view.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the auction.");
            request.getRequestDispatcher("/all.jsp").forward(request, response);
        }
    }

}
