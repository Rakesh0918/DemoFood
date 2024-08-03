//
//  ViewController.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 01/08/24.
//

import UIKit

class RecipesViewController: BaseViewController {
    
    @IBOutlet weak var tblReceipe: UITableView!
    let model: RecipeModel
    init?(model: RecipeModel, coordinator:AppCoordinator, coder: NSCoder) {
        self.model = model
        super.init(coordinator: coordinator, coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(config:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithTitle(title: Const.tastebuds)
        tblReceipe.dataSource = self
        tblReceipe.delegate = self
        model.delegate = self
        tblReceipe.register(RecipeTableViewCell.nib, forCellReuseIdentifier: RecipeTableViewCell.identifire)
        loadRecipes()
    }
    func loadRecipes() {
        Task {
            do {
                try await self.model.fetchRecipes()
            }catch {
                print(error)
            }
        }
    }
}

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifire, for: indexPath) as! RecipeTableViewCell
        let recipe = model.recipes[indexPath.row]
        cell.setData(with: recipe)
        cell.lblInstructions.tag = indexPath.row
        cell.reloadDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.onRouteEnd(route: .Recipes, outPut: model.recipes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        headerLabel.text = Const.popularRecipes
        headerLabel.textColor = .black
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.sizeToFit()
        headerView.backgroundColor = .clear
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension RecipesViewController: ReloadDelegate{
    func reloadCell(index: Int) {
        model.recipes[index].isExpanded = !(model.recipes[index].isExpanded ?? false)
        tblReceipe.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}


extension RecipesViewController: ReloadView{
    func reloadData() {
        DispatchQueue.main.async {
            self.tblReceipe.reloadData()
        }
    }
}
