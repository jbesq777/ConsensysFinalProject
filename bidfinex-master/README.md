# bidfinex
A decentralised marketplace on Ethereum blockchain

### How to install
    Clone this git repository https://github.com/madhukar01/bidfinex/

    Install Ganache from http://truffleframework.com/ganache/

    Install Metamask browser extension from https://metamask.io/

    Install Node.js v8.11 from from https://nodejs.org/en/


### After installing Node.js run these commands inside bidfinex directory:

    npm install     //Installs the dependencies from package.json

    npm install -g truffle      //Installs Truffle framework http://truffleframework.com

    truffle version     //This should return Truffle version and Solc version after successful install


    //Start Ganache client and change port number to 8545 in settings (Or change it in truffle.js configuration file)

    truffle compile     //Compiles .sol contract files into .json 

    truffle migrate     //Deploys the contracts onto blockchain

    npm run dev     //Runs the server locally and opens the webpage in the browser


You can deploy this on public ethereum network as well, you just have to change network configuration in truffle.js 

#### Note: Running "truffle" command might open the file truffle.js (on windows), in that case use "truffle.cmd" instead
C:\MyDocs\UCNY\BlockChain\ConsensysAcademy\bidfinex-master>truffle compile
Compiling .\contracts\Migrations.sol...
Compiling .\contracts\bidfinex.sol...
Writing artifacts to .\build\contracts


C:\MyDocs\UCNY\BlockChain\ConsensysAcademy\bidfinex-master>truffle migrate
Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0xfb827a196761c85ab596a7ecada259959af67fbfb082bafb017a332755ee5f03
  Migrations: 0xa61d1f3861443b538bf30eb0c0e44ea8910088b0
Saving successful migration to network...
  ... 0x0fbfee6e8a18a60d683ae1180c399d9327503a7908debb0468f0872ab567a267
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying bidfinex...
  ... 0x9f02ecf7ab11c423c8d2d8eb2a1d518076ef23290c021dc2f528a7a2aa1223d5
  bidfinex: 0xadada3e39060a6080e0da824978410363b57e235
Saving successful migration to network...
  ... 0x547f61aa104666368198bc4d872cf9de30f98be5d3e385aef40bd9ac42d5cd3a
Saving artifacts...

C:\MyDocs\UCNY\BlockChain\ConsensysAcademy\bidfinex-master>npm run dev

> bidfinex@0.8.0 dev C:\MyDocs\UCNY\BlockChain\ConsensysAcademy\bidfinex-master
> lite-server

** browser-sync config **
{ injectChanges: false,
  files: [ './**/*.{html,htm,css,js}' ],
  watchOptions: { ignored: 'node_modules' },
  server:
   { baseDir: [ './src', './build/contracts' ],
     middleware: [ [Function], [Function] ] } }
[Browsersync] Access URLs:
 --------------------------------------
       Local: http://localhost:3000
    External: http://169.254.30.99:3000
 --------------------------------------
          UI: http://localhost:3001
 UI External: http://169.254.30.99:3001
 --------------------------------------
[Browsersync] Serving files from: ./src
[Browsersync] Serving files from: ./build/contracts
[Browsersync] Watching files...
18.07.18 21:02:33 200 GET /index.html