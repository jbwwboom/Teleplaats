pragma solidity ^0.4.23;

contract Teleplaats{
    mapping (uint => Phone) public phones;
    mapping (uint => Order) public orders;

    uint public phoneid;
    uint public orderid;

    struct Phone {
        string IMEI;
        string model;
        string brand;
        string state;
        address owner;
        string info;
    }

    struct Seller{
        string username;
        address sellerAddr;
    }

    struct Buyer{
        string username;
        address buyerAddr;
    }

    struct Bet{
        Buyer user;
        uint price;
        bool isBet;
    }

    struct Order{
        Phone phone;
        Seller user;
        bool isBet;
        uint price;
        bool isSold;
        Bet bet;
    }

    Seller public seller;

    Buyer public buyer;

    constructor(string sellerName) public {
        seller = Seller(sellerName, msg.sender);
    }

    function addPhone(string IMEI, string model, string brand, string state, string info) public{
        require(seller.sellerAddr == msg.sender);

        Phone memory phone = Phone(IMEI, model, brand,state, seller.sellerAddr, info);

        phoneid++;

        phones[phoneid] = phone;
    }

    function removePhone(uint id) public{
        delete phones[id];
    }

    function addOrder(uint id, uint price, bool isBet) public{
        require(seller.sellerAddr == msg.sender);

        Phone memory phone = phones[id];

        Bet memory placeholderBet;

        Order memory order = Order(phone, seller, isBet, price, false, placeholderBet);

        orderid++;

        orders[orderid] = order;
    }

    function buyOrder(string buyerName, uint id, uint price) public {
        require(seller.sellerAddr != msg.sender);

        if(orders[id].isBet && price > orders[id].bet.price){
            buyer = Buyer(buyerName, msg.sender);
            Bet memory bet = Bet(buyer, price, orders[id].isBet);
            orders[id].bet = bet;
        }

        if(price >= orders[id].price && !orders[id].isBet){
            changeOwner(id);
        }
    }

    function changeOwner(uint id) private{
        phones[id].owner = buyer.buyerAddr;
    }

    function acceptBet(uint id) public{
        require(seller.sellerAddr == msg.sender);

        if(orders[id].isBet && orders[id].bet.price > 0){
            changeOwner(id);
        }
    }
}