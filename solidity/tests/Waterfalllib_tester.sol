pragma solidity >=0.4.0 <0.6.0;
import "./Waterfall.sol";
import "./DateCalc.sol";

contract Waterfalllib_tester{
    function caluculateMonthlyInterestDue(uint256 balance, uint256 monthlyRateBPS) public pure returns(uint256){
        return Waterfall.caluculateMonthlyInterestDue(balance, monthlyRateBPS);
    }

    function calculateInterest(int32 months,  uint256 balance, uint256 monthlyRateBPS) public pure returns(uint256){
        return Waterfall.calculateInterest(months, balance, monthlyRateBPS) ;
    }
    function calculateInterest(int32 months,  uint256[] memory balance, uint256[] memory monthlyRateBPS) public pure returns(uint256[] memory){
        return Waterfall.calculateInterest( months, balance, monthlyRateBPS);
    }
    
     function calculateWaterfall(uint256 principal, uint256 totalReceipts, uint256[] memory balance, uint256[] memory interestDue) public pure returns (uint256[] memory, uint256[] memory){
        return Waterfall.calculateWaterfall(principal, totalReceipts, balance, interestDue);
    }
    function testInterest() public pure returns (uint256){
        return caluculateMonthlyInterestDue(1 ether,1);
    }
    
    function testMultiTrancheInterest() public returns (uint256[] memory){
        uint256[5] memory interestPayments =  [uint256(12),60,122,262,391];
        int32 months = 12; 
        uint256[5] memory initBal =  [uint256(10000),5000,1000,1000,500];
        uint256[5] memory intRate =  [uint256(1),10,100,200,500];
        
        uint256[] memory initialBalances = new uint256[](5);
        uint256[] memory monthlyRatesBPS = new uint256[](5);
        for(uint256 i=0;i<5;i++){
                initialBalances[i] = uint256(initBal[i]);
                monthlyRatesBPS[i] = uint256(intRate[i]);
        }
        return Waterfall.calculateInterest(months,initialBalances, monthlyRatesBPS);
    }
    
      uint256 testStartDate = 1576386631;  // timestamp for 2019-12-15;
  uint256[] testEndDates = [
 1580535061  // timestamp for 2020-02-01
,1580621522  // timestamp for 2020-02-02
,1580707983  // timestamp for 2020-02-03
,1580794444  // timestamp for 2020-02-04
,1580880905  // timestamp for 2020-02-05
,1580967366  // timestamp for 2020-02-06
,1581053827  // timestamp for 2020-02-07
,1581140288  // timestamp for 2020-02-08
,1581226749  // timestamp for 2020-02-09
,1581313210  // timestamp for 2020-02-10
,1581399671  // timestamp for 2020-02-11
,1581486132  // timestamp for 2020-02-12
,1581572593  // timestamp for 2020-02-13
,1581659054  // timestamp for 2020-02-14
,1581745515  // timestamp for 2020-02-15
,1581831976  // timestamp for 2020-02-16
,1581918437  // timestamp for 2020-02-17
,1582004898  // timestamp for 2020-02-18
,1582091359  // timestamp for 2020-02-19
,1582177820  // timestamp for 2020-02-20
,1582264281  // timestamp for 2020-02-21
,1582350742  // timestamp for 2020-02-22
,1582437203  // timestamp for 2020-02-23
,1582523664  // timestamp for 2020-02-24
,1582610125  // timestamp for 2020-02-25
,1582696586  // timestamp for 2020-02-26
,1582783047  // timestamp for 2020-02-27
,1582869508  // timestamp for 2020-02-28
,1582955969  // timestamp for 2020-02-29
];

DateCalc d = new DateCalc();

function testMonthsSince(uint8 startCounter) returns (int32[] memory, uint256[] memory){
    int32[] memory months = new int32[](2);
    uint256[] memory newDate  = new uint256[](2);
    for(uint8 i = startCounter; i< startCounter + 2; i++){
        (months[i-startCounter], newDate[i-startCounter]) = d.monthsSince(testStartDate, testEndDates[i]);
    }
    return (months, newDate);
}
}
