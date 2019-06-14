pragma solidity >=0.4.0 <0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./DateCalc.sol";
// file name has to end with '_test.sol'

contract test_1 {
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
DateCalc d;
  function beforeAll() public {
    // here should instantiate tested contract
    //Assert.equal(uint(4), uint(3), "error in before all function");
    d = new DateCalc();
  }

  function testMonthsSinceFunction() public {
    // use 'Assert' to test the contract
    int32  months;
    uint256 newDate;
    int32  months_check;
    uint256 newDate_check;
    for(uint8 i = 13; i< 15; i++){
        (months, newDate) = d.monthsSince(testStartDate, testEndDates[i]);
        (months_check, newDate_check) = i<14?(1,1579046400):(2,1581724800);

         Assert.equal(months,months_check , "Months check failed");
         Assert.equal(newDate,newDate_check , "New Date check failed");
    }
   
  }

  function check2() public view returns (bool) {
    // use the return value (true or false) to test the contract
    return true;
  }
}

