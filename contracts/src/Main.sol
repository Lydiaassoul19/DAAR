// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity ^0.8.1; 

import "@openzeppelin/contracts/access/Ownable.sol"; // Contrat Ownable pour gérer la propriété
import "./Collection.sol"; // Import du contrat Collection pour la gestion des cartes

// Déclaration du contrat principal Main, qui hérite de Ownable
contract Main is Ownable {
   
    address[] private collectionAddresses;
    uint256 private collectionCount; // Nombre de collections existantes
    mapping(uint256 => string) private tokenURIs; // Mapping pour stocker les URIs des tokens
    mapping(uint256 => string) private collectionNames; // Mapping pour stocker les noms des collections
    mapping(uint256 => uint256) private nftsInCollection; // Nombre de NFTs dans chaque collection

    // Constructeur pour initialiser le compteur de collections
    constructor() {
        collectionCount = 0;
    }

    // Fonction pour obtenir le nombre de collections
    function getCollectionCount() public view returns (uint256) {
        return collectionCount;
    }

    // Fonction pour obtenir le nombre de NFTs dans une collection spécifique
    function getNFTCountInCollection(uint256 collectionIndex) public view returns (uint256) {
        require(collectionIndex < collectionCount, "Invalid collection index"); // Vérifie que l'index est valide
        return nftsInCollection[collectionIndex];
    }

    // Fonction pour créer une nouvelle collection
    function createCollection(string calldata name, uint256 cardCount) external onlyOwner {
        address collectionAddress = address(new Collection(name, cardCount)); // Crée une nouvelle collection et obtient son adresse
        collectionAddresses.push(collectionAddress); // Stocke l'adresse dans le tableau
        collectionCount++; // Incrémente le compteur de collections
    }

    // Fonction pour obtenir l'adresse d'une collection par son index
    function getCollectionAddress(uint256 index) public view returns (address) {
        require(index < collectionCount, "Invalid index"); // Vérifie que l'index est valide
        return collectionAddresses[index];
    }

    // Fonction pour obtenir toutes les adresses des collections
    function getAllCollectionAddresses() public view returns (address[] memory) {
        return collectionAddresses;
    }

    // Déclaration de l'événement LogInfo pour journaliser des informations
    event LogInfo(string message, uint256 value);

    // Fonction pour minter une carte (NFT) pour un utilisateur spécifique
    function mintCardToUser(address user, uint256 collectionIndex, uint256 tokenId, uint256 cardNumber, string memory imgUri) external onlyOwner {
        require(collectionIndex < collectionCount, "Invalid index"); // Vérifie que l'index de collection est valide

       
        emit LogInfo("Collection Index:", collectionIndex);
        emit LogInfo("Collection Count:", collectionCount);

      
        address collectionAddress = collectionAddresses[collectionIndex];
        require(collectionAddress != address(0), "Collection does not exist"); // Vérifie que la collection existe

        Collection collection = Collection(collectionAddress); 
        collection.mintCard(user, tokenId, cardNumber, imgUri); 
        tokenURIs[tokenId] = imgUri; 
        nftsInCollection[collectionIndex]++; 
    }

    // Fonction pour obtenir l'URI d'un token spécifique
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURIs[tokenId];
    }

    // Fonction pour obtenir les informations d'un NFT d'une collection donnée
    function getNFTInfo(uint256 collectionIndex, uint256 tokenId) public view returns (address owner, uint256 cardNumber, string memory imgUri) {
        address collectionAddress = collectionAddresses[collectionIndex]; 
        Collection collection = Collection(collectionAddress);
        Collection.NFTInfo memory nftInfo = collection.getCardInfo(tokenId); 
        owner = nftInfo.owner; 
        cardNumber = nftInfo.cardNumber; 
        imgUri = nftInfo.imgUri;
    }
}

       
