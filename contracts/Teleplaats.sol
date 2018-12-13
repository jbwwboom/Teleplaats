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

    address public seller;

    address public buyer;

    address public owner;

    Seller public sellerS;

    Buyer public buyerS;


    constructor(string sellerName) public {
        seller = msg.sender;
        sellerS = Seller(sellerName, seller);
        owner = msg.sender;
    }

    function addPhone(string IMEI, string model, string brand, string state, string info) public{
        require(seller == msg.sender);

        Phone memory phone = Phone(IMEI, model, brand,state, seller, info);

        phoneid++;

        phones[phoneid] = phone;
    }

    function removePhone(uint id) public{
        delete phones[id];
    }

    function addOrder(uint id, uint price) public{
        require(seller == msg.sender);

        Phone memory phone = phones[id];

        Bet memory placeholderBet;

        Order memory order = Order(phone, sellerS, false, price, false, placeholderBet, price);

        orderid++;

        orders[orderid] = order;
    }

    function buyOrder(string buyerName, uint id, uint price) public {
        require(seller != msg.sender);
        buyer = msg.sender;
        buyerS = Buyer(buyerName, buyer);

        Bet memory bet = Bet(buyerS, price, false);

        orders[id].bet = bet;
    }

    function changeOwner(uint id) public{
        require(buyer == msg.sender);

        phones[id].owner = buyer;
    }

}