//
//  AppCoordinator.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 03/08/24.
//

import Foundation
import UIKit

class AppCoordinator {
    
    private unowned var window : UIWindow
    private var currentRoute : Route? = nil
    func getCurrentRoute()->Route?{
        return currentRoute
    }
    init(window:UIWindow) {
        self.window = window
        currentRoute = self.setRootView()
    }
    
    
    func setRootView()->Route?{
        
        var rootRoute : Route? = nil
        var viewController : UIViewController? = nil
        rootRoute = .Recipes
        viewController = Storyboards.mainSB.instantiateViewController(identifier: "RecipesViewController") { coder in
            RecipesViewController(model: RecipeModel(apiManager: APIManager()), coordinator: self, coder: coder)
        }
        if viewController != nil{
            let navigation = UINavigationController(rootViewController: viewController!)
            self.window.rootViewController = navigation
        }
        return rootRoute
    }
    
    func onRouteEnd(route:Route , outPut: Any? = nil ) {
        switch route {
        case .Recipes:
            if let res = outPut as? RacipeDataModel {
                loadRoute(route: .RecipeDetail, payload: res)
            }
        default:
            break
        }
    }
    
    private func loadRoute(route:Route, payload: Any? = nil ){
        var viewController : UIViewController? = nil
        switch route {
        case .Recipes:
            viewController = Storyboards.mainSB.instantiateViewController(identifier: "RecipesViewController") { coder in
                RecipesViewController( model: RecipeModel(apiManager: APIManager()), coordinator: self, coder: coder)
            }
        case .RecipeDetail:
            guard let model = payload as? RacipeDataModel else { return }
            viewController = Storyboards.mainSB.instantiateViewController(identifier: "RecipesDetailViewController") { coder in
                RecipesDetailViewController(recipe: model, coordinator: self, coder: coder)
            }
        }
        
        if viewController != nil{
            currentRoute = route
            (self.window.rootViewController as? UINavigationController)?.pushViewController(viewController!, animated: true)
        }
    }
}
