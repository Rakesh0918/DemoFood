//
//  RecipeModel.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 03/08/24.
//

import Foundation

protocol ReloadView: AnyObject{
    func reloadData()
}


class RecipeModel {
    let apiManager : APIManager
    var recipes: [RacipeDataModel] = []
    var delegate: ReloadView?
    init(apiManager : APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchRecipes() async throws{
        do {
            if let userResponseArray: Meals = try await apiManager.request(url: userURL) {
                self.recipes = userResponseArray.meals
                delegate?.reloadData()
            }else {
                throw DataError.parsingError
            }
        }catch {
            throw error
        }
    }
    
}
