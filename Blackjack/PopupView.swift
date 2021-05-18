//
//  PopupView.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/16/21.
//


import UIKit


class PopupView: UIView {
 
    var winlossLabel: UILabel!
    var amountLabel: UILabel!
    
    
    init(message: String, frame: CGRect) {
        super.init(frame: frame)
 
        configureView(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(message: String) {
        winlossLabel = UILabel(frame: CGRect(x: 4, y: 4, width: bounds.width, height: 34))
        amountLabel = UILabel(frame: CGRect(x: 4, y: 36, width: bounds.width, height: 30))
        addSubview(winlossLabel)
        addSubview(amountLabel)
        
        winlossLabel.text = message
        winlossLabel.textColor = .white
        winlossLabel.font = UIFont(name: "Georgia", size: 26)
        winlossLabel.textAlignment = .center

        amountLabel.textColor = .white
        amountLabel.font = amountLabel.font.withSize(24)
        amountLabel.textAlignment = .center
        
        layer.cornerRadius = 6
        
        layer.cornerRadius = 10
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
 
}
