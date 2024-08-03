//
//  BaseViewController.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 03/08/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    private(set) unowned var coordinator : AppCoordinator

    init?(coordinator:AppCoordinator ,coder: NSCoder) {
        self.coordinator = coordinator
        super.init(coder: coder)
    }
    @available(*, unavailable, renamed: "init(config:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("base viewDidLoad")
    }
    
    
    func setNavigationBarWithTitle(title: String){
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: title, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black ,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        navLabel.frame.size.width = (UIScreen.main.bounds.width - 40)
        navLabel.numberOfLines = 0
        navLabel.textAlignment = .center
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
}
