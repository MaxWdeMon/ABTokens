pragma solidity >=0.4.0 <0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../Waterfall.sol";
// file name has to end with '_test.sol'

contract test_1 {
//   Waterfalllib_tester w;
  function beforeAll() public {
    // w = new Waterfalllib_tester();
    // Assert.equal(address(w), address(w), "error in before all function");
  }

  function testInterestDueCalculation() public {
    // use 'Assert' to test the contract
    Assert.equal(Waterfall.caluculateMonthlyInterestDue(1000,1234), uint(123), "On 1000 wei balance you should earn 123 wei interest at a monthly rate of 12.34% (loosing the last decimal)");
    Assert.equal(Waterfall.caluculateMonthlyInterestDue(1 ether,987), uint(98700000000000000), "On 1 eth balance you should earn 0.987 eth interest at a monthly rate of 9.87%");
  }

  function testWaterfallCalculation() public {
   uint256[5] memory totalPayments =  [uint256(150),550,500,100,1200];
   uint256[5] memory interestPayments =  [uint256(100),500,400,0,1200];
  uint256[] memory totalPaymentsRslt;
  uint256[] memory interestPaymentsRslt;
   
   uint256[5] memory initBal =  [uint256(100),500,1000,1000,500];
   uint256[5] memory intDue =  [uint256(50),50,100,100,0];
   
  uint256[] memory initialBalances = new uint256[](5);
  uint256[] memory interestDue = new uint256[](5);
  for(uint256 i=0;i<5;i++){
        initialBalances[i] = uint256(initBal[i]);
        interestDue[i] = uint256(intDue[i]);
  }
   (totalPaymentsRslt,interestPaymentsRslt)=Waterfall.calculateWaterfall(1000,2000,initialBalances, interestDue);
   for(uint8 j=0;j<5;j++){
        Assert.equal(totalPaymentsRslt[j], totalPayments[j], "Total Payments Result comparison failed");
        Assert.equal(interestPaymentsRslt[j], interestPayments[j], "Interest Payments Result comparison failed");
  }
  }
  
  function testSingleInterestCalculation_1() public{
    int32 months = 12;
    uint256 balance = 1 ether;
    uint256 monthlyRateBPS = 100;
    uint256 res = Waterfall.calculateInterest(months, balance, monthlyRateBPS);
    Assert.equal(res, uint256(126825030131969720), "");
  }
function testSingleInterestCalculation_2() public{
    int32 months = 100;
    uint256 balance = 1000000;
    uint256 monthlyRateBPS = 100;
    uint256 res = Waterfall.calculateInterest(months, balance, monthlyRateBPS);
    Assert.equal(res, uint256(1704734), "");
  }
  
  function testMultipleTrancheInterestCalculation() public {
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
        uint256[] memory interestDueRslt = Waterfall.calculateInterest(months,initialBalances, monthlyRatesBPS );
        for(uint8 j=0;j<5;j++){
            Assert.equal(interestDueRslt[j], interestPayments[j], "Calculate interest result does not match");
        }
   }
}

