// SPDX-License-Identifier: MIT
// This example code is designed to quickly deploy an example contract using Remix.
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {
    AggregatorV3Interface internal priceFeed;

    /**
        Set the address of the Chainlink aggregator address on whichever network you wish
        For example, the ETH/USD aggregator on Kovan has an address of "0x9326BFA02ADD2366b30bacB125260Af641031331"
        Input the address into setAggregatorAddress() and call get_prices()
     */
    function setAggregatorAddress(address _aggregatorAddress) public {
        priceFeed = AggregatorV3Interface(_aggregatorAddress);
    }

    /**
     * Returns the latest price
     */
    function get_prices() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
