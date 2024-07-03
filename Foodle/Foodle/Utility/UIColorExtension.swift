//
//  UIColorExtension.swift
//  Foodle
//
//  Created by 루딘 on 7/3/24.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexCode: String?, alpha: CGFloat = 1.0) {
        if let hexCode, !hexCode.isEmpty{
            var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        } else {
            self.init(cgColor: UIColor.accent.cgColor)
        }
    }
}
