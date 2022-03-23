pragma solidity ^0.4.4;
import "./Auction.sol";
contract EnglishAuction is Auction {
	uint256 public minBidIncrement;
	uint public numUnchallengedBlocks;
	uint public lastBidBlock;
	mapping (address => uint) public PendingWithdrawals;
	bool refundCalled;
	bool finalizeCalled;
    // constructor
    function EnglishAuction(uint256 reservePrice, address judgeAddress, uint256 biddingTimePeriod, uint256 minimumBidIncrement) Auction(reservePrice, biddingTimePeriod, judgeAddress) {
        minBidIncrement = minimumBidIncrement;
        numUnchallengedBlocks = 3;
    }
    function bid() biddingOpen payable returns(address highestBidderAddr) {
    	require(msg.value >= minimumPrice);
    	require(msg.value >= highestBid + minBidIncrement);
    	if(highestBidder!=0){
    		if(!highestBidder.send(highestBid)){
    			PendingWithdrawals[highestBidder]+=highestBid;
    		}
    	}
    	highestBidder = msg.sender;
    	highestBid = msg.value;
    	lastBidBlock = block.number;
    	return highestBidder;
    }    
    function finalize() auctionOver {
    	require(msg.sender==highestBidder || msg.sender == judgeAddr);
    	require(!refundCalled && !finalizeCalled);
    	finalizeCalled=true;
    	creator.transfer(highestBid);
    }
    function refund(uint256 refundAmount) auctionOver judgeOnly {
    	require(highestBidder!=0);
		require(refundAmount<= this.balance);
		require(!finalizeCalled && !refundCalled);
		refundCalled = true;
		highestBidder.transfer(refundAmount);
		creator.transfer(highestBid-refundAmount);
    }
    function withdraw(){
    	uint amount = PendingWithdrawals[msg.sender];
    	PendingWithdrawals[msg.sender]=0;
    	if(amount>0){
    		msg.sender.transfer(amount);
    	}
    }
    modifier auctionOver {
    	require(block.number > startBlockNum+biddingBlocksNum);
    	_;
    }
    modifier biddingOpen {
    	require(lastBidBlock+numUnchallengedBlocks>=block.number);
		require(block.number<=startBlockNum+biddingBlocksNum);
		_;
    }
}