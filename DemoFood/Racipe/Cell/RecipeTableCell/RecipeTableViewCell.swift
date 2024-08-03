//
//  RecipeTableViewCell.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 01/08/24.
//

import UIKit


protocol ReloadDelegate: AnyObject{
    func reloadCell(index: Int)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgThumb: CustomImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var lblIngrdients: UILabel!
    @IBOutlet weak var cvIngradient: UICollectionView!
    
    var recipe: RacipeDataModel?
    weak var reloadDelegate: ReloadDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cvIngradient.delegate = self
        cvIngradient.dataSource = self
        cvIngradient.register(RecipeCVC.nib, forCellWithReuseIdentifier: RecipeCVC.identifire)
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
    
    
    func setData(with data: RacipeDataModel) {
        recipe = data
        imgThumb.loadImage(urlStr: data.strMealThumb ?? "")
        lblName.text = data.strMeal
        lblInstructions.text = data.strInstructions
        lblIngrdients.text = Const.ingrdients
        if lblInstructions.maxNumberOfLines > 3 && !(data.isExpanded ?? false) {
            lblInstructions.numberOfLines = 3
            DispatchQueue.main.async {
                self.lblInstructions.addTrailing(with: "", moreText: " \(Const.viewMore)", moreTextFont: .boldSystemFont(ofSize: 16), moreTextColor: .systemTeal)
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
                self.lblInstructions.isUserInteractionEnabled = true
                self.lblInstructions.addGestureRecognizer(tapAction)
            }
        }else if data.isExpanded ?? false{
            lblInstructions.numberOfLines = 0
            DispatchQueue.main.async {
                self.lblInstructions.addTrailingViewLess(lessText: " \(Const.viewLess)", moreTextFont: .boldSystemFont(ofSize: 16), moreTextColor: .systemTeal)
                let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
                self.lblInstructions.isUserInteractionEnabled = true
                self.lblInstructions.addGestureRecognizer(tapAction)
            }
        }
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let moreRange = ("\(lblInstructions.text ?? "")" as NSString).range(of: Const.viewMore)
        let lessRange = ("\(lblInstructions.text ?? "")" as NSString).range(of: Const.viewLess)
        
        if gesture.didTapAttributedTextInLabel(label: lblInstructions, inRange: moreRange) {
            reloadDelegate?.reloadCell(index: lblInstructions.tag)
        }else if gesture.didTapAttributedTextInLabel(label: lblInstructions, inRange: lessRange) {
            reloadDelegate?.reloadCell(index: lblInstructions.tag)
        }
    }
    
}

extension RecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCVC.identifire, for: indexPath) as! RecipeCVC
        cell.setData(ingredient: recipe?.ingredients[indexPath.item] ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
}
