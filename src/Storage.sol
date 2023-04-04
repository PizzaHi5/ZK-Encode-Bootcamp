// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;



/**
    https://github.com/NethermindEth/warp
    Following this repo, this contract is used in warp to generate a cairo smart contract
    and then the abi file of the cairo smart contract using warp. Look at warp/warp_output/
    


 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Storage {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}