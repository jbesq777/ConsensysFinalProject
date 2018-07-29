var web3;
var web3Provider;
var contract;
var MarketPlaceContract;
var MarketPlaceArtifact;
var accounts;
var account;
var Stores;
var currentBlockNumber;

function start()
{
    console.log("Starting the app");

    if (typeof web3 !== 'undefined') 
    {
      console.log("Connecting to Injected Metamask");
      web3Provider = web3.currentProvider;
      //web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');      
    } 
    else 
    {
      console.log("Connecting to Localhost port 8545");
      web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(web3Provider);

    $.getJSON('MarketPlace.json', function(data)
    {
      console.log("Getting MarketPlace contract file");
      MarketPlaceArtifact = data;
    }).then(getContract);
};

function getContract()
{
    console.log("Getting contract instance from network");
    contract = TruffleContract(MarketPlaceArtifact);
    contract.setProvider(web3Provider);
    web3.eth.getAccounts(function(err, accs)
    {
        if (err != null) 
        {
          alert("There was an error fetching your accounts.");
          return;
        }
        accounts = accs;
        console.log("Found accounts: ", accounts);
        // set accounts [0] as ADMIN
        account = accounts[0];
        console.log("Chosen account: ", account);

        contract.deployed().then(function(instance)
        {
          MarketPlaceContract = instance;
        }).then(callFunctions);
    });
};

function callFunctions()
{
    updateNetworkInfo();
    updateBlockNumber();
	watchEvents();
};

function createNewStore() 
{
    console.log("Creating new Store");
//	setStatus("Initiating Store, please wait.", "warning");
//    showSpinner();
    account = accounts[0];
	var storename = document.getElementById("storename").value;
	var storedescription = document.getElementById("storedescription").value;
	var amount = web3.toWei(parseFloat(document.getElementById("amount").value), "ether");
	
    
    console.log("New Store " + storename + " and storedescription is " + storedescription);
    
    
	MarketPlaceContract.createStore(account, storename, storedescription, amount ,  {from: account, gas:500000}).then(function(txId) 
	{
		console.log(txId);
        if (txId["receipt"]["gasUsed"] == 500000) 
        {
			setStatus("Store creation failed", "error");
			hideSpinner();
        }
        else
        {
		    setStatus("Store created in transaction: " + txId["tx"]);
		    hideSpinner();
		}
	});
};

function updateNetworkInfo()
{
    console.log("Updating network information");
    var address = document.getElementById("address");
    address.innerHTML = account;

    var ethBalance = document.getElementById("ethBalance");
    web3.eth.getBalance(account, function(err, bal)
    {
        ethBalance.innerHTML = web3.fromWei(bal, "ether") + " ETH";
    });

    var withdrawBalance = document.getElementById("withdrawBalance");

    if (typeof MarketPlaceContract != 'undefined' && typeof account != 'undefined')
    {
        web3.eth.getBalance(MarketPlaceContract.address, function(err, bal) 
        {
            console.log("contract balance: " + bal);
        });
 
    var network = document.getElementById("network");
    var provider = web3.version.getNetwork(function(err, net)
    {
        var networkDisplay;
        if(net == 1) 
        {
        networkDisplay = "Ethereum MainNet";
        }
        else if (net == 2)
        {
        networkDisplay = "Morden TestNet";
        }
        else if (net == 3)
        {
        networkDisplay = "Ropsten TestNet";
        }
        else
        {
        networkDisplay = net;
        }
        network.innerHTML = networkDisplay;
    });
}};

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
            console.log("Got an event: " + msg.event);
        }
    });
    var filter = web3.eth.filter("latest");
    filter.watch(function(err, block) {
        updateBlockNumber();
    });
};



function updateInfoBox(html) 
{
  var infoBox = document.getElementById("infoPanelText");
  infoBox.innerHTML = html;
};

function hideSpinner()
{
  $("#spinner").hide();
};

function showSpinner()
{
  $("#spinner").show();
};

function setStatus(message, category)
{
  var status = document.getElementById("statusMessage");
  status.innerHTML = message;
  var panel = $("#statusPanel");
  panel.removeClass("panel-warning");
  panel.removeClass("panel-danger");
  panel.removeClass("panel-success");

  if (category === "warning")
  {
    panel.addClass("panel-warning");
  }
  else if (category === "error")
  {
    panel.addClass("panel-danger");
  }
  else
  {
    panel.addClass("panel-success");
  }    
};

$(function() 
{
  $(window).load(function() 
  {
   start();
  });
});