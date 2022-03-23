pragma solidity ^0.4.4;
import "./Auction.sol";
contract VickreyAuction is Auction {
	uint256 public bidDepositAmount;
	uint256 public revealBlocksNum;
	uint256 secondHighestBid;
	bool refundCalled;
	bool finalizeCalled;
	mapping ( address => mapping ( bytes32 => uint32) ) deposits;   // maps address,bid => count
	mapping ( address => uint ) bidAmount;
	// constructor
	function VickreyAuction(uint256 reservePrice, address judgeAddress, uint256 commitTimePeriod, uint256 revealTimePeriod, uint256 _bidDepositAmount) Auction(reservePrice, commitTimePeriod, judgeAddress) {
		bidDepositAmount = _bidDepositAmount;
		revealBlocksNum = revealTimePeriod; 
	}
	function commitBid(bytes32 bidCommitment) biddingOpen payable returns(bool) {
		require(msg.value == bidDepositAmount);
		deposits[msg.sender][bidCommitment]+=1;
		return true;
	}
	function revealBid(uint256 nonce) revealOpen payable returns(address highestBidder) {
		bytes32 commitval = sha3(nonce,msg.value);
		require(deposits[msg.sender][commitval]>0);
		deposits[msg.sender][commitval]--;
		bidAmount[msg.sender]+=msg.value;
		if(msg.value>secondHighestBid && msg.value>=minimumPrice){
			if(msg.value>highestBid){
				secondHighestBid = highestBid;
				highestBid = msg.value;
				highestBidder = msg.sender;
			}else{
				secondHighestBid = msg.value;
			}
		}
		msg.sender.transfer(bidDepositAmount);
		return highestBidder;
	}
	function finalize() auctionover {
		require(msg.sender == highestBidder || msg.sender == judgeAddr);
		require(!refundCalled && !finalizeCalled);
		finalizeCalled=true;
		if(secondHighestBid==0 && highestBid!=0){
			creator.transfer(minimumPrice);
		}else if(secondHighestBid>0){
			creator.transfer(secondHighestBid);
		}
	}
	function refund(uint256 refundAmount) auctionOver judgeOnly {
		require(highestBidder!=0);
		require(refundAmount<=this.balance);
		require(!finalizeCalled && !refundCalled);
		refundCalled=true;
		highestBidder.transfer(refundAmount);
		if(secondHighestBid==0 && highestBid>0){
			if(minimumPrice>refundAmount)
				creator.transfer(minimumPrice-refundAmount);
		}else if (secondHighestBid>refundAmount)
			creator.transfer(secondHighestBid-refundAmount);
	}
	function withdraw() auctionover returns (uint){
		uint amount;
		if(msg.sender==highestBidder){
			uint payAmount = secondHighestBid;
			if(secondHighestBid == 0)
				payAmount = minimumPrice;
			amount = bidAmount[msg.sender]-payAmount;
			bidAmount[msg.sender]=payAmount;
			msg.sender.transfer(amount);
			return amount;
		}
		amount = bidAmount[msg.sender];
		bidAmount[msg.sender] = 0;
		msg.sender.transfer(amount);
		return amount;
	}
	modifier auctionover {
		require(block.number > startBlockNum+biddingBlocksNum+revealBlocksNum);
		_;
	}
	modifier biddingOpen {
		require(block.number <= startBlockNum+biddingBlocksNum);
		_;
	}
	modifier revealOpen {
		require(block.number > startBlockNum+biddingBlocksNum);
		require(block.number <= startBlockNum+biddingBlocksNum+revealBlocksNum);
		_;
	}
}