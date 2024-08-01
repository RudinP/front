//
//  MyPlaceTableViewController.swift
//  Foodle
//
//  Created by 루딘 on 5/23/24.
//

import UIKit

class MyPlaceTableViewController: UIViewController {
    
    var placeListIndex: Int?
    var placeIndex: Int?
    var place: Place?
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailPlaceViewController{
            if let placeIndex, let placeLists{
                vc.place = placeLists[placeListIndex!].places?[placeIndex]
            }
            if let place{
                vc.place = place
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .placeAdded, object: nil, queue: .main) {_ in
            if let uid = user?.uid{
                fetchPlaceLists(uid) { result in
                    placeLists = result
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension MyPlaceTableViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let placeListIndex{
            return placeLists?[placeListIndex].places?.count ?? 0
        }
        if let place{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCell") as! ResultTableViewcell
        if let placeListIndex{
            if let placeLists, let target = placeLists[placeListIndex].places?[indexPath.row]{
                cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.addressLabel.text = target.address
                cell.breakLabel.text = "휴일 " + target.close
                cell.distanceLabel.text = target.distance
                cell.isOpenLabel.text = target.isWorking
                cell.placeCategoryLabel.text = target.category
                cell.placeNameLabel.text = target.placeName
                
                if let imageUrlString = target.images?.first {
                    cell.placeImageView.setImageFromStringURL(imageUrlString)
                }
            }
        }
        if let target = place{
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.addressLabel.text = target.address
            cell.breakLabel.text = "휴일 " + target.close
            cell.distanceLabel.text = target.distance
            cell.isOpenLabel.text = target.isWorking
            cell.placeCategoryLabel.text = target.category
            cell.placeNameLabel.text = target.placeName
            
            if let imageUrlString = target.images?.first {
                cell.placeImageView.setImageFromStringURL(imageUrlString)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeIndex = indexPath.row
        if let placeListIndex{
            guard let target = placeLists?[placeListIndex].places?[indexPath.row] else {return}
            NotificationCenter.default.post(name: .listPlaceSelected, object: nil, userInfo: ["place": target])
        }
        
        performSegue(withIdentifier: "ToDetail", sender: nil)
    }
    
}

extension Notification.Name{
    static let listPlaceSelected = Notification.Name("listPlaceSelected")
}
