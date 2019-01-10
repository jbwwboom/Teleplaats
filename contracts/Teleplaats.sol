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
        string username;
        address ownerAddr;
    }

    struct User{
        string username;
        address userAddr;
    }

    struct Bet{
        //User user; User Variables under here
        string username;
        address userAddr;
        uint price;
        bool isBet;
    }

    struct Order{
        //Phone phone; Phone variables under here
        //User owner;
        string ownerUsername;
        address ownerAddr;
        bool isBet;
        uint price;
        bool isSold;
        //Bet bet; Bet Variables under here
        string betUsername;
        address betAddr;
        uint betPrice;
    }

    function sellPhone(string sellerName, string IMEI, string model, string brand, string state, uint price, bool isBet) public{
        addPhone(sellerName, IMEI, model, brand, state);
        addOrder(phoneid, price, isBet);
    }

    function addPhone(string sellerName, string IMEI, string model, string brand, string state) private{
        Phone memory phone = Phone(IMEI, model, brand, state, sellerName, msg.sender);

        phoneid++;

        phones[phoneid] = phone;
    }

    function removePhone(uint id) public{
        require(phones[id].ownerAddr == msg.sender);
        delete phones[id];
    }

    function addOrder(uint id, uint price, bool isBet) private {
        require(phones[id].ownerAddr == msg.sender);

        Phone memory phone = phones[id];

        //Bet memory placeholderBet;

        //User memory user = User(phone.username, phone.ownerAddr);

        Order memory order = Order(phone.username, phone.ownerAddr, isBet, price, false, "", address(0), 0);

        orderid++;

        orders[orderid] = order;
    }

    function buyOrder(string buyerName, uint id, uint price) public {
        require(orders[id].ownerAddr != msg.sender);

        //User memory buyer = User(buyerName, msg.sender);
        //Bet memory bet = Bet(buyerName, msg.sender, price, orders[id].isBet);
        orders[id].betUsername = buyerName;
        orders[id].betAddr = msg.sender;
        orders[id].betPrice = price;


        if(price >= orders[id].price && !orders[id].isBet){
            changeOwner(id);
        }
    }

    function changeOwner(uint id) private{
        phones[id].username = orders[id].betUsername;
        phones[id].ownerAddr = orders[id].betAddr;
        orders[id].isSold = true;
    }

    function acceptBet(uint id) public{
        require(orders[id].ownerAddr == msg.sender);

        if(orders[id].isBet && orders[id].betPrice > 0){
            changeOwner(id);
        }
    }
}