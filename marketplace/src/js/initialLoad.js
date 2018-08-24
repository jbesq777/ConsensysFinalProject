var web3;
var web3Provider;
var contract;
var MarketPlaceContract;
var MarketPlaceArtifact;
var accounts;
var account;
var stores;
var storesArray = [];
var products;
var productsArray = [];
var users;
var usersArray = [];
var currentBlockNumber;

function start()
{
    console.log("Starting the initialLoad");

    if (typeof web3 !== 'undefined') 
    {
      console.log("Connecting to Injected Metamask");
      web3Provider = web3.currentProvider;
    } 
    else 
    {
      console.log("Connecting to Localhost port 8545");
      web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(web3Provider);

    //$.getJSON('MarketPlace.json', function(data)
    //{
     // console.log("Getting MarketPlace contract file");
     // MarketPlaceArtifact = data;
    //}).then(getContract);
};

function getContract()
{
    console.log("Getting contract instance from network");
    contract = TruffleContract(MarketPlaceArtifact);
    contract.setProvider(web3Provider);
    var wea = web3.eth.accounts;
    web3.eth.getAccounts(function(err, accs)
    {
      if (err != null) 
      {
        alert("There was an error fetching your accounts.");
        return;
      }
      accounts = accs;
      console.log("Found accounts: ", accounts);
      account = accounts[0];
      console.log("Chosen account: ", account);

      contract.deployed().then(function(instance)
      {
        MarketPlaceContract = instance;
      }).then(callCommonFunctions);
    });
};

function callCommonFunctions()
{
  
  //updateBlockNumber();
  loadOwner();
  callFunctions();
};

function loadOwner()
{
  if (typeof MarketPlaceContract != 'undefined' && typeof account != 'undefined')
  {
    setStatus("Loading Owners...", "warning");
//
//var account = accounts[0];
  var username;
  var usertype;
  var useramt;

//$.getJSON('../owners.json', function(data) 
var data = require("../owners.json");{
      for (i = 0; i < data.length; i ++) {
        account = accounts[0];
        username = data[i].username;
        usertype =  data[i].usertype;
        useramt =  data[i].amount;
        MarketPlaceContract.createOwner			(account,username,usertype,useramt).then(function(txId)
    {
      setStatus("Withdraw finished.");
      
    });
  }
}

 }
};

function withdraw()
{
  if (typeof MarketPlaceContract != 'undefined' && typeof account != 'undefined')
  {
    setStatus("Withdrawing fund...", "warning");
   
    
    MarketPlaceContract.withdrawRefund({from:account, gas:500000}).then(function(txId)
    {
      setStatus("Withdraw finished.");
      
    });
  }
};


function updateBlockNumber()
{
  web3.eth.getBlockNumber(function(err, blockNumber)
  {
    currentBlockNumber = blockNumber;
    console.log("Current block number is: " + blockNumber);
  });
};

function watchEvents()
{
  var events = MarketPlaceContract.allEvents();
  events.watch(function(err, msg)
  {
    if(err)
    {
        console.log("Error: " + err);
    }
    else
    {
        if (msg.event == "log")
        {
          console.log("Event: " + msg.event+" - "+msg.args.message);
        }
        else 
        {
          console.log("Event: " + msg.event);
        }
    }
  });
  var filter = web3.eth.filter("latest");
  filter.watch(function(err, block) {
      updateBlockNumber();
  });
};


function getContractOwner()
{
  console.log("Getting contract owner...");
  MarketPlaceContract.getOwner.call().then(function(address)
  {
    return address;
  });
};