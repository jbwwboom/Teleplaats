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
        //string zipcode;
        //Phone[] phones;
    }

    struct Buyer{
        string username;
        address buyerAddr;
        //string zipcode;
        //Phone[] phones;
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
        uint highestBet;
    }

    address public owner;

    Seller public seller;

    Buyer public buyer;


    constructor(string sellerName) public {
        seller = Seller(sellerName, msg.sender);
        owner = msg.sender;
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

    function addOrder(uint id, uint price) public{
        require(seller.sellerAddr == msg.sender);

        Phone memory phone = phones[id];

        Bet memory placeholderBet;

        Order memory order = Order(phone, seller, false, price, false, placeholderBet, price);

        orderid++;

        orders[orderid] = order;
    }

    function buyOrder(string buyerName, uint id, uint price) public {
        require(seller.sellerAddr != msg.sender);
        buyer = Buyer(buyerName, msg.sender);

        Bet memory bet = Bet(buyer, price, false);

        orders[id].bet = bet;

        changeOwner(id);
    }

    function changeOwner(uint id) private{
        require(buyer.buyerAddr == msg.sender);

        owner = buyer.buyerAddr;

        phones[id].owner = buyer.buyerAddr;
    }

}