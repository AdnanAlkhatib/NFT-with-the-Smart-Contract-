// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract MyNFT is Initializable, ERC721Upgradeable, AccessControlUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    struct FixedPriceListing {
        uint256 price;
        address owner;
        bool active;
    }

    struct AuctionListing {
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        address owner;
        bool active;
        Bid[] bids;
    }

    struct Bid {
        address bidder;
        uint256 amount;
    }

    mapping(uint256 => FixedPriceListing) public fixedPriceListings;
    mapping(uint256 => AuctionListing) public auctionListings;

    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTAuctionListed(uint256 indexed tokenId, uint256 startingBid, uint256 endTime);
    event NewBidPlaced(uint256 indexed tokenId, address bidder, uint256 amount);
    event AuctionEnded(uint256 indexed tokenId, address winner, uint256 amount);

    function initialize() public initializer {
        __ERC721_init("MyNFT", "MNFT");
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

    function safeMint(address to, uint256 tokenId) public onlyRole(MINTER_ROLE) {
        _safeMint(to, tokenId);
    }

    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        fixedPriceListings[tokenId] = FixedPriceListing(price, msg.sender, true);
        emit NFTListed(tokenId, price);
    }

    function startAuction(uint256 tokenId, uint256 startingBid, uint256 duration) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        uint256 endTime = block.timestamp + duration;
        auctionListings[tokenId] = AuctionListing(startingBid, address(0), endTime, msg.sender, true);
        emit NFTAuctionListed(tokenId, startingBid, endTime);
    }

    function placeBid(uint256 tokenId) public payable {
        AuctionListing storage listing = auctionListings[tokenId];
        require(block.timestamp < listing.endTime, "Auction ended");
        require(msg.value > listing.highestBid, "Bid too low");

        if (listing.highestBidder != address(0)) {
            payable(listing.highestBidder).transfer(listing.highestBid);
        }

        listing.highestBid = msg.value;
        listing.highestBidder = msg.sender;
        listing.bids.push(Bid(msg.sender, msg.value));

        emit NewBidPlaced(tokenId, msg.sender, msg.value);
    }

    function endAuction(uint256 tokenId) public nonReentrant {
        AuctionListing storage listing = auctionListings[tokenId];
        require(block.timestamp >= listing.endTime, "Auction not yet ended");
        require(listing.active, "Auction not active");

        listing.active = false;
        _transfer(listing.owner, listing.highestBidder, tokenId);
        payable(listing.owner).transfer(listing.highestBid);

        emit AuctionEnded(tokenId, listing.highestBidder, listing.highestBid);
    }

    // Retrieve data for a fixed price NFT
    function getFixedPriceListing(uint256 tokenId) public view returns (FixedPriceListing memory) {
        return fixedPriceListings[tokenId];
    }

    // Retrieve data for an auction NFT
    function getAuctionListing(uint256 tokenId) public view returns (AuctionListing memory) {
        return auctionListings[tokenId];
    }

    // Retrieve the auction end time for a specific NFT ID
    function getAuctionEndTime(uint256 tokenId) public view returns (uint256) {
        return auctionListings[tokenId].endTime;
    }

    // getAuctionBidders function to return all bidders
    function getAuctionBidders(uint256 tokenId) public view returns (address[] memory) {
        AuctionListing storage listing = auctionListings[tokenId];
        address[] memory bidders = new address[](listing.bids.length);
        for (uint i = 0; i < listing.bids.length; i++) {
            bidders[i] = listing.bids[i].bidder;
        }
        return bidders;
    }
}
