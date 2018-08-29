//
//  AdjustableLabel.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import UIKit

class AdjustableLabel: UILabel {
    
    // init used to initialize storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    // tells frame where to position if you code the storyboard programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        adjustsFontSizeToFitWidth = true
    }
}
