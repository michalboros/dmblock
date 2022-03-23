pragma solidity ^0.4.4;
import "./Auction.sol";
contract DutchAuction is Auction {
	uint256 public decrementPerBlock;
	bool public bidover;
	uint256 public startPrice;
	bool refundCalled;
	bool finalizeCalled;
	// constructor
	function DutchAuction(uint256 reservePrice, address judgeAddress, uint256 biddingPeriod, uint256 offerPriceDecrement) Auction(reservePrice, biddingPeriod, judgeAddress) {
	    decrementPerBlock = offerPriceDecrement;
	    startPrice = reservePrice+biddingPeriod*offerPriceDecrement;
	}
	function bid() biddingOpen payable returns(address highestBidderAddr){
		uint256 currentPrice = startPrice-(block.number-startBlockNum)*decrementPerBlock;
		require(msg.value >= currentPrice);
		highestBidder = msg.sender;
		highestBid = msg.value;
		bidover = true;
		return highestBidder;
	}
	function finalize(){
		require(msg.sender==highestBidder || msg.sender == judgeAddr);
		require(!refundCalled && !finalizeCalled);
		finalizeCalled=true;
		creator.transfer(highestBid);
	}
	function refund(uint256 refundAmount) auctionOver judgeOnly {
		require(highestBidder!=0);
		require(refundAmount<= this.balance);
		require(!finalizeCalled && !refundCalled);
		refundCalled=true;
		highestBidder.transfer(refundAmount);
		creator.transfer(this.balance);
	}
	modifier biddingOpen {
		require(block.number<=startBlockNum+biddingBlocksNum);
		require(!bidover);
		_;
	}
	modifier auctionOver {
		require(block.number>startBlockNum+biddingBlocksNum || bidover);
		_;
	}
}