//
//  ViewController.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dishwasherCollectionView: UICollectionView!
    
    @IBOutlet var doubleTap: UITapGestureRecognizer!
    
    lazy var selectorView = BrandSelectorView(viewModel: viewModel)

    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectorView)
        viewModel.delegate = self
        
        //Passes the viewModel and all information to the selector view.
//        selectorView.setViewModel(HomeViewModel: viewModel)
        
        selectorView.pickerView.delegate = viewModel
        selectorView.pickerView.dataSource = viewModel
        
        dishwasherCollectionView.delegate = self
        dishwasherCollectionView.dataSource = viewModel
        
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        dishwasherCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func doubleTapped(_ sender: UITapGestureRecognizer) {
        guard let indexPath = self.dishwasherCollectionView.indexPathForItem(at: sender.location(in: self.dishwasherCollectionView)) else {
            return
        }
        
        let cell = self.dishwasherCollectionView.cellForItem(at: indexPath) as! DishwasherCell
        
        //TODO add return statement to Toggle Favorite (BOOL) if successfully saved THEN change color
        CoreDataService().toggleFavorite(dishwasherName: cell.titleLabel.text!){ [weak self] in
            DispatchQueue.main.async {
                self?.dishwasherCollectionView.reloadItems(at: [indexPath])
                //self.dishwasherCollectionView.reloadData()
            }
        }
        //cell.toggleColor()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        UIView.transition(
            with: selectorView,
            duration: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.dishwasherCollectionView.backgroundColor = .white
                self.dishwasherCollectionView.frame.origin.y -= BrandSelectorView.height - 30
                self.selectorView.frame = BrandSelectorView.activeFrame
        }, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // get size the width of the screen (want each cell to be half width of the screen by dividing by 2)
        let width = (view.bounds.size.width / 2)
        let height = (view.bounds.size.height / 2)
        return CGSize(width: width, height: height)
    }
    
    // vertical distance between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // control spacing in between cells (horizontal)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension ViewController: HomeDelegate {
    
    func productsUpdated() {
        
        DispatchQueue.main.async {
            
            UIView.transition(
                with: self.selectorView,
                duration: 0.3,
                options: .curveEaseInOut,
                animations: {
                    self.dishwasherCollectionView.backgroundColor = .white
                    self.dishwasherCollectionView.frame.origin.y = 0
                    self.selectorView.frame = BrandSelectorView.hiddenFrame
            }, completion: nil)
            
            self.dishwasherCollectionView.reloadData()
            self.selectorView.pickerView.reloadAllComponents()
            
        }
    }
}

