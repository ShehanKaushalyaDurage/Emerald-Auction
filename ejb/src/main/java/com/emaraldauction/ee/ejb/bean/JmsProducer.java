package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.entity.Bid;
import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;

@Stateless
public class JmsProducer {

    @Resource(lookup = "jms/BidConnectionFactory")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/BidQueue")
    private Queue bidQueue;

    public void sendBidMessage(Bid bid) {
        try (JMSContext context = connectionFactory.createContext()) {
            context.createProducer().send(bidQueue, bid);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}