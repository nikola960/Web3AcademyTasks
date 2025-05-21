// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MembershipNFT is ERC721URIStorage {
    uint256 private currentId = 1000;
    uint256 public constant PRICE = 0.01 ether;

    address public daoAddress;

    mapping(address => uint256) private ownedToken;

    event Minted(address indexed user, uint256 tokenId, string uri);

    constructor(address _daoAddress, address initialUser) ERC721("DAO Membership", "DAOM") {
        daoAddress = _daoAddress;
        _mintTo(initialUser, "ipfs://default-uri");
    }

    function mint(string calldata uri) external payable {
        require(ownedToken[msg.sender] == 0, "Already owns a token");
        require(msg.value >= PRICE, "Not enough ETH");

        _mintTo(msg.sender, uri);
    }

    function _mintTo(address to, string memory uri) internal {
        uint256 tokenId = currentId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        ownedToken[to] = tokenId;

        emit Minted(to, tokenId, uri);
    }

    function hasMinted(address user) external view returns (bool) {
        return ownedToken[user] != 0;
    }

    function getTokenId(address user) external view returns (uint256) {
        return ownedToken[user];
    }
}
