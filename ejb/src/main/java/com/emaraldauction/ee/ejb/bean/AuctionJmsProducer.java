package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.entity.Auction;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;

@Stateless
public class AuctionJmsProducer {

    @Resource(lookup = "jms/BidConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/AuctionQueue")
    private Queue auctionQueue;

    public void sendAuctionMessage(Auction auction) {
        try (JMSContext context = connectionFactory.createContext()) {
            context.createProducer().send(auctionQueue, auction);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}