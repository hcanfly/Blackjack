//
//  CardView.swift
//  CardStacks
//
//  Created by Gary Hanson on 5/14/21.
//


import UIKit

let numberOfCardsInSuit = 13


enum Suit: Int {
    case spades, diamonds, hearts, clubs
    
    func name() -> String {
        switch (self) {
        case .clubs:
            return "Club"
        case .diamonds:
            return "Diamond"
        case .hearts:
            return "Heart"
        case .spades:
            return "Spade"
        }
    }
}


// UIView that displays a card
final class CardView: UIView {
    static let faceDownImage = UIImage(named: "CardBack")
    static let cardWidth: CGFloat = 85
    static let cardHeight: CGFloat = 118
    
    private let imageView: UIImageView
    private let faceDownImageView: UIImageView  // back of the card. sits on top of imageView but is hidden unless faceUp is false
    var faceUp: Bool = true {
        didSet {
            self.faceDownImageView.isHidden = self.faceUp
        }
    }
    
    // the card value is its position in the 0..51 array of possible card values. see
    // getCardSuitAndRank to see how suit and rank are determined from the value
    var cardValue = 0       // suit and rank of card
    
    var isAce: Bool {
        return cardValue % numberOfCardsInSuit == 0
    }
        
    private func getSuitAndColor() -> (suit: Suit, color: UIColor) {
        
        let suit = Suit(rawValue: self.cardValue / numberOfCardsInSuit)!
        var color: UIColor
        
        switch (suit) {
            case .spades, .clubs:
                color = .black
            case .hearts, .diamonds:
                color = .red
        }
        
        return (suit, color)
    }
    
    private func getCardSuitAndRank() -> (suit: Suit, rank: Int) {
        let suit = Suit(rawValue: self.cardValue / numberOfCardsInSuit)!
        let rank = (self.cardValue % numberOfCardsInSuit)
        
        return (suit, rank)
    }
    
    private func getDisplayValueForRank(rank: Int) -> String {
        var retString = ""
        
        switch (rank) {
        case 0:
            retString = "Ace"
        case 10:
            retString = "Jack"
        case 11:
            retString = "Queen"
        case 12:
            retString = "King"
        default:
            retString = String(rank + 1)
        }
        
        return retString
    }
    
    private func getCardImage() -> UIImage {
        let (suit, rank) = getCardSuitAndRank()
        let suitName = suit.name()
        
        var rankString = getDisplayValueForRank(rank: rank)
        rankString = suitName + "-" + rankString
        
        return UIImage(named: rankString)!
    }
    
    convenience init(frame: CGRect, value: Int, faceUp: Bool = true) {
        self.init(frame: frame)
                
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = 7.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        
        self.cardValue = value
        self.faceUp = faceUp
        
        self.imageView.frame = self.bounds
        self.imageView.image = getCardImage()
        self.addSubview(self.imageView)
        
        self.faceDownImageView.frame = self.bounds
        self.faceDownImageView.image = CardView.faceDownImage
        self.faceDownImageView.isHidden = faceUp
        self.addSubview(self.faceDownImageView)
    }
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
        self.faceDownImageView = UIImageView(frame: CGRect.zero)
        self.faceDownImageView.contentMode = .scaleAspectFit

        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
