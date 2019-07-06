const Waterfall = artifacts.require("Waterfall");
const DateTime = artifacts.require("DateTime");
const DateCalc = artifacts.require("DateCalc");
const NoteA = artifacts.require("Note");
// const NoteB = artifacts.require("Note");
// const NoteC = artifacts.require("Note");
// const NoteD = artifacts.require("Note");
// const NoteE = artifacts.require("Note");
const Deal = artifacts.require("Deal");
const DealProxy_tester = artifacts.require("./proxies/DealProxy_tester");

module.exports = function(deployer, network) {
  if(network == "xyz"){
    ///do other deployment steps
  }
  deployer.deploy(Waterfall);
  deployer.deploy(DateTime);
  deployer.link(DateTime, DateCalc);
  deployer.deploy(DateCalc);
  deployer.deploy(NoteA);
  // deployer.deploy(NoteB);
  // deployer.deploy(NoteC);
  // deployer.deploy(NoteD);
  // deployer.deploy(NoteE);
  deployer.link(Waterfall, Deal);
  deployer.link(DateCalc, Deal);
  deployer.deploy(Deal);

  deployer.link(Waterfall, DealProxy_tester);
  deployer.link(DateCalc, DealProxy_tester);
  deployer.deploy(DealProxy_tester);
  // var aDeal; 
  // Deal.deployed().then(function(d){
  //   aDeal = d;
  // }).then(function(){
  //   return NoteA.deployed();
  // }).then(function(note){
  //   aDeal.addNote(0,1000000,30,note);
  // });
  
  // Promise.all([, NoteA.deployed(), NoteB.deployed(), NoteC.deployed()]).then(function(values) {
  //   // values);
  //   for(var k = 1; k < values.length; k++){
  //     values[0].addNote(k - 1, 1000000 * ( k ), 30 * ( k ), values[k]);
  //     // console.log(values[0]);
  //   }
  // });
//   deployer.deploy(Deal).then(function(d) {
//     aDeal = d;
//     var notes = [];
//     for(var i = 0;i < 5;i++){
//       var n = await Note.new();
//       notes.push(n);
//     }
//     return Note.new();
//   }).then(function(instance) {
    
//      aDeal.addNote(0, 1000000, 30, instance);
// // //     for(var i = 0; i < instances.length; i++){
// // //       Deal.addNote(i, 1000000 * ( i + 1 ), 30 * ( i + 1 ), instances[i]);
// // //       Deal.setDealStage(3);
// // //     }
//  });
//   });
};
