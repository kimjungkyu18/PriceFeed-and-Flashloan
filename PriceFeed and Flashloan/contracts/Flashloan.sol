pragma solidity ^0.6.6;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";
import "./PriceFeed.sol";

contract Flashloan is FlashLoanReceiverBase {
    // Address of kovan testnet DAI token
    address daiAddr = 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD;
    int256 prices;

    PriceFeed priceFeedInstance;

    constructor(address _addressProvider)
        public
        FlashLoanReceiverBase(_addressProvider)
    {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    ) external override {
        require(
            _amount <= getBalanceInternal(address(this), _reserve),
            "Invalid balance, was the flashLoan successful?"
        );

        // This is where money making logic goes (arbitrage, etc.)
        // For the purpose of this assessment nothing will be done here
        // Funds to cover the lending fees of the flashloan must be deposited to THIS contract

        uint256 totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 100 ether worth of `_asset`
        In this case, it is testnet DAI and the DAI address is hardcoded rather than set as an argument
     */
    function flashloan() public onlyOwner {
        bytes memory data = "";
        uint256 amount = 100 ether;

        ILendingPool lendingPool = ILendingPool(
            addressesProvider.getLendingPool()
        );
        lendingPool.flashLoan(address(this), daiAddr, amount, data);
    }

    // Set the address of the deployed PriceFeed contract so that we can call its get_prices function
    function setPriceFeedAddress(address _address) public {
        priceFeedInstance = PriceFeed(_address);
    }

    // Aggregator address must already be set in PriceFeed contract
    function get_prices(string memory _conversion) public returns (int256) {
        prices = priceFeedInstance.get_prices();
        return prices;
    }
}
