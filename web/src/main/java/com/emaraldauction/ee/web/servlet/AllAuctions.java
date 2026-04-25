package com.emaraldauction.ee.web.servlet;

import com.emaraldauction.ee.ejb.remote.AuctionManager;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/")
public class AllAuctions extends HttpServlet {

    @EJB
    private AuctionManager auctionManager;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                request.setAttribute("error", "You must be logged in to view auctions.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            request.setAttribute("auctions", auctionManager.getAuctions());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading auctions.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

}
