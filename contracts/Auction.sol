// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

contract Auction {
    struct Bid {
        address bidder;
        uint amount;
    }

    address public owner;
    address public feeReceiver;
    uint public feePercent; // e.g. 2 means 2%

    uint public endTime;
    uint public highestBid;
    address public highestBidder;
    bool public auctionEnded;

    uint public constant timeExtension = 10 minutes;

    mapping(address => uint) public deposits;
    Bid[] public bids;

    // Messages
    string constant ERR_AUCTION_ENDED = "Auction has already ended.";
    string constant ERR_AUCTION_ACTIVE = "Auction is still active.";
    string constant ERR_NOT_OWNER = "Only the owner can perform this action.";
    string constant ERR_LOW_BID = "Bid must be at least 5% higher than current.";
    string constant ERR_WINNER_NO_REFUND = "Winner cannot request refund.";
    string constant ERR_NO_DEPOSIT = "No deposit to refund.";
    string constant ERR_INVALID_ADDRESS = "Invalid address.";
    string constant ERR_SAME_RECEIVER = "New receiver is the same as current.";
    string constant ERR_INVALID_FEE = "Fee must be between 0 and 100.";
    string constant ERR_SAME_FEE = "New fee percent is the same as current.";

    // Events
    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    event FeeReceiverUpdated(address indexed previousReceiver, address indexed newReceiver);
    event FeePercentUpdated(uint previousFeePercent, uint newFeePercent);

    modifier onlyWhileActive() {
        require(block.timestamp < endTime, ERR_AUCTION_ENDED);
        require(!auctionEnded, ERR_AUCTION_ENDED);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, ERR_NOT_OWNER);
        _;
    }

    constructor(uint _durationMinutes, address _feeReceiver, uint _feePercent) {
        require(_feeReceiver != address(0), ERR_INVALID_ADDRESS);
        require(_feePercent <= 100, ERR_INVALID_FEE);

        owner = msg.sender;
        feeReceiver = _feeReceiver;
        feePercent = _feePercent;
        endTime = block.timestamp + (_durationMinutes * 1 minutes);
    }

    function bid() external payable onlyWhileActive {
        require(
            msg.value >= (highestBid * 105) / 100 || highestBid == 0,
            ERR_LOW_BID
        );

        if (deposits[msg.sender] > 0) {
            uint refund = deposits[msg.sender];
            payable(msg.sender).transfer(refund);
            deposits[msg.sender] = 0;
        }

        deposits[msg.sender] += msg.value;
        highestBid = deposits[msg.sender];
        highestBidder = msg.sender;

        bids.push(Bid({
            bidder: msg.sender,
            amount: deposits[msg.sender]
        }));

        if (endTime - block.timestamp <= 10 minutes) {
            endTime += timeExtension;
        }

        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() external onlyOwner {
        require(block.timestamp >= endTime, ERR_AUCTION_ACTIVE);
        require(!auctionEnded, ERR_AUCTION_ENDED);

        auctionEnded = true;

        uint fee = (highestBid * feePercent) / 100;
        uint ownerAmount = highestBid - fee;

        payable(owner).transfer(ownerAmount);
        if (fee > 0) {
            payable(feeReceiver).transfer(fee);
        }

        emit AuctionEnded(highestBidder, highestBid);
    }

    function refundLosers() external {
        require(auctionEnded, ERR_AUCTION_ACTIVE);
        require(msg.sender != highestBidder, ERR_WINNER_NO_REFUND);

        uint amount = deposits[msg.sender];
        require(amount > 0, ERR_NO_DEPOSIT);

        deposits[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function getWinner() external view returns (address, uint) {
        return (highestBidder, highestBid);
    }

    function getAllBids() external view returns (Bid[] memory) {
        return bids;
    }

    function updateFeeReceiver(address _newReceiver) external onlyOwner {
        require(_newReceiver != address(0), ERR_INVALID_ADDRESS);
        require(_newReceiver != feeReceiver, ERR_SAME_RECEIVER);

        address previousReceiver = feeReceiver;
        feeReceiver = _newReceiver;

        emit FeeReceiverUpdated(previousReceiver, _newReceiver);
    }

    function updateFeePercent(uint _newPercent) external onlyOwner {
        require(_newPercent <= 100, ERR_INVALID_FEE);
        require(_newPercent != feePercent, ERR_SAME_FEE);

        uint previousPercent = feePercent;
        feePercent = _newPercent;

        emit FeePercentUpdated(previousPercent, _newPercent);
    }
}
