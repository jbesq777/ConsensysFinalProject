pragma solidity ^0.4.17;

contract MarketPlace {
struct user   {
        uint uid;
        address user;
        string username;
        string usertype;
        uint256 amount;
           }
enum userTypes { Admin, Owner, Shopper}

// define store entity
struct store{
        uint sid;
        address owner;
        string name;
        string description;
        uint256 amount;
 }
// define product entity
struct product {
        uint pid;
        uint sid;
        string name;
        string description;
        uint256 price;
        productStatus status;
                }
enum productStatus { Available, BackOrder}

struct storeproduct {
        uint spid;
        uint sid;
        uint pid;
        uint256 price;
        uint256 qty_avail;
              }          

struct order {
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

 user[] public users;
 store[] public stores;
 product[] public products;
 storeproduct[] public storeproducts;
 order[] public orders;

 
 

 modifier onlyAministrator (address sid) {
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
    event storeCreated(uint sid,   address owner,     string name,        string description,        uint256 amount);
    event userCreated(uint uid,    address user,  string username, string usertype,        uint256 amount,  uint timestamp);
    event productCreated(uint pid, string name, string description, uint256 price);
    event storeproductCreated(uint spid,   uint sid,     uint pid,    uint256 price,uint256 qty_avail );
    event orderCreated (uint oid, uint uid, uint sid, uint pid, uint256 price,uint256 qty);
  
       

    constructor() public {
    }

    function createUser( address _user,
                          string _username,
                          string _usertype,
                          uint256 _amount )
                           public returns (uint id)
    {
        
        id = users.length++;
        user storage newUser = users[id];
        newUser.user = _user;
        newUser.usertype = _usertype;
        newUser.username = _username;
        newUser.uid = id;
        newUser.amount = _amount;
        UserOwnerMap[newUser.user].push(id);

        emit userCreated(id, newUser.user , newUser.username , newUser.usertype ,   newUser.uid,    newUser.amount );

        return id;
    }
    
    function getUser(uint idx) public view returns (uint, address,  string, string,   uint256)
    {
        user memory temp = users[idx];
        return (temp.uid, temp.user, temp.username, temp.usertype,   temp.amount);
    }

     function getUserCount() public view returns (uint)
    {
        return users.length;
    }

    function createStore( address _owner, 
                          string _name,
						  string _description,
                          uint256 _amount )
                          public returns (uint id)
    {
        
        id = stores.length++;
        store storage newStore = stores[id];
        
        newStore.owner = _owner;
        newStore.sid= id;
		newStore.name = _name;
		newStore.description= _description;
        newStore.amount = _amount;
        StoreOwnerMap[newStore.owner].push(id);

        emit storeCreated(id, newStore.owner, newStore.name ,   newStore.description,    newStore.amount );

        return id;
    }
    
    function getStore(uint idx) public view returns (uint, address,  string, string,  uint256)
    {
        store memory temp = stores[idx];
        return (temp.sid, temp.owner, temp.name,  temp.description,   temp.amount);
    }
    function getStoreCount() public view returns (uint)
    {
        return stores.length;
    }
    function createProduct( string _name,
						            string _description,
                        uint256 _price )
                        public returns (uint id)
    {
        
        id = products.length++;
        product storage newProduct = products[id];
        
        newProduct.name = _name;
        newProduct.description = _description;
        newProduct.pid= id;
        newProduct.price = _price;
		newProduct.status = productStatus.Available;
       
        emit productCreated(id, newProduct.name , newProduct.description ,     newProduct.price );

        return id;
    }

    function getProductCount() public view returns (uint)
    {
        return products.length;
    }
    
    function getProduct(uint idx) public view returns ( string, string,  uint, uint256)
    {
        product memory temp = products[idx];
        return (temp.name, temp.description,  temp.pid,   temp.price);
    }

  function createStoreProduct( address _sowner,  uint _sid, uint _pid, uint256 _price,  uint256 _qty_avail)
                             public returns (uint id)
    {
        
        id = storeproducts.length++;
        storeproduct storage newStoreProduct = storeproducts[id];
        
        newStoreProduct.sid = _sid;
        newStoreProduct.pid = _pid;
        newStoreProduct.spid= id;
        newStoreProduct.price = _price;
		newStoreProduct.qty_avail = _qty_avail;
        ProductOwnerMap[_sowner].push(id);

        emit storeproductCreated(id, newStoreProduct.sid , newStoreProduct.pid ,   newStoreProduct.price,    newStoreProduct.qty_avail );

        return id;
    }
    
    function getStoreProduct(uint idx) public view returns ( uint,  uint,  uint, uint256  , uint256)
    {
        storeproduct memory temp = storeproducts[idx];
        return ( temp.spid, temp.sid,temp.pid,  temp.price,   temp.qty_avail);
    }  

    function getStoreProductCount() public view returns (uint)
    {
        return storeproducts.length;
    }

    function createOrder( address _sowner,  uint _uid , uint _sid, uint _pid, uint256 _price,  uint256 _qty)
                             public returns (uint id)
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

        emit orderCreated(id, newOrder.uid , newOrder.sid ,  newOrder.pid ,   newOrder.price,    newOrder.qty );

        return id;
    }
    
    function getOrder(uint idx) public view returns ( uint,  uint,  uint, uint, uint256  , uint256)
    {
        order memory temp = orders[idx];
        //  product name and description temp.pid 
        //  store info temp.sid 
        //  user info  temp.uid 

        return ( temp.uid, temp.oid, temp.sid, temp.pid,  temp.price,   temp.qty);
    } 

    function getOrderCount() public view returns (uint)
    {
        return orders.length;
    } 

    function sellProduct(uint pid, uint sid, uint qty) public view returns ( uint)
    {
      //getStoreProduct (_sid, _pid);
      // ensure we have at least 1 
      //createOrder( _sowner,   _uid ,  _sid,  _pid,  _price,   _qty)
      // decrease inventory by 1
      // decrease sellers wallet by price
      // increase store owners wallet by price
                             
    }                       
////////////////////

}