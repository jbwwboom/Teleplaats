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
        User user;
        uint price;
        bool isBet;
    }

    struct Order{
        Phone phone;
        User owner;
        bool isBet;
        uint price;
        bool isSold;
        Bet bet;
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

        Bet memory placeholderBet;

        User memory user = User(phone.username, phone.ownerAddr);

        Order memory order = Order(phone, user, isBet, price, false, placeholderBet);

        orderid++;

        orders[orderid] = order;
    }

    function buyOrder(string buyerName, uint id, uint price) public {
        require(orders[id].owner.userAddr != msg.sender);

        User memory buyer = User(buyerName, msg.sender);
        Bet memory bet = Bet(buyer, price, orders[id].isBet);
        orders[id].bet = bet;

        if(price >= orders[id].price && !orders[id].isBet){
            changeOwner(id);
        }
    }

    function changeOwner(uint id) private{
        User memory user = orders[id].bet.user;
        phones[id].username = user.username;
        phones[id].ownerAddr = user.userAddr;
        orders[id].isSold = true;
    }

    function acceptBet(uint id) public{
        require(orders[id].owner.userAddr == msg.sender);

        if(orders[id].isBet && orders[id].bet.price > 0){
            changeOwner(id);
        }
    }
}