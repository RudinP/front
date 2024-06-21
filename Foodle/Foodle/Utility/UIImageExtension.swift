//
//  UIImageResize.swift
//  Foodle
//
//  Created by 루딘 on 3/28/24.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    func flippedVertically() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            
            context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
            context.draw(self.cgImage!, in: CGRect(origin: .zero, size: self.size))
            
            let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return flippedImage
        }
}

