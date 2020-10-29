pragma solidity >=0.4.0 <0.6.0;

import "../Deal.sol";
import "../Note.sol";

contract DealProxy_tester is Deal{

    function setupTestNotes(uint8 numberOfNotes) public{
        for(uint8 i = 0; i < numberOfNotes; i++){
             createTestNote(i);
        }
    }
 
    function goToActiveStage() public{
        if(notes.length == 0){
            setupTestNotes(5);
        }
        setStartDate(1);
        setAuditor(address(msg.sender));
        nextDealStage(); //go to audit
        confirmAuditCompleted();
        nextDealStage(); //go to crowdsale
        nextDealStage(); //go to active
    }

    function createTestNote(uint8 i) public{
        Note n = new Note();
        addNote(i, 1000000 * ( i + 1 ), 30 * ( i + 1 ), n);
    }

    function getNotes() public view returns(Note[] memory){
        return notes;
    }

    function getBalances() public view returns (uint256[] memory){
        return balances;
    }

    function getInterestRates() public view returns (uint256[] memory){
        return interestRates;
    }

    function getInterestDue() public returns (uint256[] memory){
        return interestDue;
    }

    function getCurrentPayment() public view returns (uint256[] memory){
        return currentPayment;
    }

    function getDealStage() public view returns(DealStage){
        return dealStage;
    }

    function setDealStage(DealStage d) public{
        dealStage = d;
    }

}
