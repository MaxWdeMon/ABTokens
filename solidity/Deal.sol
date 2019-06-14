pragma solidity ^0.5.0;

import "./Note.sol";
import "./DateCalc.sol";
import "./Waterfall.sol";

contract Deal{
    DateCalc public dates = new DateCalc();
    uint256 public startDate;
    uint256 public lastChecked;
    Note[] public notes;
    uint256 public poolBalance;
    uint256[] public balance;
    uint256[] public interestRate;
    uint256[] public interestDue;
    uint256[] public currentPayment;
    
  
    
    constructor(uint256[] memory balances, uint256[] memory rates) public{
        require(balances.length == rates.length);
        balance = balances;
        interestRate = rates;
        
        interestDue = new uint256[](rates.length);
        currentPayment = new uint256[](rates.length);
    }
    
    function addNote(address[] memory beneficiaries, uint256[] memory shares) public {
        require(balance.length>notes.length);
        notes.push(new Note());
    }
    
    function updateInterestsDue() public{
        updateInterestsDue(now);
    }
    
    function getNotes() public view returns(Note[] memory){
        return notes;
    }
    
    function updateInterestsDue(uint256 date) public {
        int32 monthsAccrued;
        (monthsAccrued, lastChecked) = dates.monthsSince(lastChecked, date);
        if(monthsAccrued > 0 ){
            for(uint256 i=0;i< balance.length;i++){
                updateInterestDue(monthsAccrued, i);
            }
        }
    }
    
    function updateInterestDue(int32 monthsAccrued, uint256 i) private {
            interestDue[i] += Waterfall.calculateInterest(monthsAccrued, balance[i], interestRate[i]);
    }
    
    function() external payable{
        
    }
    
    function payWaterfall(uint256 principal, uint256 totalReceipts, uint256 AUDxETH) public payable{
        require(totalReceipts <= address(this).balance);
        require(notes.length > 0 );
        uint256[] memory totalPayments; 
        uint256[] memory principalPayments;
        updateInterestsDue();
        (totalPayments, principalPayments) = Waterfall.calculateWaterfall(principal, totalReceipts, balance, interestDue);
        for(uint8 i = 0 ; i < notes.length; i++){
            notes[i].pay.value(totalPayments[i] / AUDxETH).gas(70000)();
        }
        poolBalance -= principal;
    } 
    
    
    function getBalances() public view returns(uint256[] memory){
        return balance;
    }
  
}
