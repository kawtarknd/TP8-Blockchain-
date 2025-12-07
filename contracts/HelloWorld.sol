pragma solidity ^0.5.16; 

contract HelloWorld {
    
    // Correction 1: Renommer la variable de stockage pour éviter la collision avec la fonction.
    bytes32 private _yourName; 
    
    // Fonction getter (view) pour la lecture de la variable.
    function yourName() public view returns (bytes32) {
        return _yourName;
    }

    // Le constructeur est exécuté une seule fois
    constructor() public {
        // Initialisation : Conversion de "Unknown" en bytes32.
        _yourName = "Unknown";
    }

    // Permet de définir (modifier) la valeur de yourName
    function setName(string memory nm) public {
        // Correction 2: Utiliser la conversion autorisée pour la version 0.5.16.
        // Convertir le string en bytes, puis le prendre comme bytes32.
        bytes32 nameBytes;
        // La longueur du string (en bytes) doit être <= 32.
        assembly {
            nameBytes := mload(add(nm, 32)) 
        }
        _yourName = nameBytes;
    }
}