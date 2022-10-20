//
//  UIImageViewExtension.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 19/6/22.
//

import UIKit

extension UIImageView {
  
  func setImage(url: String) {
    guard let url = URL(string: url) else { return }
    
    downloadWithUrlSession(url: url) { [weak self] image in
      DispatchQueue.main.async {
        self?.image = image
      }
    }
  }
  
  private func downloadWithUrlSession(url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      
      guard let data = data,
            let image = UIImage(data: data) else {
        completion(nil)
        return
      }
      
      completion(image)
      
    }.resume()
  }
}
