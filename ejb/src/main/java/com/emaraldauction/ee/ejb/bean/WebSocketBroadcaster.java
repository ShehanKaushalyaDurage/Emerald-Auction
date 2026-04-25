package com.emaraldauction.ee.ejb.bean;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.websocket.Session;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ApplicationScoped
public class WebSocketBroadcaster {

    private final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

    public void addSession(Session session) {
        sessions.add(session);
    }

    public void removeSession(Session session) {
        sessions.remove(session);
    }


    public void broadcastBidUpdate(Integer auctionId, String bidAmount, String bidderName) {
        String message = String.format("{\"type\":\"bid\",\"auctionId\":%d,\"bidAmount\":\"%s\",\"bidderName\":\"%s\"}",
                auctionId, bidAmount, bidderName);
        broadcast(message);
    }

    public void broadcastAuctionUpdate(Integer auctionId, String title, String ownerName, String description, Double startingPrice, Double currentHighestBid, String imageUrl) {
        String message = String.format("{\"type\":\"auction\",\"auctionId\":%d,\"title\":\"%s\",\"ownerName\":\"%s\",\"description\":\"%s\",\"startingPrice\":%.2f,\"currentHighestBid\":%.2f,\"imageUrl\":\"%s\"}",
                auctionId, title, ownerName, description, startingPrice, currentHighestBid, imageUrl);
        broadcast(message);
    }

    private void broadcast(String message) {
        synchronized (sessions) {
            for (Session session : sessions) {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                    }
                } catch (IOException e) {
                    sessions.remove(session);
                }
            }
        }
    }
}