pragma solidity >=0.4.0 <0.6.0;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
        import "./Deal.sol";
        import "./Note.sol";
      // file name has to end with '_test.sol'
      contract test_1 {
        Deal d;
        function beforeAll() public {
          // here should instantiate tested contract
          d = new Deal();
          for(uint8 i = 0; i < 5; i++){
              Note n = new Note();
              d.addNote(i, 1000000 * ( i + 1 ) , 30 * ( i + 1 ) , n );
          }
          Assert.equal(uint(3), uint(3), "error in before all function");
        }

        function checkStartDateSetter() public {
          // use 'Assert' to test the contract
        /*    for(uint8 i = 0; i < 15; i++){
               Note n = new Note();
               d.addNote(i, 1000000 * ( i + 1 ) , 30 * ( i + 1 ) , n );
           }*/
          d.setStartDate(1);
          Assert.equal(uint(2), uint(2), "error message");
        }

        function checkStartDateSetterFail() public returns (bool) {
          // use the return value (true or false) to test the contract
         // d.setStartDate(now + 100 );
          return true;
        }
        
        
        function checkPaymentUpdater() public {
          // use 'Assert' to test the contract
          for(uint256 i = 4; i < 6; i++){
              d.updateInterestsDue( 2700000 * i );
          }
          Assert.equal(uint(d.lastChecked()), uint(15638400),"After 6 months of interest due updates the last checked date should be 15638400");
        }
      }