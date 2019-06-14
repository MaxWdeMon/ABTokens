# Crowdsale 
## Buy Tokens Method documentation

* Diagram can be generated from here: 
[http://www.plantuml.com/plantuml/uml/]
```
@startuml
buyTokens --> nonReentrant
buyTokens -> weiAmount
weiAmount ->_preValidatePurchase
_preValidatePurchase -> weiRaised
weiRaised->processPurchase
processPurchase-->_deliverTokens
_deliverTokens-->_token.safeTransfer
processPurchase->emitTokensPurchased
emitTokensPurchased->_updatePurchasingState
_updatePurchasingState->_forwardFunds
_forwardFunds->_postValidatePurchase
@enduml
```
