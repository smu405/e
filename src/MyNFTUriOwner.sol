// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "https://github.com/nibbstack/erc721/blob/2.6.1/src/contracts/ownership/ownable.sol";

//Ownable added: minToPay, transferToPay
contract MyNFTUriOwner is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;	//NFT id

    mapping(uint256 => uint256) public tranPrice;

    // from, to, tokenId, tokenURI, tranPrice
    event Transfer(address from, address to, uint256 _tokenId,
        string tokenURI, uint256 tranPrice);

    constructor() ERC721("MyNFT", "JSL") {}

    function mintWithURI(address to, string memory tokenURI) public returns(uint256) {
        _tokenIds.increment(); // add 1 by minting
        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId); // or _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI); // need to import ERC721URIStorage
        return newTokenId;
    }
    function mintWithIdURI(uint256 _id, address to, string memory tokenURI) public returns(uint256) {
        _mint(to, _id);
        _setTokenURI(_id, tokenURI);
        return _id;
    }
    //Note who calls this function. Does not make sense if owner is the one who pays
    function mintWithURIPrice(address to, string memory tokenURI, uint256 _p)
    public payable onlyOwner returns(uint256) {
        require(msg.value == _p, "Not Enough Ether");
        uint256 newTokenId = mintWithURI(to, tokenURI);
        tranPrice[newTokenId] = _p;
        return newTokenId;
    }
    function getTotalSupply() public view returns(uint256) { return _tokenIds.current(); }
    function getOwner() view public returns(address) {
        return owner();  //function of the Ownerable contract
    }

    // msg.value transferred to this contract!!
    function transferToPay(address from, address to, uint256 _tokenId) public payable {
        require(_exists(_tokenId), "Error: TokenId not owned");
        require(msg.value >= tranPrice[_tokenId], "Error: Token costs more");
        _transfer(from, to, _tokenId);
        emit Transfer(from, to, _tokenId, tokenURI(_tokenId), tranPrice[_tokenId]);
    }
    function burn(uint256 _tokenId) public { _burn(_tokenId); }
}
