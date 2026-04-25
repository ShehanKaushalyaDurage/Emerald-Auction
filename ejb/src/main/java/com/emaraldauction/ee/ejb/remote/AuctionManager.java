package com.emaraldauction.ee.ejb.remote;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.User;
import jakarta.ejb.Remote;

import java.math.BigDecimal;
import java.util.List;

@Remote
public interface AuctionManager {

    Auction findAuctionById(Integer auctionId);

    List<Auction> getAuctions();

    Auction createAuction(String title, String description, Double startingPrice, String imageUrl, User owner);

}
