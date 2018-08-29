//
//  BrandSelectorView.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//

import UIKit

class BrandSelectorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var viewModel: HomeViewModel!
    
    static let height: CGFloat = 273
    
    static var activeFrame: CGRect {
        return CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - height,
            width: UIScreen.main.bounds.width,
            height: height)
    }
    
    static var hiddenFrame: CGRect {
        return CGRect(
            x: 0,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    convenience init(viewModel: HomeViewModel) {
        self.init(frame: BrandSelectorView.hiddenFrame)
        self.viewModel = viewModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        Bundle.main.loadNibNamed("BrandSelectorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        
        viewModel.selectedBrand = viewModel.brands[pickerView.selectedRow(inComponent: 0)]
        viewModel.filterBool = true
        viewModel.delegate?.productsUpdated()
    }
    
    //used cancel button instead of adding another button to clear search (just sets filter back to false
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        viewModel.filterBool = false
        viewModel.delegate?.productsUpdated()
    }
}
