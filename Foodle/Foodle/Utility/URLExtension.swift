//
//  URLExtension.swift
//  Foodle
//
//  Created by 루딘 on 7/16/24.
//

import UIKit

extension URL {
    func asyncImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: self) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
