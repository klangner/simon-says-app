//
//  CircleButton.swift
//  Simon Says
//
//  Created by Krzysztof Langner on 02/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = layer.frame.size.width / 2
        layer.masksToBounds = true
        alpha = 0.5
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }
    
    public func flash(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.alpha = 0.5
        }, completion: completion)
    }
}
