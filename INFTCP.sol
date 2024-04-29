/*
 ██╗███████╗████████╗    ██╗███╗   ███╗██████╗  █████╗  ██████╗████████╗███╗   ██╗███████╗████████╗    
███║██╔════╝╚══██╔══╝    ██║████╗ ████║██╔══██╗██╔══██╗██╔════╝╚══██╔══╝████╗  ██║██╔════╝╚══██╔══╝    
╚██║███████╗   ██║       ██║██╔████╔██║██████╔╝███████║██║        ██║   ██╔██╗ ██║█████╗     ██║       
 ██║╚════██║   ██║       ██║██║╚██╔╝██║██╔═══╝ ██╔══██║██║        ██║   ██║╚██╗██║██╔══╝     ██║       
 ██║███████║   ██║       ██║██║ ╚═╝ ██║██║     ██║  ██║╚██████╗   ██║   ██║ ╚████║██║        ██║       
 ╚═╝╚══════╝   ╚═╝       ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝  ╚═══╝╚═╝        ╚═╝       
                                                                                                           
 ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗                           
██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║                           
██║     ██║   ██║██║     ██║     █████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██║                           
██║     ██║   ██║██║     ██║     ██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██║                           
╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║                           
 ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝                           
                                                                                                           
 ██████╗██╗     ███████╗ █████╗ ███╗   ██╗    ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗ ██████╗  █████╗ ███╗   ██╗
██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║    ██╔══██╗██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔══██╗████╗  ██║
██║     ██║     █████╗  ███████║██╔██╗ ██║    ██████╔╝███████║███████║██╔██╗ ██║██║  ███╗███████║██╔██╗ ██║
██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║    ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══██║██║╚██╗██║
╚██████╗███████╗███████╗██║  ██║██║ ╚████║    ██║     ██║  ██║██║  ██║██║ ╚████║╚██████╔╝██║  ██║██║ ╚████║
 ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
                                                                                                           */
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract INFTCP is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;

    address constant CFADDRESS = 0xBC46CA274330EC2c83516dB5592b14c8724854B6; // 70% - Clean Phangan
    address constant ESADDRESS = 0x7380A42137D16a0E7684578d8b3d32e1fbD021B5; // 10% - EcoSynthesisX
    address constant PQADDRESS = 0x2Ba9B6D9d8BD407788E1747Ce5eB0aAC42171700; // 10% - Phangan QF
    address constant RPADDRESS = 0xa8258ED271BB9be9d7E16c5818E45eF6F2577d92; //  5% - ReFi Phangan
    address constant GPADDRESS = 0x4A5599597c0b30742163933A2e7B0F91AdD87fD6; //  5% - GreenPill Phangan

    string private BASE_URI;

    uint256 public C_PRICE = 0.007 ether;
    uint256 public R_PRICE = 0.015 ether;
    uint256 public L_PRICE = 0.025 ether;

    uint256 public SALE_STEP = 0;

    uint256 public L_INDEX = 1;
    uint256 public R_INDEX = 51;
    uint256 public C_INDEX = 201;
    uint256 private L_MAX_INDEX = 50;
    uint256 private R_MAX_INDEX = 200;
    uint256 public MAX_SUPPLY = 500;

    constructor() ERC721("1st ImpactNFT Collection Clean Phangan", "$INFTCP") Ownable(msg.sender) {}

    //************* MINT *************

    function mintLegendary(uint256 _mintAmount) external payable {
        require(SALE_STEP >= 1, "Mint is not opened");
        require(L_INDEX + _mintAmount <= L_MAX_INDEX + 1, "Exceeds Max Legendary Supply");
        require(L_PRICE * _mintAmount <= msg.value, "ETH not enough");
        _mintLoopLegendary(msg.sender, _mintAmount);
        withdraw();
    }

    function mintRare(uint256 _mintAmount) external payable {
        require(SALE_STEP >= 1, "Mint is not opened");
        require(R_INDEX + _mintAmount <= R_MAX_INDEX + 1, "Exceeds Max Rare Supply");
        require(R_PRICE * _mintAmount <= msg.value, "ETH not enough");
        _mintLoopRare(msg.sender, _mintAmount);
        withdraw();
    }

    function mintCommon(uint256 _mintAmount) external payable {
        require(SALE_STEP >= 1, "Mint is not opened");
        require(C_INDEX + _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Common Supply");
        require(C_PRICE * _mintAmount <= msg.value, "ETH not enough");
        _mintLoopCommon(msg.sender, _mintAmount);
        withdraw();
    }

    function _mintLoopLegendary(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_receiver, L_INDEX + i);
        }
        L_INDEX += _mintAmount;
    }

    function _mintLoopRare(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_receiver, R_INDEX + i);
        }
        R_INDEX += _mintAmount;
    }

    function _mintLoopCommon(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_receiver, C_INDEX + i);
        }
        C_INDEX += _mintAmount;
    }

    //************* VIEWS *************
    
    function _baseURI() internal view virtual override returns (string memory) {
        return BASE_URI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
    }

    //************* ADMIN *************

    function airdropLegendary(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
        require(L_INDEX + _airdropAddresses.length * _mintAmount <= L_MAX_INDEX + 1, "Exceeds Max Legendary Supply");

        for (uint256 i = 0; i < _airdropAddresses.length; i++) {
            address to = _airdropAddresses[i];
            _mintLoopLegendary(to, _mintAmount);
        }
    }  

    function airdropRare(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
        require(R_INDEX + _airdropAddresses.length * _mintAmount <= R_MAX_INDEX + 1, "Exceeds Max Rare Supply");

        for (uint256 i = 0; i < _airdropAddresses.length; i++) {
            address to = _airdropAddresses[i];
            _mintLoopRare(to, _mintAmount);
        }
    }

    function airdropCommon(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
        require(C_INDEX + _airdropAddresses.length * _mintAmount <= MAX_SUPPLY + 1, "Exceeds Max Common Supply");

        for (uint256 i = 0; i < _airdropAddresses.length; i++) {
            address to = _airdropAddresses[i];
            _mintLoopCommon(to, _mintAmount);
        }
    }

    function setCPRICE(uint256 _newCprice) external onlyOwner {
        C_PRICE = _newCprice;
    }

    function setRPRICE(uint256 _newRprice) external onlyOwner {
        R_PRICE = _newRprice;
    }

    function setLPRICE(uint256 _newLprice) external onlyOwner {
        L_PRICE = _newLprice;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        BASE_URI = _newBaseURI;
    }

    function pause() external onlyOwner {
        SALE_STEP = 0;
    }

    function openMint() external onlyOwner {
        SALE_STEP = 1;
    }

    //************* WITHDRAW *************

    function withdraw() internal {
        uint256 curBalance = address(this).balance;
        require(curBalance > 0, "Nothing to withdraw");
        bool success;
        (success, ) = payable(CFADDRESS).call{value: curBalance * 70 / 100}('1 Transaction Unsuccessful');
        require(success);
        (success, ) = payable(ESADDRESS).call{value: curBalance * 10 / 100}('2 Transaction Unsuccessful');
        require(success);
        (success, ) = payable(PQADDRESS).call{value: curBalance * 10 / 100}('3 Transaction Unsuccessful');
        require(success);
        (success, ) = payable(RPADDRESS).call{value: curBalance * 5 / 100}('4 Transaction Unsuccessful');
        require(success);
        (success, ) = payable(GPADDRESS).call{value: curBalance * 5 / 100}('5 Transaction Unsuccessful');
        require(success);
    }

    function clearstuckEth() external onlyOwner nonReentrant {
        uint256 curBalance = address(this).balance;
        require(curBalance > 0, "Nothing to withdraw");
        bool success;
        (success, ) = payable(owner()).call{value: curBalance}('Transaction Unsuccessful');
        require(success);
    }
}