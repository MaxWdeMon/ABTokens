pragma solidity ^0.5.0;

import "./Note.sol";
import "./DateCalc.sol";
import "./Waterfall.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";  
contract Deal is Ownable{
    DateCalc public dates = new DateCalc();
    address private auditor = 0x0;
    bool private isAudited = false;
    uint256 private startDate;
    uint256 private maturityDate;
    uint256 private lastChecked;
    uint256 private poolBalance;

    uint8 numberOfNotes = 0;
    Note[] private notes;
    uint256[] private balances;
    uint256[] private interestRates;
    uint256[] private interestDue;
    uint256[] private currentPayment;
    enum DealStage{Setup, Audit, Crowdsale, Active, Matured, Cleanup}
    DealStage private dealStage = DealStage.Setup;

    function addNote(uint8 newNoteLevel, uint256 balance, uint256 interestRate, Note n) public onlyOwner {
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

    function setAuditor(address _auditor) public ownerOnly{
        require(auditor == 0x0, "Auditor can only be set once");
        auditor = _auditor;
    }
    function confirmAuditCompleted() public{
        require(msg.sender == auditor, "Only the auditor can execute this functions");
        isAudited = true;
    }
    function crowdSaleCompleted() public returns(bool){
        ///TODO: Make sure the crowdsale for all notes has finished successfully
        return true;
    }
    function nextDealStage() public ownerOnly{
       if(dealStage == DealStage.Setup){
           require(auditor == 0x0, "Auditor must be set");
           require(numberOfNotes>0, "There must be at least one note setup in this deal before moving to the next stage");
           dealStage = DealStage.Audit;
       }else if(dealStage == DealStage.Audit){
           require(isAudited, "The audit of the code must be completed, before moving to the next stage");
           dealStage = DealStage.Crowdsale;
       }else if(dealStage == DealStage.Crowdsale){
           require(crowdSaleCompleted(), "Crowdsale for all notes has finished successfully, before moving to the next stage");
           dealStage = DealStage.Active;
        }else if(dealStage == DealStage.Active){
           require(poolBalance <= uint256(1), "The pool must have repaid or defaulted in full, befure the deal can mature");
           dealStage = DealStage.Matured;
           maturityDate = now;
       }else if(dealStage == DealStage.Matured){
           require(now > maturityDate + 31536000, "At least one year must have passed after the maturityDate to move the deal to Cleanup Stage");
           dealStage = DealStage.Cleanup;
       }
      }
      function cleanup() public payable{
          require(dealStage == DealStage.Cleanup, "The deal must be in cleanup stage to allow the selfdestruct function to be called");
          ///Please make sure that any other payment arrangements or procedures invovling this contract have been decommissioned, before executing the final cleanup.
          _owner.send(address(this).balance);
          selfdestruct(_owner);
      }
    }

}
