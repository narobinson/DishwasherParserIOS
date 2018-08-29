//
//  HomeViewModel.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//
import UIKit

protocol HomeDelegate: class {
    
    func productsUpdated()
}

class HomeViewModel: NSObject {
    
    var selectedBrand: String?
    weak var delegate: HomeDelegate?
    
    var brands: [String] {
        return Array(Set(products.map{ $0.brand })).sorted()
    }
    //gets list of favorites
    var favorites:[String]{
        return CoreDataService().getFavorites()
    }
    
    var filteredProducts: [Dishwasher] {
        // - no brand selected, show all dishwashers
        guard let brand = selectedBrand else { return products }
        // - brand selected, filter by brand
        return products.filter{ $0.brand == brand }
    }
    
    var products: [Dishwasher]  = []
    
    //Used to switch filter on and off
    var filterBool: Bool = false
    
    override init(){
        super.init()
        
        FacadeService.shared.getDishwashers(){ [unowned self] results in
            self.products = results
            self.delegate?.productsUpdated()
        }
    }
    
}

extension HomeViewModel: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(
            string: brands[row],
            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    

}

extension HomeViewModel: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
}

extension HomeViewModel: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var dishwashers:[Dishwasher] = []
        
        if filterBool{
            dishwashers = filteredProducts
        }
        else{
            dishwashers = products
        }
        
        return dishwashers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var dishwashers:[Dishwasher] = []
        
        if filterBool{
            dishwashers = filteredProducts
        }
        else{
            dishwashers = products
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DishwasherCell.identifier,
            for: indexPath) as! DishwasherCell
        
        var dishwasher = dishwashers[indexPath.row]
        
        //Checks if the cell title is contained in favorites then changes background color
        if favorites.contains(dishwasher.title){
            cell.backgroundColor = colors.favoriteColor
        }
        else{
            cell.backgroundColor = .white
        }
        
        // ampersand implied "dishwasher" can be passed as a reference so it can be modified
        cell.configure(with: &dishwasher)


        
        return cell
    }
}
