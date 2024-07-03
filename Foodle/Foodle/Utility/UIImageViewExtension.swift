//
//  UIImageViewExtension.swift
//  Foodle
//
//  Created by 루딘 on 7/3/24.
//

import Foundation
import UIKit

extension UIImageView{
    func setImageFromStringURL(_ stringUrl: String) {
      if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          // Error handling...
          guard let imageData = data else { return }

          DispatchQueue.main.async {
            self.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }
}
