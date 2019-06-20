pragma solidity ^0.5.0;

import "https://github.com/MaxWdeMon/ABTokens/solidity/Note.sol";
import "https://github.com/MaxWdeMon/ABTokens/solidity/DateCalc.sol";
import "https://github.com/MaxWdeMon/ABTokens/solidity/Waterfall.sol";

contract Deal{
    DateCalc public dates = new DateCalc();

    uint256 public startDate;
    uint256 public lastChecked;
    uint256 public poolBalance;

    uint8 numberOfNotes = 0;
    Note[] private notes;
    uint256[] public balances;
    uint256[] public interestRates;
    uint256[] public interestDue;
    uint256[] public currentPayment;
    enum DealStage{Setup, PreLaunch, Launch, Active, Mature, Cleanup}
    DealStage dealStage = DealStage.Setup;

    function addNote(uint8 newNoteLevel, uint256 balance, uint256 interestRate, Note n) public {
        require(dealStage == DealStage.Setup,
        "Notes can only be added during the deal setup stage. No later changes to the payments waterfall are possile.");
        require(numberOfNotes == newNoteLevel,
        "newNoteLevel variable is set incorrectly. It must equal the numberOfNotes currently in the deal.");
        notes.push(n);
        balances.push(balance);
        interestRates.push(interestRate);
        interestDue.push(0);
        currentPayment.push(0);
        numberOfNotes++;
    }

    function getNotes() public view returns(Note[] memory){
        return notes;
    }

    function setStartDate(uint256 _startDate) public{
        require(startDate == 0, "StartDate has already been set");
        require(dealStage == DealStage.Setup, "StartDate can only be set while the Deal is in Setup dealStage. ");
        startDate = _startDate;
        lastChecked = _startDate;
    }

    function updateInterestDue(int32 monthsAccrued, uint256 i) private {
        interestDue[i] += Waterfall.calculateInterest(monthsAccrued, balances[i], interestRates[i]);
    }

    function updateInterestsDue(uint256 date) public {
        require(date > lastChecked, "Interest can only be updated to a date after the current lastChecked date.");
        int32 monthsAccrued;
        (monthsAccrued, lastChecked) = dates.monthsSince(lastChecked, date);
        if(monthsAccrued > 0 ){
            for(uint256 i = 0; i < balances.length; i++){
                updateInterestDue(monthsAccrued, i);
            }
        }
    }

    function updateInterestsDue() public{
        updateInterestsDue(now);
    }

    function checkPaymentUpdater() public {
          // use 'Assert' to test the contract
          for(uint8 i = 1; i < 6; i++){
              updateInterestsDue(uint256(2700000) * uint256(i));
          }
    }

    function() external payable{
    }

    function payWaterfall(uint256 principal, uint256 totalReceipts, uint256 AUDxETH) public payable{
        require((totalReceipts * AUDxETH ) <= address(this).balance,
        "Current balance of the contract is insufficient to make the full payment. Please check the totalReceipts and AUDxETH variables and ensure enough Ether has been sent to the contract.");
        require(notes.length > 0, "There must be at least one note linked to the transaction before any payments can go out");
        uint256[] memory totalPayments;
        uint256[] memory principalPayments;
        updateInterestsDue();
        (totalPayments, principalPayments) = Waterfall.calculateWaterfall(principal, totalReceipts, balances, interestDue);
        for(uint8 i = 0 ; i < notes.length; i++){
            notes[i].pay.value(totalPayments[i] / AUDxETH).gas(70000)();
        }
        poolBalance -= principal;
    }

    function getBalances() public view returns(uint256[] memory){
        return balances;
    }
}
