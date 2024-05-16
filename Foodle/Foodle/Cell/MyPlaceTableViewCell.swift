//
//  MyPlaceTableViewCell.swift
//  Foodle
//
//  Created by 루딘 on 5/16/24.
//

import UIKit

class MyPlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    var color: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circleImageView.tintColor = color ?? .accent
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
