// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NoahNFT is ERC721URIStorage, ERC2981, Ownable {
    using Math for uint256;
    using SafeERC20 for IERC20;

    uint256 public nextTokenId;

    IERC20 public usdtToken = IERC20(0x55d398326f99059fF775485246999027B3197955);
    address private reward_addr = 0x76381CCD6537B6E5C1eA1CF6CFA1212CEE6fc10B;
    address public blackHole = 0x000000000000000000000000000000000000dEaD;
    uint256 public usdt_30 = 30 * 10**18;
    uint256 public constant MAX_SUPPLY = 125000;
    bool public isPaused = false;

    mapping(string => bool) private mintedURIs;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

    event ContractPaused(address by);
    event ContractResumed(address by);

    struct MintRecord {
        address mintedBy;
        uint256 mintedTime;
        string tokenURI;
        uint256 blockNum;
    }

    mapping(uint256 => MintRecord) public mintRecords;
    uint256[] public mintedTokenIds;
    mapping(address => uint256[]) public userMintedTokenIds;

    struct StakedNFT {
        address owner;
        uint256 tokenId;
        uint256 stakedTime;
        uint256 redeemedTime;
        uint256 blockNum;
    }

    StakedNFT[] public stakedNFTsArray;
    mapping(address => uint256[]) public userStakedNFTs;
    //在合约部署时，初始化 NFT 的名称、符号，并设置合约的所有者（Owner
    constructor(address initialOwner) ERC721("Noah", "Noah") {
        _transferOwnership(initialOwner);
    }

    function setUsdtTokenAddr(address tokenAddr) public onlyOwner {
        usdtToken = IERC20(tokenAddr);
    }

    function setRewardAddr(address reward) public onlyOwner {
        reward_addr = reward;
    }

    function setMintPrice(uint256 price) public onlyOwner {
        usdt_30 = price;
    }

    function setUsdtReward(uint256 amount) public payable returns (bool) {
        require(msg.sender == reward_addr, "only reward address.");
        usdtToken.safeTransferFrom(msg.sender, address(this), amount);
        return true;
    }

    function GetUSDTReward(address userAddr, uint256 amount) external payable returns (bool) {
        require(msg.sender == reward_addr, "only reward address.");
        usdtToken.safeTransfer(userAddr, amount);
        return true;
    }

    function pauseContract() external onlyOwner {
        require(!isPaused, "Contract is already paused.");
        isPaused = true;
        emit ContractPaused(msg.sender);
    }

    function resumeContract() external onlyOwner {
        require(isPaused, "Contract is not paused.");
        isPaused = false;
        emit ContractResumed(msg.sender);
    }

    function mint(address to, string memory tokenURI) public payable {
        require(!isPaused, "Contract is paused.");
        require(nextTokenId < MAX_SUPPLY, "Exceeds maximum supply");

        usdtToken.safeTransferFrom(msg.sender, address(this), usdt_30);

        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, tokenURI);

        mintedURIs[tokenURI] = true;
        _addTokenToOwnerEnumeration(to, nextTokenId);

        mintRecords[nextTokenId] = MintRecord({
            mintedBy: msg.sender,
            mintedTime: block.timestamp,
            tokenURI: tokenURI,
            blockNum: block.number
        });

        mintedTokenIds.push(nextTokenId);
        userMintedTokenIds[msg.sender].push(nextTokenId);
        nextTokenId++;
    }

    function mintBatch(address to, string[] memory tokenURIs) public payable {
        require(!isPaused, "Contract is paused.");
        require(tokenURIs.length > 0, "No URIs provided.");
        require((nextTokenId + tokenURIs.length) <= MAX_SUPPLY, "Exceeds maximum supply");

        uint256 totalPrice = usdt_30 * tokenURIs.length;
        usdtToken.safeTransferFrom(msg.sender, address(this), totalPrice);

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            string memory tokenURI = tokenURIs[i];

            _safeMint(to, nextTokenId);
            _setTokenURI(nextTokenId, tokenURI);

            mintedURIs[tokenURI] = true;
            _addTokenToOwnerEnumeration(to, nextTokenId);

            mintRecords[nextTokenId] = MintRecord({
                mintedBy: msg.sender,
                mintedTime: block.timestamp,
                tokenURI: tokenURI,
                blockNum: block.number
            });

            mintedTokenIds.push(nextTokenId);
            userMintedTokenIds[msg.sender].push(nextTokenId);
            nextTokenId++;
        }
    }

    function getUserMintRecordsByPage(address user, uint256 page, uint256 pageSize) external view returns (MintRecord[] memory) {
        uint256[] memory userTokenIds = userMintedTokenIds[user];
        uint256 totalRecords = userTokenIds.length;

        uint256 start = page * pageSize;
        uint256 end = start + pageSize > totalRecords ? totalRecords : start + pageSize;
        require(start < totalRecords, "Page exceeds available records.");

        MintRecord[] memory records = new MintRecord[](end - start);
        for (uint256 i = start; i < end; i++) {
            records[i - start] = mintRecords[userTokenIds[i]];
        }

        return records;
    }

    function getUserMintedTokenIdsLength(address user) external view returns (uint256) {
        uint256[] memory userTokenIds = userMintedTokenIds[user];
        return userTokenIds.length;
    }

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) public onlyOwner {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721URIStorage, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function stakeNFTs(uint256[] calldata tokenIds) external {
        require(!isPaused, "Contract is paused.");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];

            require(ownerOf(tokenId) == msg.sender, "You do not own this NFT");

            transferFrom(msg.sender, blackHole, tokenId);

            stakedNFTsArray.push(StakedNFT({
                owner: msg.sender,
                tokenId: tokenId,
                stakedTime: block.timestamp,
                redeemedTime: 0,
                blockNum: block.number
            }));

            userStakedNFTs[msg.sender].push(stakedNFTsArray.length - 1);
        }
    }

    function getUserStakedNFTs(address user) external view returns (uint256[] memory) {
        return userStakedNFTs[user];
    }

    function getStakedNFTInfo(uint256 stakeId) external view returns (StakedNFT memory) {
        require(stakeId < stakedNFTsArray.length, "Invalid stake ID");
        return stakedNFTsArray[stakeId];
    }

    function getStakedNFTsArrayLength() external view returns (uint256) {
        return stakedNFTsArray.length;
    }

    function getOwnedNFTs(address owner) external view returns (uint256[] memory) {
        return _ownedTokens[owner];
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = _ownedTokens[from].length - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        _ownedTokens[from].pop();
        delete _ownedTokensIndex[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override(ERC721, IERC721) {
        require(!isPaused, "Contract is paused.");
        
        super.transferFrom(from, to, tokenId);
        _removeTokenFromOwnerEnumeration(from, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function getMintRecordsByPage(uint256 page, uint256 pageSize) external view returns (MintRecord[] memory) {
        uint256 totalMinted = mintedTokenIds.length;
        uint256 start = page * pageSize;
        uint256 end = start + pageSize > totalMinted ? totalMinted : start + pageSize;
        require(start < totalMinted, "Page exceeds available records.");

        MintRecord[] memory records = new MintRecord[](end - start);
        for (uint256 i = start; i < end; i++) {
            records[i - start] = mintRecords[mintedTokenIds[i]];
        }
        return records;
    }

    function getMintedTokenIdsLength() external view returns (uint256) {
        return mintedTokenIds.length;
    }

}
