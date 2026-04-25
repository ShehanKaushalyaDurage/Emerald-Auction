package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.entity.Auction;
import jakarta.ejb.MessageDriven;
import jakarta.inject.Inject;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.ObjectMessage;

@MessageDriven(mappedName = "jms/AuctionQueue")
public class AuctionMessageBean implements MessageListener {

    @Inject
    private WebSocketBroadcaster broadcaster;


    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof ObjectMessage) {
                ObjectMessage objMessage = (ObjectMessage) message;
                Auction auction = (Auction) objMessage.getObject();
                broadcaster.broadcastAuctionUpdate(
                        auction.getId(),
                        auction.getName(),
                        auction.getOwner().getname(),
                        auction.getDescription(),
                        auction.getStartingPrice(),
                        auction.getCurrentHighestBid(),
                        auction.getImageUrl()
                );
            }
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }

}