const ourPK = "0x3197950fc00b4cd8e8cd5c95a391bf42837e21caf82cd6b5f8fa36587085797f";
class EthersConnection{
    constructor(){
        this.getProvider();
    }
    async getProvider(){
        this.provider = ethers.getDefaultProvider(); //new ethers.providers.JsonRpcProvider("http://localhost:8545");
    }
    setUserAddress(address){
        this.userAddress = address;
    }

    async getStuff(){
        this.provider.getBalance(this.userAddress).then((balance) => {
            console.log("Balance: " + balance);
        });
    }

    async resolveENSname(name){
        return await this.provider.resolveName(name);
    }
}

class offlineSigner{
    constructor(privateKey){
        // let privateKey = "d"
        this.wallet = new ethers.Wallet(privateKey);
        console.log(this.wallet.address);
        console.log("test-val : 0xcf1193bec9e3902d7d1a1a8b98d1170a781ee93b");
    }
    sampleTransaction = {
            nonce: 0,
            gasLimit: 21000,
            gasPrice: ethers.utils.bigNumberify("20000000000"),
            to: "0x94fa5fe27a3d4b21c5ac22a8ca88590269d4180a",
            // ... or supports ENS names
            // to: "ricmoo.firefly.eth",
            value: ethers.utils.parseEther("12.0"),
            data: "0x",
            // This ensures the transaction cannot be replayed on different networks
            chainId: 1337 // ethers.utils.getNetwork('homestead').chainId
        };


    
    async signingPromise(unsignedTransaction){
        return this.wallet.sign(unsignedTransaction);
    }

    getSignedTransaction(unsignedTransaction){
        this.signingPromise(unsignedTransaction).then(function(signedTransaction){
            console.log(signedTransaction);
        console.log(`test value: 0xf86c808504a817c8008252089488a5c2d9919e46f883eb62f7b8dd9d0cc45bc2
       90880de0b6b3a76400008025a05e766fa4bbb395108dc250ec66c2f88355d240
       acdc47ab5dfaad46bcf63f2a34a05b2cb6290fd8ff801d07f6767df63c1c3da7
       a7b83b53cd6cea3d3075ef9597d5`);
            console.log(ethers.utils.parseTransaction(signedTransaction));
            return signedTransaction;
        }).catch(function(reason){
            console.log(reason);
            return null;});
    }

    parseTransaction(rawTransaction){
        return ethers.utils.parseTransaction(rawTransaction);
    }
}
   
    // This can now be sent to the Ethereum network
    // let provider = ethers.getDefaultProvider()
    // provider.sendTransaction(signedTransaction).then((tx) => {

    //     console.log(tx);
    //     // {
    //     //    // These will match the above values (excluded properties are zero)
    //     //    "nonce", "gasLimit", "gasPrice", "to", "value", "data", "chainId"
    //     //
    //     //    // These will now be present
    //     //    "from", "hash", "r", "s", "v"
    //     //  }
    //     // Hash:
    // });
// })

// var ethers = require("./ethers.js");
// var networkName = "rinkeby";
// var localProvider = new ethers.providers.JsonRpcProvider("http://localhost:8545");// .getDefaultProvider();
// console.log(localProvider);

// getStuff();
// var ec = new EthersConnection();
// ec.setUserAddress("0xec7539f7e2f8531c2ab070810a99c06a8815a7c9");
// // ec.getStuff();
// ec.resolveENSname("registrar.firefly.eth").then(function(address) {
//     console.log("Address: " + address);
//     // "0x6fC21092DA55B392b045eD78F4732bff3C580e2c"
// });
// var contract = new ethers.Contract(waterfallAddress, waterfallABI,localProvider);
// var payment = [];

