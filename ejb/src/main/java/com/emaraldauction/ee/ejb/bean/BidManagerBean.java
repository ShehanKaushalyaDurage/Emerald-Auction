package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.database.Database;
import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Bid;
import com.emaraldauction.ee.core.entity.User;
import com.emaraldauction.ee.ejb.remote.BidManager;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Comparator;

@Stateless
public class BidManagerBean implements BidManager {

    @Inject
    private JmsProducer jmsProducer;

    @Override
    public Bid getHighestBid(Auction auction) {
        System.out.println("=== GET HIGHEST BID START ===");

        if (auction == null) {
            System.out.println("ERROR: Auction is null in getHighestBid()");
            System.out.println("=== GET HIGHEST BID END (NULL AUCTION) ===");
            return null;
        }

        if (auction.getId() == null) {
            System.out.println("ERROR: Auction ID is null");
            System.out.println("Auction object: " + auction);
            System.out.println("=== GET HIGHEST BID END (NULL AUCTION ID) ===");
            return null;
        }

        System.out.println("Searching for highest bid in auction ID: " + auction.getId());
        System.out.println("Total bids in database: " + Database.BIDS_LIST.size());

        Bid highestBid = Database.BIDS_LIST.stream().filter(bid -> auction.getId().equals(bid.getAuction().getId())).max(Comparator.comparing(Bid::getAmount)).orElse(null);

        if (highestBid != null) {
            System.out.println("SUCCESS: Found highest bid: $" + highestBid.getAmount() + " for auction: " + auction.getId());
        } else {
            System.out.println("INFO: No bids found for auction: " + auction.getId());
        }

        System.out.println("=== GET HIGHEST BID END ===");
        return highestBid;
    }

    @Override
    public Bid createBid(Auction auction, User bidder, Double amount) {


        if (auction == null) {
            return null;
        }

        if (bidder == null) {
            return null;
        }

        if (amount == null) {
            return null;
        }

        if (bidder.getId().equals(auction.getOwner().getId())) {
            return null;
        }

        Double currentHighest = auction.getCurrentHighestBid();
        Double startingPrice = auction.getStartingPrice();

        try {
            Bid bid = new Bid(auction, bidder, amount);
            bid.setId(Database.BIDS_LIST.size() + 1);
//            bid.setBidTime(LocalDateTime.now());
            Database.BIDS_LIST.add(bid);
            auction.setCurrentHighestBid(amount);
            auction.setHighestBidder(bidder);
            jmsProducer.sendBidMessage(bid);
            return bid;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}