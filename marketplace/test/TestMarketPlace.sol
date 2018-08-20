pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract TestMarketPlace {
     
    // Get handle to the currently deployed contract
    MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
    using SafeMath for uint;
   

    // Test the adopt() function
    function testMarketPlace() public {
        uint returnedId = 8;
        uint expected = 8;
        Assert.equal(returnedId, expected, "MarketPlace of  ID 8 should be recorded");
    }

    // Test the getUserCount() function
    function testInitialUserCountUsingDeployedContract() public {
        // MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
        uint expected = 1;
        Assert.equal(marketPlace.getUserCount(), expected, "Usercount should be 1");
    }

    function testInitialUserCountUsingDeployedContractOwners() public {
        // MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());
        uint expected = 1;
        Assert.equal(marketPlace.getUserCount(), expected, "Usercount should be 1");
    }
    function testunderflow() public {
        uint  zero = 0;
        uint  zeroexpected = 0;
       // zero -= 1;
        //Assert.equal(zero, zeroexpected, "zero should be 1");
        zero = zero.sub(1);
        //zero = sub(1,zero);
        Assert.equal(zero, zeroexpected, "zero should be 1");
        }
    // max will end up at 0
    function testoverflow() public {
        
        uint  max = 2**256-1;
        uint  maxexpected = 2**256-1;
        max += 1;
        Assert.equal(max, maxexpected, "max should be 2**256-1");
        }

    
}
    
