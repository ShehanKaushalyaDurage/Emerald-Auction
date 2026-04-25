package com.emaraldauction.ee.web.socket;

import com.emaraldauction.ee.ejb.bean.WebSocketBroadcaster;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.spi.CDI;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ApplicationScoped
@ServerEndpoint("/ws/bids")
public class WebSocket {
    private WebSocketBroadcaster broadcaster;

    @OnOpen
    public void onOpen(Session session) {
        broadcaster = CDI.current().select(WebSocketBroadcaster.class).get();
        broadcaster.addSession(session);
        System.out.println("WebSocket opened: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        if (broadcaster != null) {
            broadcaster.removeSession(session);
        }
        System.out.println("WebSocket closed: " + session.getId());
    }
}