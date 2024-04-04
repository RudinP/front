//
//  PlaceImageCollectionViewCell.swift
//  Foodle
//
//  Created by 루딘 on 4/4/24.
//

import UIKit

class PlaceImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeImageView.layer.cornerRadius = 10
    }
}
