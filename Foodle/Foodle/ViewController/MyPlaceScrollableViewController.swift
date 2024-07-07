//
//  MyPlaceScrollableViewController.swift
//  Foodle
//
//  Created by 루딘 on 5/16/24.
//

import UIKit

class MyPlaceScrollableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(forName: .addedList, object: nil, queue: .main) { _ in
            self.tableView.reloadData()
        }
    }
    
    private func setSheetView(){
        
        let bottomSheetVCSB = UIStoryboard(name: "Jinhee", bundle: nil)
        if let bottomSheetVC = bottomSheetVCSB.instantiateViewController(withIdentifier: "MyPlaceTableViewController") as? MyPlaceTableViewController{
            bottomSheetVC.placeListIndex = selectedIndex
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium  // nil 기본값
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
                sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
                sheet.prefersGrabberVisible = true
            }
            
            bottomSheetVC.isModalInPresentation = true
            
            present(bottomSheetVC, animated: false, completion: nil)
        }
    }


}

extension MyPlaceScrollableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPlaceLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceTableViewCell") as! MyPlaceTableViewCell
        cell.circleImageView.tintColor = UIColor(hexCode: dummyPlaceLists[indexPath.row].color, alpha: 1.0)
        cell.listNameLabel.text = dummyPlaceLists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        setSheetView()
    }
        
}

