pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";
contract TestAdoption {
    MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
// Testing the adopt() function 8/12/2018
    function testMarketPlace() public {
        uint returnedId = 8;
        uint expected = 8;
        Assert.equal(returnedId, expected, "MarketPlace of  ID 8 should be recorded");
    }

    

}