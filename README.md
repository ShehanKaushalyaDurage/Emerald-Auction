# 💎 Emerald Auction – Distributed Real-Time Auction System

## 📌 Overview

Emerald Auction is a distributed, real-time auction platform engineered using Jakarta EE (J2EE) to simulate enterprise-grade backend systems.

This project highlights my ability to design and implement:

- Event-driven architectures
- Concurrency-safe systems
- Real-time communication pipelines
- Enterprise Java components (EJB, JMS, WebSockets)

Unlike traditional CRUD applications, this system intentionally avoids database usage and focuses on core backend engineering challenges such as synchronization, fairness, and real-time consistency.

---

## 🎯 Why This Project Stands Out (For Recruiters)

✔ Designed a real-time distributed system without relying on a database  
✔ Implemented JMS-based publish/subscribe architecture  
✔ Built a concurrency-safe bidding engine handling simultaneous users  
✔ Developed auto-bidding logic with fairness guarantees  
✔ Delivered live updates using WebSockets (low-latency UI sync)  

👉 This project demonstrates strong understanding of:

- Backend system design
- Multi-threading & race condition handling
- Event-driven communication
- Enterprise Java ecosystem

---

## 🧱 Architecture Overview

```
Client (JSP + JS)
        │
        ▼
WebSocket Layer (Real-time updates)
        │
        ▼
EJB Business Layer (Core logic)
        │
        ▼
JMS Topics (Event broadcasting)
        │
        ▼
In-Memory Data Store (Concurrent Collections)
```

---

## ⚙️ Tech Stack

### 🔹 Backend
- Java 11
- Jakarta EE (J2EE)
- EJB (Session Beans)
- JMS (Topic-based messaging)
- Servlets

### 🔹 Real-Time
- WebSocket API (Payara Server)

### 🔹 Frontend
- JSP, HTML, CSS, JavaScript

### 🔹 Data Handling
- Gson (JSON processing)

### 🔹 Storage
- In-memory collections (ConcurrentHashMap, Lists)
- No external database

---

## 🚀 Key Features

### 💰 Real-Time Bidding Engine
- Handles simultaneous bids safely
- Guarantees atomic updates and consistency
- Prevents race conditions using thread-safe logic

### 🤖 Auto-Bidding System
- Users define a maximum bid limit
- System automatically competes in auctions
- Mimics real-world platforms like eBay

### ⚖️ Fairness & Prioritization
- Manual bids are prioritized over automated bids
- Queue-based resolution ensures deterministic outcomes

### 📡 Live Updates
- JMS Topics broadcast bid events
- WebSockets push updates instantly to all clients

### 👤 User & Product Management
- Managed via EJB Session Beans
- Lightweight in-memory storage for fast access

---

## 🔄 How the System Works

1. User places a bid
2. EJB validates and processes the request
3. Concurrency-safe logic resolves conflicts
4. JMS Topic broadcasts the event
5. WebSocket pushes real-time updates to all users

---

## 🧠 Engineering Highlights

✔ Implemented thread-safe bidding logic using concurrent collections  
✔ Designed loosely coupled architecture with JMS  
✔ Built real-time event streaming pipeline  
✔ Eliminated DB dependency to focus on system performance & design  
✔ Ensured fair bid resolution under concurrent load  

---

## 📦 Project Structure

```
emerald-auction/
│
├── ejb/            # Business logic (Session Beans)
├── messaging/      # JMS publishers/subscribers
├── websocket/      # WebSocket endpoints
├── servlet/        # HTTP request handling
├── model/          # Core entities (User, Product, Bid)
├── util/           # Utilities
│
├── web/
│   ├── jsp/        # UI layer
│   ├── css/
│   └── js/
│
└── README.md
```

---

## 🛠️ Setup & Run

### Prerequisites
- Java 11+
- Payara Server

### Run Steps

```bash
git clone https://github.com/your-username/emerald-auction.git
```

Deploy `.war` file to Payara Server and open:

```
http://localhost:8080/emerald-auction
```

---

## ⚠️ Limitations

- No persistent storage (resets on restart)
- Not intended for production financial use
- Focused on architecture and system behavior

---

## 🔮 Future Improvements

- Add database (PostgreSQL)
- Introduce authentication (JWT)
- Convert into microservices architecture
- Add auction timers & scheduling

---

## 📚 What This Project Demonstrates

- Enterprise Java (EJB, JMS, Servlets)
- Event-driven system design
- Real-time applications using WebSockets
- Concurrency handling & synchronization
- Backend architecture thinking
