//SPDX-License-Identifier:MIT

pragma solidity ^0.5.0;

    /*
        The EventTickets contract keeps track of the details and ticket sales of one event.
     */

contract EventTickets {

    /*
        Create a public state variable called owner.
        
        
        Use the appropriate keyword to create an associated getter function.
        Use the appropriate keyword to allow ether transfers.
     */
     address public owner;
     

     function getTicket() public payable returns(address) {
         return owner;
     }


    uint   TICKET_PRICE = 100 wei;

    /*
        Create a struct called "Event".
        The struct has 6 fields: description, website (URL), totalTickets, sales, buyers, and isOpen.
        Choose the appropriate variable type for each field.
        The "buyers" field should keep track of addresses and how many tickets each buyer purchases.
    */
    struct Event {
        string  description;
        string  website;
        uint256 totalTickets;
        uint256 sales;
        mapping (address => uint) buyer;
        bool isOpen;
    }
   
    /*
        Define 3 logging events.
        LogBuyTickets should provide information about the purchaser and the number of tickets purchased.
        LogGetRefund should provide information about the refund requester and the number of tickets refunded.
        LogEndSale should provide infromation about the contract owner and the balance transferred to them.
    */

    event LogBuyTickets(address buyer, uint noOfTickets);
    event LogGetRefund(address refundReq, uint noOfTickets);
    event LogEndSale(address _owner, uint balance);

    /*
        Create a modifier that throws an error if the msg.sender is not the owner.
    */
    
    modifier isOwner(){
        require(owner == msg.sender,"Only owner is authorized");
        _;
    }

    /*
        Define a constructor.
        The constructor takes 3 arguments, the description, the URL and the number of tickets for sale.
        Set the owner to the creator of the contract.
        Set the appropriate myEvent details.
    */
    Event myEvent;
    constructor(string memory description, string memory website, uint totalTickets) public{
        owner = msg.sender;
        myEvent.description = description;
        myEvent.website = website;
        myEvent.totalTickets = totalTickets;


    }

    /*
        Define a function called readEvent() that returns the event details.
        This function does not modify state, add the appropriate keyword.
        The returned details should be called description, website, uint totalTickets, uint sales, bool isOpen in that order.
    */
    function readEvent() public view returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen)
    {
        return(myEvent.description, myEvent.website, myEvent.totalTickets, myEvent.sales, myEvent.isOpen);
    }

    /*
        Define a function called getBuyerTicketCount().
        This function takes 1 argument, an address and
        returns the number of tickets that address has purchased.
    */
    function getBuyerTicketCount(address _address) public view returns(uint totalTickets) {
        return(myEvent.buyer[_address]);
    }
    /*
        Define a function called buyTickets().
        This function allows someone to purchase tickets for the event.
        This function takes one argument, the number of tickets to be purchased.
        This function can accept Ether.
        Be sure to check:
            - That the event isOpen
            - That the transaction value is sufficient for the number of tickets purchased
            - That there are enough tickets in stock
        Then:
            - add the appropriate number of tickets to the purchasers count
            - account for the purchase in the remaining number of available tickets
            - refund any surplus value sent with the transaction
            - emit the appropriate event
    */
    function buyTickets(uint totalTickets) public payable  {
        require(myEvent.isOpen == true,"Event is not opened");
        require(msg.value >= (100 * totalTickets),"insufficient amount");
        require(myEvent.totalTickets >= totalTickets,"insufficient tickets");
        

        myEvent.buyer[msg.sender] += totalTickets;
        uint surplus = msg.value - (100 * totalTickets);
        msg.sender.transfer(surplus);
        myEvent.sales += totalTickets;
        myEvent.totalTickets -= totalTickets;
        emit LogBuyTickets(msg.sender, totalTickets);

    }
    /*
        Define a function called getRefund().
        This function allows someone to get a refund for tickets for the account they purchased from.
        TODO:
            - Check that the requester has purchased tickets.
            - Make sure the refunded tickets go back into the pool of avialable tickets.
            - Transfer the appropriate amount to the refund requester.
            - Emit the appropriate event.
    */
    function getRefund() public payable {
            require(myEvent.buyer[msg.sender] != 0,"No tickets purchased by this account.");
            uint noOfTickets = myEvent.buyer[msg.sender];
            myEvent.sales -= noOfTickets;
            myEvent.totalTickets += noOfTickets;
            msg.sender.transfer((noOfTickets) * 100);
            emit LogGetRefund(msg.sender, noOfTickets);
    }
    /*
        Define a function called endSale().
        This function will close the ticket sales.
        This function can only be called by the contract owner.
        TODO:
            - close the event
            - transfer the contract balance to the owner
            - emit the appropriate event
    */
    function endSale() public payable isOwner(){
        myEvent.isOpen = false;
        msg.sender.transfer(myEvent.sales * (100));
        emit LogEndSale(msg.sender, (myEvent.sales * 100));
    }
}
