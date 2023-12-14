const { ethers } = require('ethers');
const contractABI = require('./path_to_ABI.json'); // We need here to replace with our ABI file
const contractAddress = 'your_contract_address_on_goerli_testnet'; // We need here to replace with our contract address

const provider = new ethers.providers.JsonRpcProvider('https://goerli.infura.io/v3/your_infura_project_id'); // We need here to replace with our Infura project ID
const privateKey = 'private_key'; // We need here to replace with our private key
const wallet = new ethers.Wallet(privateKey, provider);

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

async function listNFTForFixedPrice(tokenId, price) {
    const tx = await contract.listNFT(tokenId, ethers.utils.parseUnits(price.toString(), 'ether'));
    await tx.wait();
}

async function listNFTForAuction(tokenId, startingBid, durationInSeconds) {
    const tx = await contract.startAuction(tokenId, ethers.utils.parseUnits(startingBid.toString(), 'ether'), durationInSeconds);
    await tx.wait();
}

async function placeBid(tokenId, bidAmount) {
    const tx = await contract.placeBid(tokenId, { value: ethers.utils.parseUnits(bidAmount.toString(), 'ether') });
    await tx.wait();
}

async function endAuction(tokenId) {
    const tx = await contract.endAuction(tokenId);
    await tx.wait();
}

async function getFixedPriceListing(tokenId) {
    return await contract.getFixedPriceListing(tokenId);
}

async function getAuctionListing(tokenId) {
    return await contract.getAuctionListing(tokenId);
}

async function getAuctionEndTime(tokenId) {
    return await contract.getAuctionEndTime(tokenId);
}

async function getAuctionBidders(tokenId) {
    return await contract.getAuctionBidders(tokenId);
}

async function safeMint(toAddress, tokenId) {
    const tx = await contract.safeMint(toAddress, tokenId);
    await tx.wait();
}

// Example usage
async function main() {
    try {
        // Example: Listing an NFT for a fixed price
        await listNFTForFixedPrice(1, "0.1"); // Listing tokenId 1 for 0.1 ETH
    } catch (error) {
        console.error(error);
    }
}

main();
