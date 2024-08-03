//
//  RecipesDetailViewController.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 02/08/24.
//

import UIKit
import SafariServices

class RecipesDetailViewController: BaseViewController {

    @IBOutlet weak var imgTop: CustomImageView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblIngredientName: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var lblIngredientsTitle: UILabel!
    @IBOutlet weak var lblIngredientsQuantity: UILabel!
    @IBOutlet weak var tblIngredients: UITableView!
    @IBOutlet weak var tblIngredientsHeight: NSLayoutConstraint!
    @IBOutlet weak var btnViewOnYouTube: UIButton!
    
    var recipe: RacipeDataModel?
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    init?(recipe: RacipeDataModel, coordinator:AppCoordinator, coder: NSCoder) {
        self.recipe = recipe
        super.init(coordinator: coordinator, coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(config:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setData()
        setBtnConfig()
        tblIngredients.dataSource = self
        tblIngredients.delegate = self
        tblIngredients.register(IngredientTVC.nib, forCellReuseIdentifier: IngredientTVC.identifire)
        self.tblIngredients.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vwMain.isOpaque = true
        vwMain.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 20)
    }
    
    @objc func buttonTapped() {
        self.navigationController?.popViewController(animated: false)
        }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblIngredients && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    tblIngredientsHeight.constant = newSize.height
                }
            }
        }
    }
    
    func setBtnConfig() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftButton)
        leftButton.backgroundColor = .systemGray
        leftButton.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        leftButton.tintColor = .black
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            leftButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        leftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        leftButton.layer.cornerRadius = 10
        leftButton.clipsToBounds = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightButton)
        rightButton.backgroundColor = .systemGray
        rightButton.setImage(UIImage(systemName: "heart"), for: .normal)
        rightButton.tintColor = .black
        NSLayoutConstraint.activate([
            rightButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rightButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            rightButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        rightButton.layer.cornerRadius = 10
        rightButton.clipsToBounds = true
        
    }
    
    func setData() {
        imgTop.loadImage(urlStr: recipe?.strMealThumb ?? "")
        lblIngredientName.text = recipe?.strMeal
        lblInstruction.text = recipe?.strInstructions
        lblIngredientsQuantity.text = "\(recipe?.ingredients.count ?? 0) \(Const.item)"
        
    }
    
    func openWeb(contentLink : String){
        guard let url = URL(string: contentLink) else { return }
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = UIColor.darkGray
        controller.preferredControlTintColor = UIColor.systemBackground
        controller.dismissButtonStyle = .close
        controller.configuration.barCollapsingEnabled = true
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }

    @IBAction func btnViewOnYouTubeTapped(_ sender: Any) {
        self.openWeb(contentLink: recipe?.strYoutube ?? "")
    }
}


extension RecipesDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTVC.identifire, for: indexPath) as! IngredientTVC
        cell.setData(ingredient: recipe?.ingredients[indexPath.row] ?? "", ingredientQuantity: recipe?.ingredientsMeasure[indexPath.row] ?? "")
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension RecipesDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
