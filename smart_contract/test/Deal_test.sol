pragma solidity >=0.4.0 <0.6.0;
      // import "remix_tests.sol"; // this import is automatically injected by Remix.
      //   import "../Deal.sol";
      //   import "../Note.sol";
      // file name has to end with '_test.sol'
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Deal.sol";

contract Deal_test {
  Deal d;
  function beforeAll() public {
    // here should instantiate tested contract
    // d = new Deal(); //use this line for remix
    d = Deal(DeployedAddresses.Deal());
    
    // for(uint8 i = 0; i < 5; i++){
    //     Note n = new Note();
    //     d.addNote(i, 1000000 * ( i + 1 ) , 30 * ( i + 1 ) , n );
    // }
    // Assert.equal(uint(3), uint(3), "error in before all function");
  }

  function testStartDateSetter() public {
  //     uint256 startDate = 1;
  //     (bool success, bytes memory data) = address(d).call.gas(40000).value(0)(abi.encode("setStartDate, [startDate]"));
  //     Assert.equal(uint(d.getStartDate()),startDate,"First setting of startDate failed");
  //     (bool successReset, bytes memory dataReset) = address(d).call.gas(40000).value(0)(abi.encode("setStartDate, [2]"));
  //     Assert.equal(successReset,false,"Second setting of startDate succeeded, although it shouldn't have.");
  // //   d.setStartDate(1);
  // //   Assert.equal(uint(2), uint(2), "error message");
  }

  function testStartDateSetterFail() public pure returns (bool) {
    // use the return value (true or false) to test the contract
    // d.setStartDate(now + 100 );
    return true;
  }
  
  
  function testPaymentUpdater() public {
    // use 'Assert' to test the contract
    for(uint256 i = 1; i < 7; i++){
        d.updateInterestsDue( 2700000 * i );
    }
    Assert.equal(uint(d.getLastChecked()), uint(15638400),"After 6 months of interest due updates the last checked date should be 15638400");
    // uint256[5] memory interestDueCheck = [uint256(1001800),2007208,3016234,4028884,5045167];
    // for(uint256 j = 0; j < 5; j++){
    //     Assert.equal(uint(d.getInterestDue()[j]), uint(interestDueCheck[j]), "InterestDue calculation after 6months does not tie out");
    // }
  } 
}