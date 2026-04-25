package com.emaraldauction.ee.ejb.remote;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Bid;
import com.emaraldauction.ee.core.entity.User;
import jakarta.ejb.Remote;

import java.math.BigDecimal;

@Remote
public interface BidManager {

    Bid getHighestBid(Auction auction);
    Bid createBid(Auction auction, User bidder, Double amount );

}
