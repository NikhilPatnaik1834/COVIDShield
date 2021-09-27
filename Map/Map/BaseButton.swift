//
//  BaseButton.swift
//  Map
//
//  Created by Nikhil Patnaik on 25/04/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

//Class defines base settings for buttons used for every UIButton in app.


import UIKit

class BaseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        backgroundColor     = UIColor(red: 232/255, green: 235/255, blue: 247/255, alpha: 1.0)
        titleLabel?.font    = UIFont(name: "AppleSDGothicNeo-Light", size: 22 )
        layer.cornerRadius  = frame.size.height/2
        setTitleColor(.black, for: .normal)
    }
}
