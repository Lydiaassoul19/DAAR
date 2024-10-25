// SPDX-License-Identifier: MIT
// Directive de licence indiquant que le code est sous licence MIT
// solhint-disable-next-line
pragma solidity ^0.8.1; 

// Importation des contrats ERC721URIStorage et Ownable d'OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Déclaration du contrat Collection, qui hérite de ERC721URIStorage et Ownable
contract Collection is ERC721URIStorage, Ownable {
    string public collectionName;
    uint256 public cardCount;    

    // Mapping pour stocker le numéro de carte associé à chaque identifiant de token 
    mapping(uint256 => uint256) public cardNumber;

    // Constructeur pour initialiser le nom de la collection et le nombre de cartes
    constructor(string memory _name, uint256 _cardCount) ERC721(_name, "COLL") {
        collectionName = _name;
        cardCount = _cardCount;
    }
  
    // Fonction pour convertir un uint256 en string
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
           return "0"; 
        }
        uint256 temp = value;
        uint256 digits; 
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits); 
        while (value != 0) {
            digits = digits - 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); 
            value /= 10;
        }
        return string(buffer); 
    }

    // Fonction pour créer une carte avec un numéro spécifique
    function mintCard(address to, uint256 tokenId, uint256 _cardNumber, string memory imgUri) public onlyOwner {
        _mint(to, tokenId); 
        _setTokenURI(tokenId, imgUri); 
        string memory metadataUri = string(abi.encodePacked(imgUri)); 
        _setTokenURI(tokenId, metadataUri); 
        cardNumber[tokenId] = _cardNumber; 
    }
    
    //  Stocker les informations du NFT
    struct NFTInfo {
        address owner;       
        uint256 cardNumber;  
        string imgUri;       
    }

    // Rrécupérer les informations d'une carte en fonction de son identifiant (tokenId)
    function getCardInfo(uint256 tokenId) public view returns (NFTInfo memory) {
        require(_exists(tokenId), "Token does not exist"); 
        return NFTInfo({
            owner: ownerOf(tokenId),             
            cardNumber: cardNumber[tokenId],     
            imgUri: tokenURI(tokenId)            
        });
    }
}
