//
//  CustomImageView.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 01/08/24.
//

import UIKit

class CustomImageView: UIImageView {
    private var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
        if let activityIndicator = activityIndicator {
            addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    private func showActivityIndicator() {
        activityIndicator?.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
    }
    
    func loadImage(urlStr: String) {
        var task: URLSessionTask?
        guard let url = URL(string: urlStr) else { return }
        image = nil
        showActivityIndicator()
        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            guard let data = data, let newImage = UIImage(data: data) else {
                print("couldn't load image from url: \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task?.resume()
    }
    
    func loadImageForIngredients(ingredient: String) {
        var task: URLSessionTask?
        guard let url = URL(string: "\(ingredient).png", relativeTo: URL(string: baseURL))  else { return }
        print("IngredientURL: ", url)
        image = nil
        showActivityIndicator()
        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            guard let data = data, let newImage = UIImage(data: data) else {
                print("couldn't load image from url: \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task?.resume()
    }
}
