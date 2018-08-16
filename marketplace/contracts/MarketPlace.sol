pragma solidity ^0.4.17;

contract MarketPlace {

    address owner; /* Owner of contract */

    modifier ownerRestricted {
      require(owner == msg.sender);
      _;
   } 

    constructor() public
     {
         owner = msg.sender;
         createUser( msg.sender, "Admin", 0,1);
         emit log("owner = msg.sender");
     }

    function destroyContract() ownerRestricted {
     selfdestruct(owner);
   }

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
        uint uid;
        uint sid;
        uint pid;
        uint256 price;
        uint256 qty;
    }    

    mapping(address => uint[]) public UserOwnerMap;
    mapping(address => uint[]) public StoreOwnerMap;
    mapping(address => uint[]) public ProductOwnerMap;

    user[] public users;                    /* Array of user structures i.e. users */
    store[] public stores;                  /* Array of store structures i.e. stores */
    product[] public products;              /* Array of product structures i.e. products */
    storeproduct[] public storeproducts;    /* Array of product in a store */
    order[] public orders;                  /* Array of order of product in a store by a user */

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

    event throwError(string message);
    event log(string message);
    event userCreated(uint uid, address user, string username, uint8 usertype, uint256 amount, uint timestamp);
    event userUpdated(uint uid, string username, uint8 usertype, uint timestamp);
    event storeCreated(uint sid, address owner, string name, string description, uint256 amount, uint timestamp);
    event storeUpdated(uint sid, string name, string description, uint timestamp);
    event productCreated(uint pid, address owner, string name, string description, string imgsrc);
    event productUpdated(uint pid, string name, string description, string imgsrc, uint timestamp);
    event storeproductCreated(uint spid, uint sid, uint pid, uint256 price,uint256 qty_avail);
    event orderCreated (uint oid, uint uid, uint sid, uint pid, uint256 price,uint256 qty);
  
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
    
    function createStoreProduct( address _sowner, uint _sid, uint _pid, uint256 _price, uint256 _qty_avail) public returns (uint id)
    {
        id = storeproducts.length++;
        storeproduct storage newStoreProduct = storeproducts[id];
        newStoreProduct.sid = _sid;
        newStoreProduct.pid = _pid;
        newStoreProduct.spid = id;
        newStoreProduct.price = _price;
        newStoreProduct.qty_avail = _qty_avail;
        ProductOwnerMap[_sowner].push(id);
        emit storeproductCreated(id, newStoreProduct.sid, newStoreProduct.pid, newStoreProduct.price, newStoreProduct.qty_avail);
        return id;
    }
    
    function getStoreProduct(uint idx) public view returns ( uint, uint, uint, uint256, uint256)
    {
        storeproduct memory temp = storeproducts[idx];
        return (temp.spid, temp.sid,temp.pid, temp.price, temp.qty_avail);
    }  

    function getStoreProductCount() public view returns (uint)
    {
        return storeproducts.length;
    }

    function createOrder( address _sowner, uint _uid, uint _sid, uint _pid, uint256 _price, uint256 _qty) public returns (uint id)
    {
        id = orders.length++;
        order storage newOrder = orders[id];
        newOrder.uid = _uid;
        newOrder.sid = _sid;
        newOrder.pid = _pid;
        newOrder.oid = id;
        newOrder.price = _price;
        newOrder.qty = _qty;
        ProductOwnerMap[_sowner].push(id);
        emit orderCreated(id, newOrder.uid, newOrder.sid, newOrder.pid, newOrder.price, newOrder.qty);
        return id;
    }
    
    function getOrder(uint idx) public view returns ( uint, uint, uint, uint, uint256, uint256)
    {
        order memory temp = orders[idx];
        //  product name and description temp.pid 
        //  store info temp.sid 
        //  user info  temp.uid 
        return (temp.uid, temp.oid, temp.sid, temp.pid, temp.price, temp.qty);
    } 

    function getOrderCount() public view returns (uint)
    {
        return orders.length;
    } 

    // function sellProduct(uint pid, uint sid, uint qty) public view returns ( uint)
    // {
    //   //getStoreProduct (_sid, _pid);
    //   // ensure we have at least 1 
    //   //createOrder( _sowner, _uid , _sid, _pid, _price, _qty)
    //   // decrease inventory by 1
    //   // decrease sellers wallet by price
    //   // increase store owners wallet by price
    // }                       

}