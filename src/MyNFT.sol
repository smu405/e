// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/Counters.sol";

contract MyNFT is ERC721 {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;	//NFT id
	
	constructor() ERC721("Hello DApp Screens", "JSL") {}
	// override
	// JSON metadata URL from ipfs
	// does not save toeknURI in the state var
	function _baseURI() internal pure override returns (string memory) {
		return "https://ipfs.io/ipfs/QmbdwcmzYacLZHLBAhAsaJm2aPV1bzBjFjweD1UgZzkEtA";
	}

    function mint(address to) public returns(uint256) {
        //require(_tokenIds.current() < 3); //only 3 to mint
        _tokenIds.increment(); // add 1 by minting
        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId); // or _safeMint(to, newTokenId);

        return newTokenId;
    }
}
