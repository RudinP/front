//
//  mainCollectionViewCell.swift
//  Foodle
//
//  Created by 루딘 on 3/14/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeTime: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    @IBAction func openMap(_ sender: Any) {
    }
    
    func prepare(bgColor: UIColor, textColor: UIColor){
        self.layer.cornerRadius = 10
        self.cardView.backgroundColor = bgColor
        
        self.date.textColor = textColor
        self.meetingName.textColor = textColor
        self.placeName.textColor = textColor
        self.placeTime.textColor = textColor
    }
    
}
