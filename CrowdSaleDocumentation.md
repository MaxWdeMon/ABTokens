# Crowdsale 
## Buy Tokens Method documentation
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
