ERC-721 NFT Marketplace Documentation
Overview
This documentation covers the ERC-721 NFT Marketplace project, designed and developed as an upgradeable smart contract with auction functionalities. The project includes a MyNFT smart contract and a Node.js backend script for interacting with the smart contract.

Smart Contract: MyNFT.sol
The MyNFT smart contract is built using Solidity ^0.8.0 and leverages OpenZeppelin's upgradeable contracts. The contract allows for minting NFTs, listing them for fixed prices or auctions, and managing bids.

Key Features:
Minting NFTs: Only addresses with MINTER_ROLE can mint NFTs.
Listing for Fixed Price: Users can list NFTs with a specified price.
Auction Functionality: Users can start, bid in, and end auctions for NFTs.
Upgradeability: Contract can be upgraded while preserving state.
Reentrancy Protection: Uses OpenZeppelin's ReentrancyGuard for secure fund transfers.
Key Functions:
initialize(): Initializes the contract with necessary roles and settings.
safeMint(address to, uint256 tokenId): Mints a new NFT.
listNFT(uint256 tokenId, uint256 price): Lists an NFT for sale at a fixed price.
startAuction(uint256 tokenId, uint256 startingBid, uint256 duration): Starts an auction for an NFT.
placeBid(uint256 tokenId): Places a bid on an ongoing auction.
endAuction(uint256 tokenId): Ends the auction and handles the transfer of the NFT and funds.
getFixedPriceListing(uint256 tokenId): Retrieves information about a fixed-price listing.
getAuctionListing(uint256 tokenId): Retrieves information about an auction listing.
getAuctionEndTime(uint256 tokenId): Retrieves the end time of an auction.
getAuctionBidders(uint256 tokenId): Retrieves a list of bidders in an auction.
Node.js Backend Script: script.js
The backend script uses ethers.js to interact with the deployed MyNFT smart contract. It allows for the execution of smart contract functions from a Node.js environment.

Setup:
.env contains the correct contract address, private key, and Infura endpoint.
ABI file should be updated with the compiled ABI of the smart contract.
Key Functions:
listNFTForFixedPrice(tokenId, price): Lists an NFT for a fixed price.
listNFTForAuction(tokenId, startingBid, durationInSeconds): Starts an auction for an NFT.
placeBid(tokenId, bidAmount): Places a bid in an NFT auction.
endAuction(tokenId): Ends an NFT auction.
getFixedPriceListing(tokenId): Retrieves details of a fixed price listing.
getAuctionListing(tokenId): Retrieves details of an auction listing.
getAuctionEndTime(tokenId): Retrieves the auction end time for an NFT.
getAuctionBidders(tokenId): Retrieves the addresses of bidders in an auction.
safeMint(toAddress, tokenId): Mints a new NFT.

Additional Notes
The contract is designed to be upgradeable, allowing for new features and improvements.
Proper security measures and considerations are crucial for real-world deployment.
The project is structured for maintainability and scalability.

