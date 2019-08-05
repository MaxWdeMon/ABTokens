// var ethers = require("./ethers.js");
// var networkName = "rinkeby";
var localProvider = new ethers.providers.JsonRpcProvider("http://localhost:8545");// .getDefaultProvider();
console.log(localProvider);
async function getStuff(){
    let address = "0xec7539f7e2f8531c2ab070810a99c06a8815a7c9";
    // localProvider.getBalance(address).then(function(bal){
    //     console.log(bal);
    // });
    localProvider.getBalance(address).then((balance) => {
        console.log("Balance: " + balance);
    });
}
getStuff();
// var contract = new ethers.Contract(waterfallAddress, waterfallABI,localProvider);
// var payment = [];