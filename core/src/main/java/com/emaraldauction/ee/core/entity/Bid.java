package com.emaraldauction.ee.core.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Bid implements Serializable {

    private Integer id;
    private Double amount;
    private final LocalDateTime bidTime;
    private Auction auction;
    private User bidder;

    public Bid() {
        this.bidTime = LocalDateTime.now();
    }

    public Bid(Auction auction, User bidder, Double amount) {
        this();
        this.auction = auction;
        this.bidder = bidder;
        this.amount = amount;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public LocalDateTime getBidTime() {
        return bidTime;
    }

    public Auction getAuction() {
        return auction;
    }

    public void setAuction(Auction auction) {
        this.auction = auction;
    }

    public User getBidder() {
        return bidder;
    }

    public void setBidder(User bidder) {
        this.bidder = bidder;
    }
}
