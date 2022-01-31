pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;
  YourToken yourToken;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }


  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    yourToken.transfer(msg.sender, msg.value*tokensPerEth);

    emit BuyTokens(msg.sender, msg.value, msg.value*tokensPerEth);
  }


  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "ETH withdrawal failed!");
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amountOfTokens) public {
    yourToken.transferFrom(msg.sender, address(this), amountOfTokens);

    (bool success, ) = msg.sender.call{value: amountOfTokens/tokensPerEth}("");
    require(success, "ETH withdrawal failed!");

    emit SellTokens(msg.sender, amountOfTokens, amountOfTokens/tokensPerEth);
  }

}
