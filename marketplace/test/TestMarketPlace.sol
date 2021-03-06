pragma solidity ^0.4.17;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";
contract TestMarketPlace {

    // Structure for a user
    struct user
    {
        uint uid;
        address user;
        string username;
        userType usertype;
        uint256 amount;
    }
    enum userType {Admin, Owner, Shopper}

    // define store entity
    struct store
    {
        uint sid;
        address owner;
        string name;
        string description;
        uint256 amount;
    }

    // define product entity
    struct product
    {
        uint pid;
        address owner;
        string name;
        string description;
        string imgsrc;
    }

    struct storeproduct
    {
        uint spid;
        uint sid;
        uint pid;
        uint256 price;
        uint256 qty_avail;
        productStatus status;
    }          
    enum productStatus { Available, BackOrder}

    struct order
    {
        uint oid;
        // uint uid;
        uint sid;
        uint spid;
        uint pid;
        uint256 price;
        uint256 qty;
    }    

    // Get handle to the currently deployed contract
    MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

    // Test the getUserCount() function
    function testInitialUserCountUsingDeployedContract() public {
        // At deployment the contract creates an admin user for the contract owner
        uint expected = 1;
        Assert.equal(marketPlace.getUserCount(), expected, "Usercount should be 1");
    }

    // Test the createStore() function
    function testCreateStore() public {
        address _owner = marketPlace.owner();
        string memory _name = "Banana Democracy";
        string memory _description = "Mid-level clothing store";
        uint256 _amount = 10;
        uint sid = marketPlace.createStore(_owner, _name, _description, _amount);
        Assert.equal(marketPlace.getStoreCount(), sid+1, "store id count did not increment");
        // store memory temp = marketPlace.getStore(sid);
        // Assert.equal(temp.sid, sid, "store id not matching");
        // Assert.equal(temp.owner, _owner, "store owner not matching");
        // Assert.equal(temp.name, _name, "store name not matching");
        // Assert.equal(temp.description, _description, "store description not matching");
        // Assert.equal(temp.amount, _amount, "store amount not matching");
    }

    // Test the createProduct() function
    function testCreateProduct() public {
        address _owner = marketPlace.owner();
        string memory _name = "Levi";
        string memory _description = "501 Jean";
        string memory _imgsrc = "images/levi-jeans-501.png";
        uint pid = marketPlace.createProduct(_owner, _name, _description, _imgsrc);
        Assert.equal(marketPlace.getProductCount(), pid+1, "product id count did not increment");
        // product _product = marketPlace.getProduct(pid);
        // Assert.equal(_product.pid, pid, "product id not matching");
        // Assert.equal(_product.owner, _owner, "product owner not matching");
        // Assert.equal(_product.name, _name, "product name not matching");
        // Assert.equal(_product.description, _description, "product description not matching");
        // Assert.equal(_product.imgsrc, _imgsrc, "product amount not matching");
    }

    // Test the createStoreProduct() function
    function testCreateStoreProduct() public {
        uint id = 0;
        Assert.equal(marketPlace.getStoreCount(), id+1, "store id count did not increment");
        Assert.equal(marketPlace.getProductCount(), id+1, "product id count did not increment");
        uint sid = 0;
        uint pid = 0;
        uint256 price = 1;
        uint256 qty_avail = 100;
        uint8 status = 0;
        uint spid = marketPlace.createStoreProduct(sid, pid, price, qty_avail, status);
        Assert.equal(marketPlace.getStoreProductCount(), spid+1, "store product id count did not increment");
    }

    // Test the sellProduct() function
    function testSellProduct() public {
        uint id = 0;
        Assert.equal(marketPlace.getStoreCount(), id+1, "store id count did not increment");
        Assert.equal(marketPlace.getProductCount(), id+1, "product id count did not increment");
        Assert.equal(marketPlace.getStoreProductCount(), id+1, "store product id count did not increment");
        uint sid = 0;
        uint pid = 0;
        uint spid = 0;
        uint256 qty = 1;
        uint oid = marketPlace.sellProduct(sid, spid, pid, qty);
        Assert.equal(marketPlace.getOrderCount(), oid+1, "order id count did not increment");
    }

    // Test the withdraw() function
    function testWithdraw() public {
        uint sid = 0;
        Assert.equal(marketPlace.getStoreCount(), sid+1, "store id count did not increment");
        uint256 amount = 1;
        bool result = marketPlace.withdraw(sid, amount);
        bool expected = true;
        Assert.equal(result, expected, "withdrawal was unsuccessful");
    }

}