const ethers = require("ethers");
// console.log(ethers);

const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
// console.log(provider);

var presignedTx = "0xf86e808504a817c8008252089494fa5fe27a3d4b21c5ac22a8ca88590269d4180a88a688906bd8b0000080820a95a00965de548bc132ca8214dac942e7ebd5a53ab7bc1efaff203e9415aeb84ca088a0281fba7d7699f8fd8aa4ecfbb35519a3f817e829e0d5122ac87222b86f700622";
provider.sendTransaction(presignedTx);
provider.getBalance("0xcf1193bec9e3902d7d1a1a8b98d1170a781ee93b").then(function(r){console.log(ethers.utils.formatEther(r));}).catch(function(e){console.log(e);});
provider.getBalance("0x94fa5fe27a3d4b21c5ac22a8ca88590269d4180a").then(function(r){console.log(ethers.utils.formatEther(r));}).catch(function(e){console.log(e);});
// const wallet = new ethers.Wallet.fromMnemonic("limit hand grunt dose daughter return man minute super ghost ritual virtual");

// // console.log(wallet);

// const connectedWallet = wallet.connect(provider);


// connectedWallet.getBalance()
// .then(
//     function(r){console.log(r);})
// .catch(
//     function(e){console.log(e);}
//     );
// //---------transaction----------
// var tx = {      nonce: 4,
//                 gasLimit: 21000,
//                 gasPrice: ethers.utils.bigNumberify("20000000000"),
//                 to: "0x788d2ca0c2d3c27f210115d1cab2b2da59beb749",
//                 value: ethers.utils.parseEther("1.0"),
//                 data: "0x",
//                 chainId: 1337
// };

// wallet.sign(tx).then(signedTx=>{
//     console.log(`signedTx: ${signedTx}`);
//     return provider.sendTransaction(signedTx);
// })
// .catch(e=>{console.log(e);})
// .then(
//     r=>{console.log(r);}
// )
// .catch(e=>{console.log(e);});
