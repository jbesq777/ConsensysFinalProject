pragma solidity ^0.4.17;
//npm install -E openzeppelin-solidity
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract MarketPlace is Ownable {
   /** MarketPlace 
   The central marketplace is managed by a group of administrators.
    Admins allow store owners to add stores to the marketplace. 
    Store owners can manage their store’s inventory and funds.
    Shoppers can visit stores and purchase goods that are in stock using cryptocurrency */

   // Assigned at the construction
   // phase, where `msg.sender` is the account
   // creating this contract.
    using SafeMath for uint;
    uint public creationTime = now;

    address owner; /* Owner of contract */
    constructor() public
     {
    // Assigned at the construction
    // phase, create ADMIN user as the where `msg.sender` is the account
    // creating this contract.
    //
        owner = msg.sender;
        createUser(msg.sender, "Admin", 0, 0);
        emit log("owner = msg.sender");
    }

    modifier ownerRestricted {
        require(owner == msg.sender, "restricted feature");
        _;
        // the "_;"!  will
        // be replaced by the actual function
        // body when the modifier is used.
    } 

    function destroyContract() external ownerRestricted {
        selfdestruct(owner);
    }

    mapping (address => uint) balance;

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

    mapping(address => uint[]) public UserOwnerMap;
    mapping(address => uint[]) public StoreOwnerMap;
    mapping(address => uint[]) public ProductOwnerMap;
    mapping(uint => uint[]) public StoreProductMap;
    mapping(address => uint[]) public OrderOwnerMap;

    user[] public users;                    /* Array of user structures i.e. users */
    store[] public stores;                  /* Array of store structures i.e. stores */
    product[] public products;              /* Array of product structures i.e. products */
    storeproduct[] public storeproducts;    /* Array of product in a store */
    order[] public orders;                  /* Array of order of product in a store by a user */

    // onlyAdministrator
    modifier onlyAdministrator (address sid)
    {
    /*
        // if address not that of Administrator then  
        if (temp.userType != userTypes.Admin)
        {
            emit throwError("Error: user is not Admin !");            
            revert();
        }
    */
        _;
    }
    // list all of the events and what we need to know about them
    event throwError(string message);
    event log(string message);
    event userCreated(uint uid, address user, string username, uint8 usertype, uint256 amount, uint timestamp);
    event userUpdated(uint uid, string username, uint8 usertype, uint timestamp);
    event storeCreated(uint sid, address owner, string name, string description, uint256 amount, uint timestamp);
    event storeUpdated(uint sid, string name, string description, uint timestamp);
    event productCreated(uint pid, address owner, string name, string description, string imgsrc);
    event productUpdated(uint pid, string name, string description, string imgsrc, uint timestamp);
    event storeproductCreated(uint spid, uint sid, uint pid, uint256 price, uint256 qty_avail);
    event storeproductUpdated(uint spid, uint sid, uint pid, uint256 price, uint256 qty_avail, uint status, uint timestamp);
    event orderCreated (uint oid, uint uid, uint sid, uint pid, uint256 price,uint256 qty);
  
    // these functions facilitate the CRUD for the MArketPlace Bill of Materials
    // The BOM includes users: Admins and Store Owners
    //                  stores, products and orders

    function createUser( address _user, string _username, uint8 _usertype, uint256 _amount) public returns (uint id)
    {
        id = users.length++;
        user storage newUser = users[id];
        newUser.user = _user;
        newUser.usertype = userType(_usertype);
        newUser.username = _username;
        newUser.uid = id;
        newUser.amount = _amount;
        UserOwnerMap[newUser.user].push(id);
        emit userCreated(id, newUser.user, newUser.username, (uint8)(newUser.usertype), newUser.amount, now);
        return id;
    }

    function updateUser( uint _uid, string _username, uint8 _usertype)
        public returns (bool success)
    {
        /* Only allow changes to usertype */
        users[_uid].usertype = userType(_usertype);
        emit userUpdated(_uid, _username, (uint8)(_usertype), now);
        return true;
    }

    function getUser(uint idx) public view returns (uint, address, string, uint8, uint256)
    {
        user memory temp = users[idx];
        return (temp.uid, temp.user, temp.username, uint8(temp.usertype), temp.amount);
    }

    function getUserCount() public view returns (uint)
    {
        return users.length;
    }

    function createStore( address _owner, string _name, string _description, uint256 _amount ) public returns (uint id)
    {
        id = stores.length++;
        store storage newStore = stores[id];
        newStore.owner = _owner;
        newStore.sid = id;
        newStore.name = _name;
        newStore.description = _description;
        newStore.amount = _amount;
        StoreOwnerMap[newStore.owner].push(id);
        emit storeCreated(id, newStore.owner, newStore.name, newStore.description, newStore.amount, now);
        return id;
    }
    
    function updateStore( uint _sid, string _storename, string _storedescription)
        public returns (bool success)
    {
        /* Only allow changes to description */
        stores[_sid].description = _storedescription;
        emit storeUpdated(_sid, _storename, _storedescription, now);
        return true;
    }

    function getStore(uint idx) public view returns (uint, address, string, string, uint256)
    {
        store memory temp = stores[idx];
        return (temp.sid, temp.owner, temp.name, temp.description, temp.amount);
    }

    function getStoreCount() public view returns (uint)
    {
        return stores.length;
    }

    function getStoreForOwner(address _owner, uint idx) public view returns (uint, address, string, string, uint256)
    {
        if (getStoreCountForOwner(_owner) >= idx)
        {
            return getStore(StoreOwnerMap[_owner][idx]);
        }
        else
        {
            revert("store index does not exist for this owner!");
        }
    }

    function getStoreCountForOwner(address _owner) public view returns (uint)
    {
        return StoreOwnerMap[_owner].length;
    }

    function createProduct( address _owner, string _name, string _description, string _imgsrc ) public returns (uint id)
    {
        emit log("MarketPlace createProduct#1");
        id = products.length++;
        product storage newProduct = products[id];
        newProduct.pid = id;
        newProduct.owner = _owner;
        newProduct.name = _name;
        newProduct.description = _description;
        newProduct.imgsrc = _imgsrc;
        emit log("MarketPlace createProduct#2");
        ProductOwnerMap[newProduct.owner].push(id);
        emit productCreated(id, newProduct.owner, newProduct.name, newProduct.description, newProduct.imgsrc);
        emit log("MarketPlace createProduct#3");
        return id;
    }

    function updateProduct( uint _pid, string _name, string _description, string _imgsrc)
        public returns (bool success)
    {
        /* Only allow changes to description and imgsrc */
        products[_pid].description = _description;
        products[_pid].imgsrc = _imgsrc;
        emit productUpdated(_pid, _name, _description, _imgsrc, now);
        return true;
    }

    function getProduct(uint idx) public view returns ( uint, address, string, string, string )
    {
        product memory temp = products[idx];
        return (temp.pid, temp.owner, temp.name, temp.description, temp.imgsrc);
    }

    function getProductCount() public view returns (uint)
    {
        return products.length;
    }
    
    function getProductForOwner(address _owner, uint idx) public view returns ( uint, address, string, string, string )
    {
        if (getProductCountForOwner(_owner) >= idx)
        {
            return getProduct(ProductOwnerMap[_owner][idx]);
        }
        else
        {
            revert("product index does not exist for this owner!");
        }
    }

    function getProductCountForOwner(address _owner) public view returns (uint)
    {
        return ProductOwnerMap[_owner].length;
    }

    function createStoreProduct( uint _sid, uint _pid, uint256 _price, uint256 _qty_avail, uint8 _status) public returns (uint id)
    {
        id = storeproducts.length++;
        storeproduct storage newStoreProduct = storeproducts[id];
        newStoreProduct.sid = _sid;
        newStoreProduct.pid = _pid;
        newStoreProduct.spid = id;
        newStoreProduct.price = _price;
        newStoreProduct.qty_avail = _qty_avail;
        newStoreProduct.status = productStatus(_status);
        StoreProductMap[_sid].push(id);
        emit storeproductCreated(id, newStoreProduct.sid, newStoreProduct.pid, newStoreProduct.price, newStoreProduct.qty_avail);
        return id;
    }
    
    function updateStoreProduct( uint _spid, uint _sid, uint _pid, uint256 _price, uint256 _qty_avail, uint8 _status)
        public returns (bool success)
    {
        /* Only allow changes to price, qty_avail, and status */
        require(storeproducts[_spid].sid == _sid, "store id mismatch during updateStoreProduct()");
        require(storeproducts[_spid].pid == _pid, "product id mismatch during updateStoreProduct()");
        storeproducts[_spid].price = _price;
        storeproducts[_spid].qty_avail = _qty_avail;
        storeproducts[_spid].status = productStatus(_status);
        emit storeproductUpdated(_spid, _sid, _pid, _price, _qty_avail, (uint8)(_status), now);
        return true;
    }
    
    function getStoreProduct(uint idx) public view returns ( uint, uint, uint, uint256, uint256, uint8)
    {
        storeproduct memory temp = storeproducts[idx];
        return (temp.spid, temp.sid, temp.pid, temp.price, temp.qty_avail, uint8(temp.status));
    }  

    function getStoreProductCount() public view returns (uint)
    {
        return storeproducts.length;
    }

    // return the StoreProduct for the provided store and storeproduct index
    function getStoreProductForStore(uint _sid, uint _idx) public view returns ( uint, uint, uint, uint256, uint256, uint)
    {
        if (getStoreProductCountForStore(_sid) >= _idx)
        {
            return getStoreProduct(StoreProductMap[_sid][_idx]);
        }
        else
        {
            revert("store product index does not exist for this store!");
        }
    }  

    function getStoreProductCountForStore(uint _sid) public view returns (uint)
    {
        return StoreProductMap[_sid].length;
    }

    function createOrder( address _owner, uint _sid, uint _spid, uint _pid, uint256 _price, uint256 _qty) public returns (uint id)
    {
        log0("createOrder #1");
        id = orders.length++;
        log0("createOrder #2");
        order storage newOrder = orders[id];
        log0("createOrder #3");
        newOrder.sid = _sid;
        log0("createOrder #4");
        newOrder.spid = _spid;
        log0("createOrder #5");
        newOrder.pid = _pid;
        log0("createOrder #6");
        newOrder.oid = id;
        log0("createOrder #7");
        newOrder.price = _price;
        log0("createOrder #8");
        newOrder.qty = _qty;
        log0("createOrder #9");
        OrderOwnerMap[_owner].push(id);
        log0("createOrder #10");
        emit orderCreated(id, newOrder.sid, newOrder.spid, newOrder.pid, newOrder.price, newOrder.qty);
        log0("createOrder #11");
        return id;
    }
    
    function getOrder(uint idx) public view returns ( uint, uint, uint, uint, uint256, uint256)
    {
        order memory temp = orders[idx];
        return (temp.oid, temp.sid, temp.spid, temp.pid, temp.price, temp.qty);
    } 

    function getOrderCount() public view returns (uint)
    {
        return orders.length;
    } 

    function sellProduct(uint sid, uint spid, uint pid, uint qty) public payable returns (uint)
    {
        // ensure store product id is within array boundary 
        log0("sellProduct #1");
        require(spid >= 0 && spid <= storeproducts.length, "store product id does not exist");
        // get store product
        log0("sellProduct #2");
        storeproduct memory temp = storeproducts[spid];
        // ensure store id matches 
        log0("sellProduct #3");
        require (temp.sid == sid, "store id does not match");
        // ensure at least 1 available 
        log0("sellProduct #4");
        require (temp.qty_avail > 0, "insufficient inventory of store product");
        // calculate transaction amount
        log0("sellProduct #5");
        uint transAmount = qty * storeproducts[spid].price;
        // ensure buyer has sufficient funds 
        log0("sellProduct #6");
        require (balance[msg.sender] >= transAmount, "buyer has insufficient funds");
        // decrease inventory by 1
        log0("sellProduct #7");
        storeproducts[spid].qty_avail -= 1;
        // decrease buyers wallet by transaction amount
        log0("sellProduct #8");
        balance[msg.sender].sub(transAmount);
        // increase store amount by transaction amount
        log0("sellProduct #9");
        stores[sid].amount.add(transAmount);
        /**
        
    */
        // create the order
        log0("sellProduct #10");
        return createOrder(msg.sender, sid, spid, pid, temp.price, qty);
    }                       

    function withdraw(uint sid, uint256 amount) public payable returns (bool success)
    {
        // ensure message is from store owner
        require(stores[sid].owner == msg.sender, "must be owner of store");
        // ensure store has requested funds
        require(stores[sid].amount >= amount, "amount greater than store value");
        // decrease stores wallet by transaction amount
        stores[sid].amount.sub(amount);
        // increase callers wallet by transaction amount
        balance[msg.sender].add(amount);
        return true;
    }

    function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (_a == 0) {
            return 0;
        }

        c = _a * _b;
        assert(c / _a == _b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
        // assert(_b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = _a / _b;
        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
        return _a / _b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
        assert(_b <= _a);
        return _a - _b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
        c = _a + _b;
        assert(c >= _a);
        return c;
    }
}