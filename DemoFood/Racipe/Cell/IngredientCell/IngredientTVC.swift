//
//  IngredientTVC.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 02/08/24.
//

import UIKit

class IngredientTVC: UITableViewCell {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgIngredient: CustomImageView!
    @IBOutlet weak var lblIngredientName: UILabel!
    @IBOutlet weak var lblIngredientQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureContainerView(view: vwContainer)
        configureYourView(view: vwMain)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static var identifire : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifire, bundle: Bundle.main)
    }
    
    func configureContainerView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }
        
    func configureYourView(view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
    }
      
    func setData(ingredient: String, ingredientQuantity: String) {
        imgIngredient.loadImageForIngredients(ingredient: ingredient)
        lblIngredientName.text = ingredient
        lblIngredientQuantity.text = ingredientQuantity
    }
    
}
