// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract Nft is ERC721Connector{

    //array to store our Nfts
    string[] public allNfts;

    mapping(string => bool) public _nftExists;

    function mint(string memory _nft) public {
        require(!_nftExists[_nft],'Error : Nft already exists');
        //.push is deprecated for compilers version above 0.6.0
        //.push no longer returns length but reference to the added element
        //uint256 _id = allNfts.push(_nft);
        allNfts.push(_nft);
        uint256 _id = allNfts.length-1;
        _mint(msg.sender,_id);
        _nftExists[_nft]=true;
    }


    constructor() ERC721Connector('NFT smart cards','NFTz'){}
}