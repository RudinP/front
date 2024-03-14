//
//  UpcomingCollectionViewCell.swift
//  Foodle
//
//  Created by 루딘 on 3/14/24.
//

import UIKit

class UpcomingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dDay: UILabel!
    @IBOutlet weak var meetName: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    func prepare(){
        cardView.layer.cornerRadius = 10
    }
}
