//
//  BlackjackViewController.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/14/21.
//

import UIKit


class BlackjackViewController: UIViewController {
    private var game = Game.sharedInstance

    private var titleLabel: UILabel!
    let gameView = GameView(frame: CGRect.zero)
    var hitMeButton: Button?
    var newHandButton: Button?
    var standButton: Button?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "TableColor")
        game.gameStateDelegate = self
        
        initalizeViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        game.initialize()
    }
    
}

extension BlackjackViewController {
    
    fileprivate func initalizeViews() {
        gameView.frame = CGRect(x: 0, y: 10, width: view.bounds.width, height: view.bounds.height - 10)
        view.addSubview(gameView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 50))
        titleLabel.text = "Blackjack"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Palatino", size: 40)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        standButton = Button(frame: CGRect(x: view.bounds.midX - 140, y: 640, width: 80, height: 34))
        standButton!.setTitle("Stand", for: .normal)
        standButton!.tintColor = .black
        standButton!.addTarget(self, action: #selector(stand), for: .touchUpInside)
        view.addSubview(standButton!)
        
        hitMeButton = Button(frame: CGRect(x: view.bounds.midX - 40, y: 640, width: 80, height: 34))
        hitMeButton!.setTitle("Hit Me", for: .normal)
        hitMeButton!.tintColor = .black
        hitMeButton!.addTarget(self, action: #selector(hitMe), for: .touchUpInside)
        view.addSubview(hitMeButton!)
        
        newHandButton = Button(frame: CGRect(x: view.bounds.midX + 60, y: 640, width: 80, height: 34))
        newHandButton!.setTitle("Deal", for: .normal)
        newHandButton!.tintColor = .black
        newHandButton!.addTarget(self, action: #selector(newHand), for: .touchUpInside)
        view.addSubview(newHandButton!)
    }
    
    @objc func stand() {
        game.stand()
    }
    
    @objc func hitMe() {
        game.hit()
    }
    
    @objc func newHand() {
        game.newHand()
    }
}

extension BlackjackViewController: GameStateDelegate {
    
    func gameStateChanged(newState: GameState) {
        
        switch newState {
        case .newHand:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {     // give message popup a chance to finish
                self.newHandButton!.isEnabled = true
                self.standButton!.isEnabled = false
                self.hitMeButton!.isEnabled = false
            }
        case .deal:
            newHandButton!.isEnabled = false
            standButton!.isEnabled = false
            hitMeButton!.isEnabled = false
        case .dealerTurn:
            newHandButton!.isEnabled = false
            standButton!.isEnabled = false
            hitMeButton!.isEnabled = false
        case .playerTurn:
            newHandButton!.isEnabled = false
            standButton!.isEnabled = true
            hitMeButton!.isEnabled = true
        }
    }
    
    func dealerScoreChanged(newScore: Int) {
        //print("Dealer Score: \(newScore)")
    }
    
    func playerScoreChanged(newScore: Int) {
        //print("Player Score: \(newScore)")
    }
    
    func playerBalanceChanged(newBalance: Int) {
        //print("Player Balance: \(newBalance)")
    }
    
    func gameOver(result: GameResult) {
                
        newHandButton!.isEnabled = false
        standButton!.isEnabled = false
        hitMeButton!.isEnabled = false

        showPopup(result: result)
    }
    
    func showPopup(result: GameResult) {
        var message = ""
        
        switch result {
        case .dealer21:
            message = "Dealer won (21)"
        case .dealerBust:
            message = "Won"
        case .playerBust:
            message = "Dealer won"
        case .push:
            message = "Push"
        case .dealerWins:
            message = "Dealer won"
        case .playerBlackjack:
            message = "Blackjack!!"
        case .playerWins:
            message = "Won"
        }
        
        let popUpView = PopupView(message: message, frame: CGRect(x: view.bounds.midX - 80, y: view.bounds.midY - 60, width: 180, height: 40))
        view.addSubview(popUpView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            popUpView.removeFromSuperview()
        }
   }

}
