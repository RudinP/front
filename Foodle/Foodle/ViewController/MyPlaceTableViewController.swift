//
//  MyPlaceTableViewController.swift
//  Foodle
//
//  Created by 루딘 on 5/23/24.
//

import UIKit

class MyPlaceTableViewController: UITableViewController {
    
    var placeListIndex: Int?
    var placeIndex: Int?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailPlaceViewController{
            if let placeIndex{
                vc.place = dummyPlaceLists[placeListIndex!].places?[placeIndex]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let placeListIndex{
            return dummyPlaceLists[placeListIndex].places?.count ?? 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCell") as! ResultTableViewcell
        if let placeListIndex{
            if let target = dummyPlaceLists[placeListIndex].places?[indexPath.row]{
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.addressLabel.text = target.address
                cell.breakLabel.text = "휴일 " + target.close
                cell.distanceLabel.text = target.distance
                cell.isOpenLabel.text = target.isWorking
                cell.placeCategoryLabel.text = target.category
                cell.placeNameLabel.text = target.placeName
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeIndex = indexPath.row
        performSegue(withIdentifier: "ToDetail", sender: nil)
    }
}
