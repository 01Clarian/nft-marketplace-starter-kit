// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

/*
Building out the minting function
a. Nft to point to an address
b. Keep track of token ids
c. Keep track of token owner addresses to token ids
d. Keep track of how many tokens an owner address has
e. Create an event that emmit the transfer log - contract address,where it is being minted to, the id

*/

contract ERC721 is ERC165, IERC721 {
    //mapping from token id to owner
    mapping(uint256 => address) private _tokenOwner;

    //mapping from token owner to number of tokens owned
    mapping(address => uint256) private _ownedTokenCount;

    

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "owner query for non-existent token");
        return _ownedTokenCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existent token");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        //getting owner address with tokenId
        address owner = _tokenOwner[tokenId];
        //if owner exists returns true if owner doesn't exist returns false
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        //requires the minting address should not be zero
        require(to != address(0), "ERC721: Minting to the zero address");
        //requires to mint only if the tokenId doesnt exists in the _tokenOwner
        //i.e doesn't mint if already minted.
        require(!_exists(tokenId), "ERC721: Token already minted!");
        //adding new address with a tokenId for minting
        _tokenOwner[tokenId] = to;
        //incrementing the number of tokens owner minted.
        _ownedTokenCount[to] += 1;
        //emit the transaction info
        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Error : ERC721 Transfer to zero address");
        require(
            ownerOf(_tokenId) == _from,
            "trying to transfer a token the address does not exist"
        );
        _ownedTokenCount[_from] -= 1;
        _ownedTokenCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        _transferFrom(_from, _to, _tokenId);
    }
}
