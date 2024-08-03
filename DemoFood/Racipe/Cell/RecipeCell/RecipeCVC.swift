//
//  RecipeCVC.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 01/08/24.
//

import UIKit

class RecipeCVC: UICollectionViewCell {
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgIngradient: CustomImageView!
    @IBOutlet weak var lblIngradient: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static var identifire : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifire, bundle: Bundle.main)
    }
    
    func createIngredientURL(for ingredient: String) -> URL? {
        let baseURL = URL(string: "https://www.themealdb.com/images/ingredients/")
        return URL(string: ingredient, relativeTo: baseURL)
    }
    
    func setData(ingredient: String){
        imgIngradient.loadImageForIngredients(ingredient: ingredient)
        lblIngradient.text = ingredient
    }
}
