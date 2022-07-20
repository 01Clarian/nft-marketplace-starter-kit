// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable,ERC721{

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens
    mapping(uint256 => uint256) private _allTokenIndex;

    //mapping of owner to list of all token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from token id index of the owner token list 
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public override view returns (uint256){
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external override view returns (uint256){
        //making sure index is not out of bond for total supply
        require(_index<totalSupply(),'global index is out of bound');
        return _allTokens[_index];
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external override view returns (uint256){
        require(_index<balanceOf(_owner),'owner list index is out of bound');
        return _ownedTokens[_owner][_index];
    }

    function _mint(address to,uint256 tokenId)internal override(ERC721){
        super._mint(to,tokenId);
        //add tokens to owner token list
        _addTokensToOwnerEnumaration(to, tokenId);
        //add tokens to our totalsupply - to _allTokens
        _allTokensToAllTokensEnumaration(tokenId);
    }
    //add tokens to the _allTokens array and set the index position of the token
    function _allTokensToAllTokensEnumaration(uint256 tokenId) private {
        _allTokenIndex[tokenId]=_allTokens.length;
        _allTokens.push(tokenId);
    }
    //add tokens to the _ownedTokens array and set the index position of the token
    function _addTokensToOwnerEnumaration(address to,uint256 tokenId) private{
        //add address and tokenId to the _ownedTokens
        _ownedTokens[to].push(tokenId);
        //ownedTokenIndex tokenId set to address of ownedTokens position
        _ownedTokensIndex[tokenId]=_ownedTokens[to].length;
        //execute this function with minting
    }
}