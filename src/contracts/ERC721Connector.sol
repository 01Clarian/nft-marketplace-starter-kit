// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721.sol';
import './ERC721Enumerable.sol';

contract ERC721Connector is ERC721Metadata,ERC721Enumerable{
    constructor(string memory named,string memory symbolified)ERC721Metadata(named,symbolified){

    }
}