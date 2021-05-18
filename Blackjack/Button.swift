//
//  Button.swift
//  Blackjack
//
//  Created by Gary Hanson on 5/16/21.
//

import UIKit


class Button: UIButton {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gradientColor1 = UIColor(named: "ButtonTop")!.cgColor
        let gradientColor2 = UIColor(named: "ButtonMiddle")!.cgColor
        let gradientColor3 = UIColor(named: "ButtonBottom")!.cgColor
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.blue.cgColor
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .disabled)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let btnGradient = CAGradientLayer()
        btnGradient.frame = self.bounds
        btnGradient.colors = [gradientColor1, gradientColor3, gradientColor2]
        self.layer.insertSublayer(btnGradient, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
