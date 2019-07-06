pragma solidity >=0.4.0 <0.6.0;

/**
 * @author Maxwell's Deamon
 * @title Waterfall paying engine for securitisation on Ethereum 
 * 
 */

library Waterfall {
    /**
     * @param balance to be used as a basis for interest calculation. In case of a loan it is usually the outstanding amount at the beginning of the month.
     * @param monthlyRateBPS is the interest to be paid each month in basis points. e.g. monthlyRateBPS = 100 corresponds to 1% per month, which is just over 12.68% per year (1 + 100bps / 10000) ^ 12 - 1
     * @return the amount due to be paid
     */
    function caluculateMonthlyInterestDue(uint256 balance, uint256 monthlyRateBPS) public pure returns(uint256){
        return balance * monthlyRateBPS / 10000;
    }
    
    /**
     * @notice calculates the interest payment for each obligation for a specified number of months
     * @param months - the number of months that have passed since the last payment
     * @param balance to be used as a basis for interest calculation. In case of a loan it is usually the outstanding amount at the beginning of the payment period.
     * @return the amount due to be paid
     */
    function calculateInterest(int32 months,  uint256 balance, uint256 monthlyRateBPS) public pure returns(uint256){
        if(months == 1){
            return caluculateMonthlyInterestDue(balance, monthlyRateBPS);
        }else if (months == 0){
            return 0;
        }else{
            uint256 interestDue = 0;
            for(int32 i = 0;i<months;i++){
                interestDue += caluculateMonthlyInterestDue(balance + interestDue, monthlyRateBPS);
            }
            return interestDue;
        }
    }
    function calculateInterest(int32 months,  uint256[] memory balance, uint256[] memory monthlyRateBPS) public pure returns(uint256[] memory){
        require(balance.length == monthlyRateBPS.length);
        uint256[] memory interestDue = new uint256[](balance.length);
        for(uint8 i = 0; i <  balance.length; i++){
            interestDue[i] = calculateInterest(months, balance[i], monthlyRateBPS[i]);
        }
        return interestDue;
    }
    
     function calculateWaterfall(uint256 principal, uint256 totalReceipts, uint256[] memory balance, uint256[] memory interestDue)
     public pure returns (uint256[] memory, uint256[] memory){
        uint256[] memory principalPayment = new uint256[](balance.length);
        uint256[] memory totalPayment = new uint256[](balance.length);
        totalReceipts += balance[balance.length-1]; //take the most junior tranche as the reserve;
        for(uint8 i = 0; i < balance.length-1; i++){
            uint256 trancheInterestDue = interestDue[i];
            if(trancheInterestDue > totalReceipts){
                //emit missedInterestPayment(trancheInterestDue - totalReceipts);
                totalPayment[i] = totalReceipts;
                totalReceipts = 0;
                return (totalPayment, principalPayment);
            }
            else
            {
                totalReceipts = totalReceipts - trancheInterestDue;
                uint256 payment = trancheInterestDue;
                if(principal > totalReceipts){
                    principal = principal - totalReceipts;
                    principalPayment[i] = totalReceipts;
                    payment += totalReceipts;
                    totalReceipts = 0;
                }
                else
                {
                    uint256 trancheBalance = balance[i];
                    if(principal >= trancheBalance){
                        principal = principal - trancheBalance;
                        payment += trancheBalance;
                        totalReceipts = totalReceipts - trancheBalance;
                        principalPayment[i] = trancheBalance;
                    }
                    else
                    {
                        principalPayment[i] = principal;
                        payment += principal;
                        totalReceipts = totalReceipts - principal;
                        principal = 0;
                    }
                }
                totalPayment[i] = payment;
            }
        }
        totalPayment[totalPayment.length-1] = totalReceipts;
        principalPayment[balance.length-1] = totalReceipts;
        return (totalPayment, principalPayment);
    }
}