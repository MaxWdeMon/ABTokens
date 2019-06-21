pragma solidity >=0.4.0 <0.6.0;

import "../Deal.sol";
import "../Note.sol";

contract DealProxy_tester is Deal{
    function setupTestNotes(uint8 numberOfNotes) public{
        for(uint8 i = 0; i < 5; i++){
              Note n = new Note();
              d.addNote(i, 1000000 * ( i + 1 ), 30 * ( i + 1 ), n);
        }
    }
    function getNotes() public returns(Notes){
        return notes;
    }

    function getBalances() public returns (uint256[] memory){
        return balances;
    }

    function getInterestRates() public returns (uint256[] memory){
        return interestRates;
    }

    function getInterestDue() public returns (uint256[] memory){
        return getInterestDue;
    }

    function getCurrentPayment() public returns (uint256[] memory){
        return currentPayment;
    }

    function getDealStage() public returns(DealStage){
        return dealStage;
    }

    function setDealStage(DealStage d) public{
        dealStage = d;
    }

}
