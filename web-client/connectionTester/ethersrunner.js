var ethers = require("ethers");
var fs = require("fs");
var keyfile = {"address":"ec7539f7e2f8531c2ab070810a99c06a8815a7c9","crypto":{"cipher":"aes-128-ctr","ciphertext":"dcea00fc65f26fac3ffc22b4864039f16ec1e9f4b0eae467e91e3956c62d9dde","cipherparams":{"iv":"2406d0de972bd371991aa650512885e3"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"c5b43f23d7c5aea86ef956e11e2ccef064a4b7d7d7b7b440cb349889e9344b6d"},"mac":"76a5212701624dc6921f117ca51cfba510f0b54e5a9fc4a1e87bf867dc4f583f"},"id":"b332dfc3-31b9-4cce-9750-18f6ad4c71f5","version":3};
let json = JSON.stringify(keyfile);
let password = "testtest";
var wallet = new ethers.Wallet("0xd4d0293d48e39dfe09b01726dadd8cd211c5023f1c230d38b8dbeab77c44383f")//"0x3141592653589793238462643383279502884197169399375105820974944592");
console.log("Address: " + wallet.privateKey);
var path = "/Users/bcdev/eth2/keystore/";

if(fs.statSync(path).isDirectory()){
    var allFiles = fs.readdirSync(path);
    // console.log(allFiles);
    var jsonData = [];
    var pks = [];
    // var handlebarsFiles = _.filter(allFiles, function(o) { return _.starts(o,".handlebars")})
    for(var afile of allFiles){
      var jsonFile = fs.readFileSync(path + afile,  'utf8');
      jsonData.push(jsonFile); 
      ethers.Wallet.fromEncryptedJson(jsonFile, password).then(function(wallet) {
        console.log("Address: " + wallet.privateKey);
        // pks.push(wallet.privateKey);
        // "Address: 0x88a5C2d9919e46F883EB62F7b8Dd9d0CC45bc290"
    });
    }
    // console.log(jsonData);
}
