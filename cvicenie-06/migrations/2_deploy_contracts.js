 const Auction = artifacts.require("Auction");
 const Auctions = artifacts.require("Auctions");
 const DutchAuction = artifacts.require("DutchAuction");
 const VickreyAuction = artifacts.require("VickreyAuction");
 const EnglishAuction = artifacts.require("EnglishAuction");

module.exports = function(deployer) {
    deployer.deploy(Auction, 500, 10, "0x021fe75ffAB3b29A8a351b224A32892D6573c969");
    deployer.deploy(Auctions);
    deployer.deploy(DutchAuction, 500, "0x021fe75ffAB3b29A8a351b224A32892D6573c969", 10, 25);
    deployer.deploy(VickreyAuction, 500, "0x021fe75ffAB3b29A8a351b224A32892D6573c969", 6, 7, 5000);
    deployer.deploy(EnglishAuction, 300, "0x021fe75ffAB3b29A8a351b224A32892D6573c969", 5, 25);
    //deployer.autolink();
  };