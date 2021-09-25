//
//  GameView.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/14/21.
//

import UIKit


class GameView: UIView, GameDelegate {
    private var game = Game.sharedInstance
    
    private let cardOffset: CGFloat = 20.0
    private var dealerLocation = CGPoint(x: 154, y: 240)
    private var playerLocation = CGPoint(x: 154, y: 440)
    private var shoeLocation = CGPoint.zero
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
                
        backgroundColor = UIColor(named: "TableColor")
        game.delegate = self
    }
    
    private func resetLocations() {
        shoeLocation = CGPoint(x: bounds.width - 30, y: 10)

        let leading = bounds.midX - 16
        let top = bounds.midY - 140
        
        dealerLocation = CGPoint(x: leading, y: top)
        playerLocation = CGPoint(x: leading, y: top + 200)

    }
    
    func newHand() {
        resetLocations()

        _ = self.subviews.filter({ $0 is CardView }).map({ $0.removeFromSuperview() })
    }
    
    func dealCardToPlayer(card: CardView) {
        animateDeal(card: card, fromLocation: shoeLocation, toLocation: playerLocation)
        playerLocation.x += cardOffset
    }
    
    func dealCardToDealer(card: CardView) {
        animateDeal(card: card, fromLocation: shoeLocation, toLocation: dealerLocation)
        dealerLocation.x += cardOffset
    }
    
    func markAllCardsVisible() {
        // swiftlint:disable force_cast
        _ = self.subviews.map({ ($0 as! CardView).faceUp = true })
        // swiftlint:enable force_cast
    }
    
    private func animateDeal(card: CardView, fromLocation: CGPoint, toLocation: CGPoint) {

        card.frame.origin = fromLocation
        card.layer.position = card.frame.origin
        addSubview(card)
            
        // Set up path movement
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = CAAnimationCalculationMode.paced
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false

        let midPoint = CGPoint(x: fromLocation.x - (fromLocation.x - toLocation.x) * 0.5 + 20, y: fromLocation.y + (toLocation.y - fromLocation.y) * 0.5)
        let endPoint = toLocation

        let curvedPath = CGMutablePath()
        curvedPath.move(to: CGPoint(x: fromLocation.x, y: fromLocation.y - 60), transform: .identity)
        curvedPath.addQuadCurve(to: endPoint, control: CGPoint(x: midPoint.x + 40.0, y: midPoint.y), transform: .identity)
        pathAnimation.path = curvedPath
        
        // card rotation
        let imageRotation = CAKeyframeAnimation(keyPath: "transform.rotation")
        imageRotation.calculationMode = CAAnimationCalculationMode.paced
        imageRotation.fillMode = CAMediaTimingFillMode.forwards
        imageRotation.isRemovedOnCompletion = false
        imageRotation.values = [-CGFloat.pi / 3.0, 0.0]

        let group = CAAnimationGroup()
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false
        group.animations = [imageRotation, pathAnimation]
        group.duration = 0.3
        group.setValue(card, forKey:"imageViewBeingAnimated")

        card.layer.add(group, forKey:"savingAnimation")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
