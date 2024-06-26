//
//  RoundedCollectionViewCell.swift
//  Foodle
//
//  Created by 루딘 on 6/26/24.
//

import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
}
