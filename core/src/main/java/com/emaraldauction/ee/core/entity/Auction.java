package com.emaraldauction.ee.core.entity;

import java.io.Serializable;
import java.math.BigDecimal;

public class Auction implements Serializable {

    private Integer id;
    private String name;
    private String description;
    private Double startingPrice;
    private Double currentHighestBid;
    private Status status;
    private User owner;
    private User highestBidder;
    private String imageUrl;

    public Auction() {
        this.status = Status.PENDING;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getStartingPrice() {
        return startingPrice;
    }

    public void setStartingPrice(Double startingPrice) {
        this.startingPrice = startingPrice;
    }

    public Double getCurrentHighestBid() {
        return currentHighestBid;
    }

    public void setCurrentHighestBid(Double currentHighestBid) {
        this.currentHighestBid = currentHighestBid;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public User getOwner() {
        return owner;
    }

    public void setOwner(User owner) {
        this.owner = owner;
    }

    public User getHighestBidder() {
        return highestBidder;
    }

    public void setHighestBidder(User highestBidder) {
        this.highestBidder = highestBidder;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}