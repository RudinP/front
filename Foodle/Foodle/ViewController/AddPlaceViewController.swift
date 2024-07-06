//
//  AddPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 6/19/24.
//

import UIKit

class AddPlaceViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var dropdownBtn: UIButton!
    var selectedIndexPath: [IndexPath] = [IndexPath]()
    var place: Place?
    var str: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.isHidden = true
        
        listTableView.layer.borderWidth = 1
        listTableView.layer.cornerRadius = 5
        listTableView.layer.borderColor = UIColor.accent.cgColor
        
        var config = dropdownBtn.configuration
        config?.titleLineBreakMode = .byTruncatingTail
        dropdownBtn.configuration = config
                
        if let place{
            for i in 0 ..< dummyPlaceLists.count{
                if let places = dummyPlaceLists[i].places, places.contains(where: {
                    $0.isEqual(place)
                }){
                    selectedIndexPath.append(IndexPath(row: i, section: 0))
                    if let name = dummyPlaceLists[i].name{
                        str.append(name)
                    }
                }
            }
        }
        
        if !str.isEmpty{
            dropdownBtn.setTitle(str.joined(separator: ","), for: .normal)
            dropdownBtn.setTitle(str.joined(separator: ","), for: .selected)
        }
    }
    
    func popUpListAddView(){
        
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        self.listTableView.isHidden = !self.listTableView.isHidden
    }
    
    @IBAction func addPlace(_ sender: Any) {
        let indexes = selectedIndexPath.map { $0.row }
        for i in 0..<dummyPlaceLists.count{
            if indexes.contains(i){
                dummyPlaceLists[i].addPlace(place)
            } else {
                dummyPlaceLists[i].removePlace(place)
            }
        }
        
        print(dummyPlaceLists)
        NotificationCenter.default.post(name: .placeAdded, object: nil)
        
        dismiss(animated: true)
    }
    
}

extension AddPlaceViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPlaceLists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        
        //리스트 추가 셀 생성
        if indexPath.row == dummyPlaceLists.count{
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.text = "리스트 추가하기"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.accent
            cell.accessoryType = .none
        } else {
            cell.accessoryType = selectedIndexPath.contains(indexPath) ? .checkmark : .none
            cell.imageView?.tintColor = UIColor(hexCode: dummyPlaceLists[indexPath.row].color)
            cell.textLabel?.text = dummyPlaceLists[indexPath.row].name
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listTableView.isHidden = true
        
        if selectedIndexPath.contains(indexPath){
            str.removeAll {
                $0 == dummyPlaceLists[indexPath.row].name
            }
            
            self.selectedIndexPath.removeAll(where: {
                $0 == indexPath
            })
            
            if let currentCell = tableView.cellForRow(at: indexPath) {
                currentCell.accessoryType = .none
            }
            
        } else {
            if let name = dummyPlaceLists[indexPath.row].name{
                str.append(name)
            }
            self.selectedIndexPath.append(indexPath)
            if let currentCell = tableView.cellForRow(at: indexPath) {
                currentCell.accessoryType = .checkmark
            }
        }
        
        if indexPath.row != dummyPlaceLists.count{
            if selectedIndexPath.isEmpty{
                dropdownBtn.setTitle("리스트 선택하기", for: .normal)
                dropdownBtn.setTitle("리스트 선택하기", for: .selected)
            } else {
                dropdownBtn.setTitle(str.joined(separator: ","), for: .normal)
                dropdownBtn.setTitle(str.joined(separator: ","), for: .selected)
            }
        } else {
            let storyBoard = UIStoryboard.init(name: "Jinhee", bundle: nil)
            let popupVC = storyBoard.instantiateViewController(withIdentifier: "AddListViewController")
            popupVC.modalPresentationStyle = .overFullScreen
            present(popupVC, animated: false, completion: nil)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
    }
    
}

extension Notification.Name{
    static let placeAdded = Notification.Name(rawValue: "placeAdded")
}
