//
//  Model.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/14/21.
//

import UIKit


class Model {
    static let sharedInstance = Model()
    
    var deck = Array(0 ..< 52)  // + Array(0 ..< 52) + Array(0 ..< 52) + Array(0 ..< 52)    // 4 decks
    //TODO: if using multiple decks card can be used more than once in hand. it happens so going back to one dec rather than redesign to track deck as well as value. this is not a commercial app. worked great for Solitaire. :-)
    var cards = [CardView]()  // persistent storage of cardViews.
    
    private init() {
        self.initialize()
    }
    
    private func initialize() {
        let frame = CGRect(x: 0, y: 0, width: CardView.cardWidth, height: CardView.cardHeight)
        for index in deck {
            self.cards.append(CardView(frame: frame, value: self.deck[index]))
        }
    }

    func shuffle() {
        self.deck.shuffle()
    }
}
