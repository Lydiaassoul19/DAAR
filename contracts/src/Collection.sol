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
           return "0"; // Si la valeur est 0, retourne "0"
        }
        uint256 temp = value;
        uint256 digits; // Compte le nombre de chiffres de la valeur
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits); // Crée un tableau de bytes pour chaque chiffre
        while (value != 0) {
            digits = digits - 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10))); // Stocke chaque chiffre en ASCII
            value /= 10;
        }
        return string(buffer); // Retourne le nombre sous forme de string
    }

    // Fonction pour créer une carte avec un numéro spécifique
    function mintCard(address to, uint256 tokenId, uint256 _cardNumber, string memory imgUri) public onlyOwner {
        _mint(to, tokenId); // Crée le NFT et l’assigne à l'adresse 'to'
        _setTokenURI(tokenId, imgUri); // Associe l'URI de l'image à l'identifiant du token
        string memory metadataUri = string(abi.encodePacked(imgUri)); // Crée une chaîne de métadonnées
        _setTokenURI(tokenId, metadataUri); // Associe les métadonnées au token
        cardNumber[tokenId] = _cardNumber; // Associe le numéro de carte au tokenId dans le mappage
    }
    
    //  Stocker les informations du NFT
    struct NFTInfo {
        address owner;       // Propriétaire de la carte
        uint256 cardNumber;  // Numéro de la carte
        string imgUri;       // URI de l'image de la carte
    }

    // Rrécupérer les informations d'une carte en fonction de son identifiant (tokenId)
    function getCardInfo(uint256 tokenId) public view returns (NFTInfo memory) {
        require(_exists(tokenId), "Token does not exist"); // Vérifie si le token existe
        return NFTInfo({
            owner: ownerOf(tokenId),             // Récupère le propriétaire de la carte
            cardNumber: cardNumber[tokenId],     // Récupère le numéro de la carte
            imgUri: tokenURI(tokenId)            // Récupère l'URI de l'image
        });
    }
}
