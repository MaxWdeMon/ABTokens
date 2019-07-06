pragma solidity >=0.5.0 <0.6.0;
import "../node_modules/ethereum-datetime/contracts/DateTime.sol";
//import "./DateTime.sol";
//import "https://github.com/pipermerriam/ethereum-datetime/contracts/DateTime.sol";


library DateCalc {
   // using DateTime for DateTime._DateTime;
/**
 * @param date (a timestamp) that will be normalised
 * @param day a standardised day of the month (should be <= 28 to avoid errors with payments falling on February 29th in non-leap years.)
 * @return timestamp reset to midnight of a given day. e.g. 26 Feb 2017 11:45am becomes 1 Feb 2017 00:00.
 * When calculating interest payments this code will ensure that the month count is always normalised to one date.
 */
    function normaliseTimestamp(uint256 date, uint8 day) public pure returns(uint256){
        require(day <= 28 && day > 0, "The day is out of range. We can only normalise to dates between the 1st and the 28th.");
        DateTime._DateTime memory d = DateTime.parseTimestamp(date);
        return DateTime.toTimestamp(d.year, d.month, day);
    }
    /**
     * @param start parameter is the first timestamp from which the period will be counted (the day of that date will be used as the basis - i.e. 16 Jan to 15 March is a two month period)
     * @param end parameter is the last timestamp to which the period will be counted (the day of the start date will be used as the basis - i.e. 16 Jan to 15 March is a two month period)
     * @return number of of full months that passed from the start date to the end date and the exact date on which the period would have ended.
     * e.g. 16 Jan to 15 March of the same year is a period of 2 months and the second return parameter will be 16 Feb;
     */
    function monthsSince(uint256 start, uint256 end) public pure returns(int32, uint256){
       DateTime._DateTime memory d1 = DateTime.parseTimestamp(start);
       DateTime._DateTime memory d2 = DateTime.parseTimestamp(end);
       uint8 daysDiff = d2.day < d1.day?1:0;
       int32 monthsDiff = int32(d2.month) - int32(d1.month);
       int32 yearsDiff = int32(d2.year) - int32(d1.year);
       uint8 newMonth = d2.month - daysDiff;
       uint16 newYear = newMonth<1? d2.year - 1:d2.year;
       return (monthsDiff + 12 * yearsDiff - daysDiff, DateTime.toTimestamp(newYear, newMonth, d1.day));
    }
}