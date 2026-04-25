package com.emaraldauction.ee.core.database;

import com.emaraldauction.ee.core.entity.Auction;
import com.emaraldauction.ee.core.entity.Bid;
import com.emaraldauction.ee.core.entity.Status;
import com.emaraldauction.ee.core.entity.User;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Database {

    public static final List<User> USERS_LIST = new ArrayList<>();
    public static final List<Auction> AUCTIONS_LIST = new ArrayList<>();
    public static final List<Bid> BIDS_LIST = new ArrayList<>();

    static {
        initializeData();
    }

    private static void initializeData() {
        initializeUsers();
        initializeAuctions();
        initializeBids();
    }

    private static void initializeUsers() {
        User user1 = new User("Shehan", "shehan@email.com", "shehan123");
        user1.setId(1);
        User user2 = new User("Kalindu", "kalidu@email.com", "kalidu123");
        user2.setId(2);
        User user3 = new User("Pasindu", "pasindu@email.com", "pasindu123");
        user3.setId(3);

        USERS_LIST.addAll(List.of(user1, user2, user3));
    }

    private static void initializeAuctions() {
        User[] users = USERS_LIST.toArray(new User[0]);

        AUCTIONS_LIST.addAll(List.of(
                createAuction(1, "Antique Pocket Watch", "19th-century gold-plated pocket watch in working condition", 150.00, users[0], users[1], "https://th.bing.com/th/id/OIP.U1weW37BW3aRVePJDR3egwHaLN?r=0&rs=1&pid=ImgDetMain"),
                createAuction(2, "Victorian Cameo Brooch", "Hand-carved shell cameo brooch from the 1860s", 120.00, users[1], users[2], "https://th.bing.com/th/id/OIP.cI3tnew0vcf07uaNNCflRQHaFs?r=0&rs=1&pid=ImgDetMain"),
                createAuction(3, "Art Nouveau Vase", "Early 20th-century glass vase with floral motifs", 200.00, users[2], users[0], "https://th.bing.com/th/id/OIP.0ZyhAsacvM52pDYAVY8K2gHaHa?r=0&rs=1&pid=ImgDetMain"),
                createAuction(4, "Regency Writing Desk", "Mahogany writing desk from the 1810s with inlaid details", 350.00, users[0], users[2], "https://th.bing.com/th/id/OIP.xdpqOsllGwOV1RNrfRbIzgHaGd?r=0&rs=1&pid=ImgDetMain")
        ));
    }

    private static void initializeBids() {
        Auction[] auctions = AUCTIONS_LIST.toArray(new Auction[0]);
        User[] users = USERS_LIST.toArray(new User[0]);

        BIDS_LIST.addAll(List.of(
                createBid(1, auctions[0], users[1], 160.00, LocalDateTime.now().minusHours(1)),
                createBid(2, auctions[0], users[2], 170.00, LocalDateTime.now().minusMinutes(30)),

                createBid(3, auctions[1], users[2], 130.00, LocalDateTime.now().minusHours(1)),
                createBid(4, auctions[1], users[0], 140.00, LocalDateTime.now().minusMinutes(45)),

                createBid(5, auctions[2], users[0], 220.00, LocalDateTime.now().minusHours(1)),
                createBid(6, auctions[2], users[1], 240.00, LocalDateTime.now().minusMinutes(20)),

                createBid(7, auctions[3], users[2], 375.00, LocalDateTime.now().minusHours(1)),
                createBid(8, auctions[3], users[1], 400.00, LocalDateTime.now().minusMinutes(15))
        ));

        for (Auction auction : AUCTIONS_LIST) {
            Bid highestBid = BIDS_LIST.stream()
                    .filter(bid -> auction.getId().equals(bid.getAuction().getId()))
                    .max(Comparator.comparing(Bid::getAmount))
                    .orElse(null);
            if (highestBid != null) {
                auction.setCurrentHighestBid(highestBid.getAmount());
                auction.setHighestBidder(highestBid.getBidder());
            }
        }
    }

    private static Auction createAuction(Integer id, String name, String description, Double startingPrice, User owner, User initialBidder, String imageUrl) {
        Auction auction = new Auction();
        auction.setId(id);
        auction.setName(name);
        auction.setDescription(description);
        auction.setStartingPrice(startingPrice);
        auction.setCurrentHighestBid(startingPrice);
        auction.setStatus(Status.ACTIVE);
        auction.setOwner(owner);
        auction.setHighestBidder(initialBidder);
        auction.setImageUrl(imageUrl);
        return auction;
    }

    private static Bid createBid(Integer id, Auction auction, User bidder, Double amount, LocalDateTime bidTime) {
        Bid bid = new Bid(auction, bidder, amount);
        bid.setId(id);
        return bid;
    }
}