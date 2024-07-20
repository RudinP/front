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
            guard let uid = user?.uid else {return}
            fetchPlaceLists(uid) { result in
                placeLists = result
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MyPlaceTableViewController{
            vc.placeListIndex = selectedIndex
        }
    }
    
    private func setSheetView(){
        
        let bottomSheetVCSB = UIStoryboard(name: "Jinhee", bundle: nil)
        if let bottomSheetVC = bottomSheetVCSB.instantiateViewController(withIdentifier: "MyPlaceTableViewController") as? MyPlaceTableViewController{
            bottomSheetVC.placeListIndex = selectedIndex
            if let sheet = bottomSheetVC.sheetPresentationController {
                let fraction = UISheetPresentationController.Detent.custom { context in
                    140
                }
                sheet.detents = [.medium(), .large(), fraction]
                sheet.largestUndimmedDetentIdentifier = .medium  // nil 기본값
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
                sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
                sheet.prefersGrabberVisible = true
            }
            
            bottomSheetVC.isModalInPresentation = true
            
            present(bottomSheetVC, animated: true, completion: nil)
        }
    }


}

extension MyPlaceScrollableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceTableViewCell") as! MyPlaceTableViewCell
        guard let placeLists else { return cell }
        cell.circleImageView.tintColor = UIColor(hexCode: placeLists[indexPath.row].color, alpha: 1.0)
        cell.listNameLabel.text = placeLists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toPlaceTable", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let alert = UIAlertController(title: "알림", message: "리스트를 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { _ in
                let target = placeLists?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if let target{
                    deletePlaceList(target) {
                        NotificationCenter.default.post(name: .addedList, object: nil, userInfo: nil)
                    }
                }
            }
            let no = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(no)
            alert.addAction(ok)
            
            present(alert,animated: true)
        }
    }
        
}

