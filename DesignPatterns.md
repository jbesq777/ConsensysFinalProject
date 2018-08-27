** ConsenSys Academy&#39;s 2018 Developer Design Patterns**

The marketplace application considered and used a number of Ethereum design patterns. We will list them in detail below.

**Contract Self Destruction**

Marketplace uses the **Contract Self Destruction pattern for** terminating the Marketplace contract, This means removing it  **forever**  from the blockchain. Once destroyed, it&#39;s not possible to invoke functions on the contract and no transactions will be logged in the ledger. Solidity&#39;s selfdestruct does two things.

1. It renders the contract useless, effectively deleting the bytecode at that address.
2. It sends all the contract&#39;s funds to a target address which in this case is the owner.

The function destroyContract() is responsible for the destruction.

function destroyContract() external ownerRestricted {

        selfdestruct(owner);

    }

The ownerRestricted modifier was used to only allow the owner of the contract to destroy it and have all of the funds transferred to the Owners account.

The Contract Self Destruction pattern is used for terminating a contract, which means removing it forever from the blockchain. Once destroyed, it&#39;s not possible to invoke functions on the contract and no transactions will be logged in the ledger. This pattern is used for things like dealing with timed contracts or contracts that must be terminated once a milestone has been reached. Here are important noted  when dealing with a contract that has been destroyed:

- Transactions will fail
- Any funds sent to the contract will be lost

The modifier was used , to only allow the owner of the contract to destroy it

**Restricting Access**

Restricting access is a common pattern for contracts. MarketPlace restricts read access to your contract&#39;s state by other contracts. That is actually the default unless you declare make your state variables public. Marketplace uses function modifiers to make these restrictions highly readable.