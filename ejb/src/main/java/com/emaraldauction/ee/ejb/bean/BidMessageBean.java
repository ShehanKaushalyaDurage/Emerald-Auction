package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Bid;
import jakarta.ejb.MessageDriven;
import jakarta.inject.Inject;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.ObjectMessage;

@MessageDriven(mappedName = "jms/BidQueue")
public class BidMessageBean implements MessageListener {

    @Inject
    private WebSocketBroadcaster broadcaster;


    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof ObjectMessage) {
                ObjectMessage objMessage = (ObjectMessage) message;
                Bid bid = (Bid) objMessage.getObject();
                Auction auction = bid.getAuction();
                broadcaster.broadcastBidUpdate(auction.getId(), bid.getAmount().toString(), bid.getBidder().getname());
            }
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
}