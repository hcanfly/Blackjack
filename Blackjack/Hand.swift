//
//  Hand.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/15/21.
//

import Foundation


struct Hand {
    var cards: [Int] = []
    
    var score: Int {
        var numAces = 0
        var count = 0
        
        for card in cards {
            let rank = (card % numberOfCardsInSuit)
            let cardValue = (rank >= 10 ? 10 : (rank == 0 ? 0 : rank + 1))

            if rank != 0 {
                count += cardValue
            } else {
                numAces += 1
                count += 11
            }
        }
        
        if count <= 21 || numAces == 0 {
            return count
        }
        
        // we're over 21 and the aces have been counted as 11. drop count by 10 for each one until either
        // 21 or less or all aces have been processed
        for _ in 0..<numAces {
            count -= 10
            if count <= 21 {
                return count
            }
        }
        
        return count
    }
}
