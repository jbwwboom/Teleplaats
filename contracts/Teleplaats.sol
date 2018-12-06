pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

contract Teleplaats {
    Phone[] public phones;
    User[] public users;
    Order[] public orders;

	struct Phone {
        string IMEI;
        string model;
        string brand;
        string state;
        string username;
        string info;
    }

    struct User{
        string username;
        address byteAddress;
        string privateKey;
        string publicKey;
        string userAddress;
        string zipcode;
        Phone[] phones;
    }

    struct Bet{
        User user;
        Order order;
        uint price;
        bool isBet;
    }

    struct Order{
        Phone phone;
        User user;
        bool isBet;
        uint price;
        bool isSold;
        Bet[] bets;
        uint highestBet;
    }

    function addPhone(Phone phone) public {
        phones.push(phone);
    }
}