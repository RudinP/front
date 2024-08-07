//
//  DefaultTableViewCell.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 10/15/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit

class ResultTableViewcell: UITableViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeCategoryLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var addMeetingPlaceButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideButton(_ hide: Bool){
        addMeetingPlaceButton.isHidden = hide
    }
    
}
