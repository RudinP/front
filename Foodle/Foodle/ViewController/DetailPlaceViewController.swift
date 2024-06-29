//
//  DetailPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 4/4/24.
//

import UIKit

class DetailPlaceViewController: UIViewController {
    var place: Place?
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var isWorkingLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var todayWorkingLabel: UILabel!
    @IBOutlet weak var workingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNameLabel.text = place?.placeName
        isWorkingLabel.text = place?.isWorking
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        addressLabel.text = place?.address
        distanceLabel.text = place?.distance
        rateLabel.text = "네이버 평점" + (place?.rate?.formatted() ?? "0")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale =  Locale(identifier: "ko_KR")
        let today = formatter.string(from: Date())
        todayWorkingLabel.text = today + (place?.working.first(where: { (key: Day, value: String) in
            return key == Day(rawValue: today)
        })?.value ?? "") + "   브레이크타임 " + (place?.breakTime.first(where: { (key: Day, value: String) in
            return key == Day(rawValue: today)
        })?.value ?? "")

        
        var str = ""
        for work in place?.working ?? [:]{
            if work.key.rawValue == today{
                continue
            }
            let val = place?.breakTime[work.key] ?? ""
            str.append("\(work.key.rawValue) \(work.value)   브레이크타임 \(val)\n")
        }
        workingLabel.text = str
        
    }
    @IBAction func openReview(_ sender: Any) {
        if let str = place?.reviewURL, let url = URL(string: str) {
                UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func openInsta(_ sender: Any) {
        if let str = place?.instaURL, let url = URL(string: str) {
                UIApplication.shared.open(url, options: [:])
        }
    }
}

extension DetailPlaceViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCell", for: indexPath) as? PlaceImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.placeImageView.image = UIImage(named: "dummy")
        
        return cell
    }
    
    
}
