package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.database.Database;
import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Status;
import com.emaraldauction.ee.core.entity.User;
import com.emaraldauction.ee.ejb.remote.AuctionManager;
import jakarta.ejb.Stateless;

import java.math.BigDecimal;
import java.util.List;

@Stateless
public class AuctionManagerBean implements AuctionManager {

    @Override
    public Auction findAuctionById(Integer auctionId) {
        if (auctionId == null) {
            return null;
        }
        return Database.AUCTIONS_LIST.stream().filter(auction -> auctionId.equals(auction.getId())).findFirst().orElse(null);
    }

    @Override
    public List<Auction> getAuctions() {
        return Database.AUCTIONS_LIST;
    }

    @Override
    public Auction createAuction(String title, String description, Double startingPrice, String imageUrl, User owner) {
        if (title == null || description == null || startingPrice == null || imageUrl == null || owner == null) {
            return null;
        }

        Auction auction = new Auction();
        auction.setId(Database.AUCTIONS_LIST.size() + 1);
        auction.setName(title);
        auction.setDescription(description);
        auction.setStartingPrice(startingPrice);
        auction.setCurrentHighestBid(startingPrice);
        auction.setStatus(Status.ACTIVE);
        auction.setOwner(owner);
        auction.setImageUrl(imageUrl);

        Database.AUCTIONS_LIST.add(auction);
        return auction;
    }
}