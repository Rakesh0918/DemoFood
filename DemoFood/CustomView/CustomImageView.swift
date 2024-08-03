//
//  CustomImageView.swift
//  DemoFood
//
//  Created by Rakesh Sharma on 01/08/24.
//

import UIKit

class CustomImageView: UIImageView {
    
    func loadImage(urlStr: String) {
        var task: URLSessionTask!
        guard let url = URL(string: urlStr) else { return }
        image = nil
        if let task = task {
            task.cancel()
        }
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("couldn't load image from url: \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = newImage
            }
        })
        task.resume()
    }
    
    func loadImageForIngredients(ingredient: String) {
        var task: URLSessionTask!
        guard let url = URL(string: "\(ingredient).png", relativeTo: URL(string: baseURL))  else { return }
        print("IngedientURL: ", url)
        image = nil
        if let task = task {
            task.cancel()
        }
        task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("couldn't load image from url: \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = newImage
            }
        })
        task.resume()
    }
}
