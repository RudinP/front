//
//  AddMeetingPlaceTableViewCell.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class AddMeetingPlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepare()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(){
        cardView.layer.cornerRadius = 10
    }

}
