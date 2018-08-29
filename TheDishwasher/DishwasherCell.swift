//
//  DishwasherCell.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import UIKit
import Kingfisher

class DishwasherCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let identifier = "DishwasherCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // makes text size consistent throughout iOS platforms (phone/iPad)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
    // when lazy var is applied, need to use inout to modify paramater.
    // inout makes it so that Dishwasher can be modified as a reference
    func configure(with dishwasher: inout Dishwasher){
        titleLabel.text = dishwasher.title
        
        let cost = dishwasher.currentPrice ?? 0.0
        let priceText = CurrencyTranslator.translate(cost)
        priceLabel.text = priceText

        imageView.kf.setImage(with: dishwasher.imageURL)
    }
}
