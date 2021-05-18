//
//  Game.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/14/21.
//

import UIKit


protocol GameDelegate: AnyObject {
    func newHand()
    func dealCardToPlayer(card: CardView)
    func dealCardToDealer(card: CardView)
    func markAllCardsVisible()
}

protocol GameStateDelegate: AnyObject {
    func gameStateChanged(newState: GameState)
    func dealerScoreChanged(newScore: Int)
    func playerScoreChanged(newScore: Int)
    func playerBalanceChanged(newBalance: Int)
    func gameOver(result: GameResult)
}

enum GameState {
    case newHand            // cards are cleared. Deal button active
    case deal               // cards are being dealt, no buttons active
    case playerTurn         // Stand and Hit Me buttons active
    case dealerTurn         // Dealer's hand is evaluated and cards drawn as required. No buttons active
}

enum GameResult {
    case playerBlackjack
    case playerBust
    case playerWins
    case dealer21
    case dealerBust
    case dealerWins
    case push
}

class Game {
    static let sharedInstance = Game()
    let model = Model.sharedInstance
    
    private var gameState = GameState.newHand {
        didSet {
            if gameState != oldValue {
                gameStateDelegate?.gameStateChanged(newState: self.gameState)
            }
        }
    }
    private var dealerHand: Hand = Hand()
    private var playerHand: Hand = Hand()
    private var score = 1000
    private var betAmount = 25
    private var currentCardIndex = 0
    
    var delegate: GameDelegate?
    var gameStateDelegate: GameStateDelegate?
    
    
    private init() {
    }
    
    func shuffle() {
        Model.sharedInstance.shuffle()
    }
    
    func initialize() {
        self.shuffle()
        
        delegate?.newHand()
        newHand()
    }
    
    func addCardToPlayerHand(cardValue: Int) {
        playerHand.cards.append(cardValue)
        gameStateDelegate?.playerScoreChanged(newScore: playerHand.score)
    }
    
    func addCardToDealerHand(cardValue: Int) {
        dealerHand.cards.append(cardValue)
        gameStateDelegate?.dealerScoreChanged(newScore: dealerHand.score)
    }
    
    func newHand() {
        gameState = GameState.newHand
        
        if currentCardIndex > 40 {
            resetCards()
            shuffle()
            currentCardIndex = 0
        }
        playerHand.cards.removeAll()
        dealerHand.cards.removeAll()
        delegate?.newHand()
        
        var card = Model.sharedInstance.cards[Model.sharedInstance.deck[currentCardIndex]]
        currentCardIndex += 1
        
        delegate?.dealCardToPlayer(card: card)
        addCardToPlayerHand(cardValue: card.cardValue)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            card = Model.sharedInstance.cards[Model.sharedInstance.deck[self.currentCardIndex]]
            self.currentCardIndex += 1
            
            self.delegate?.dealCardToDealer(card: card)
            self.addCardToDealerHand(cardValue: card.cardValue)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                card = Model.sharedInstance.cards[Model.sharedInstance.deck[self.currentCardIndex]]
                self.currentCardIndex += 1
                
                self.delegate?.dealCardToPlayer(card: card)
                self.addCardToPlayerHand(cardValue: card.cardValue)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    card = Model.sharedInstance.cards[Model.sharedInstance.deck[self.currentCardIndex]]
                    self.currentCardIndex += 1
                    card.faceUp = false

                    self.delegate?.dealCardToDealer(card: card)
                    self.addCardToDealerHand(cardValue: card.cardValue)

                    self.gameState = GameState.playerTurn
                    self.checkPlayerScore(fromDeal: true)
               }
            }
        }
    }
    
    func stand() {
        gameState = .dealerTurn
        
        delegate?.markAllCardsVisible()
        dealerPlay(fromDeal: true)
    }
    
    func hit() {
        let card = Model.sharedInstance.cards[Model.sharedInstance.deck[currentCardIndex]]
        currentCardIndex += 1
        
        delegate?.dealCardToPlayer(card: card)
        addCardToPlayerHand(cardValue: card.cardValue)
        checkPlayerScore(fromDeal: false)
    }
    
    private func checkPlayerScore(fromDeal: Bool) {
        let score = playerHand.score
        
        if score == 21 {
            if fromDeal {
                gameStateDelegate?.gameOver(result: .playerBlackjack)
                gameState = .newHand
            }
        } else if score > 21 {
            gameStateDelegate?.gameOver(result: .playerBust)
            gameState = .newHand
        }
    }
    
    private func dealerPlay(fromDeal: Bool) {
        checkDealerScore(fromDeal: fromDeal)
        if gameState == .newHand {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hitDealer()
            self.dealerPlay(fromDeal: false)
        }
    }
    
    func hitDealer() {
        let card = Model.sharedInstance.cards[Model.sharedInstance.deck[currentCardIndex]]
        currentCardIndex += 1
        
        delegate?.dealCardToDealer(card: card)
        addCardToDealerHand(cardValue: card.cardValue)
    }
    
    private func checkDealerScore(fromDeal: Bool) {
        let score = dealerHand.score
        let playerScore = playerHand.score
        
        if score == 21 {
            if fromDeal || playerScore < 21 {
                gameStateDelegate?.gameOver(result: .dealer21)
                gameState = .newHand
            } else if playerScore == 21 {
                gameStateDelegate?.gameOver(result: .push)
                gameState = .newHand
            }
        } else if score > 21 {
            gameStateDelegate?.gameOver(result: .dealerBust)
            gameState = .newHand
        } else if score > playerScore {
            gameStateDelegate?.gameOver(result: .dealerWins)
            gameState = .newHand
        } else if score == playerScore {
            gameStateDelegate?.gameOver(result: .push)
            gameState = .newHand
        }
    }
    
    private func resetCards() {
        let frame = CGRect(x: 0, y: 0, width: CardView.cardWidth, height: CardView.cardHeight)
        for card in Model.sharedInstance.cards {
            card.frame = frame
            card.faceUp = true
        }
        print("Reset cards")
    }
}
