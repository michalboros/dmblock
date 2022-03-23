pragma solidity ^0.4.4;
contract Auction {
	
	uint256 public minimumPrice;  
	uint256 public biddingBlocksNum;  
	address judgeAddr;
	uint256 public startBlockNum;
	address public creator;
	address highestBidder;
	uint256 highestBid;
	
	// constructor
	function Auction(uint256 reservePrice, uint256 biddingTimePeriod, address judgeAddress) {
		minimumPrice = reservePrice;
		biddingBlocksNum = biddingTimePeriod;
		judgeAddr = judgeAddress;
		startBlockNum = block.number; 
		creator = msg.sender;
	}
	// Three types of bidding functions. If not overriden, these generate errors
	function bid() biddingOpen payable returns(address) {
		require(false);
	}
	function commitBid(bytes32 bidCommitment) biddingOpen payable returns(bool) {
		require(false);
	}
	function revealBid(uint256 nonce) payable returns(address) {
		require(false);
	}
	function finalize() auctionOver {
		require(false);
	}
	
	function refund(uint256 refundAmount) auctionOver judgeOnly {
		require(false);
	}
	modifier biddingOpen {
		require(false);
		_;
	}
	modifier auctionOver {
		require(false);
		_;
	}
	modifier judgeOnly {
		require(msg.sender == judgeAddr);
		_;
	}
	
}