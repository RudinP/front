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
                
        if let place, let placeLists{
            for i in 0 ..< placeLists.count{
                if let places = placeLists[i].places, places.contains(where: {
                    $0.isEqual(place)
                }){
                    selectedIndexPath.append(IndexPath(row: i, section: 0))
                    if let name = placeLists[i].name{
                        str.append(name)
                    }
                }
            }
        }
        
        if !str.isEmpty{
            dropdownBtn.setTitle(str.joined(separator: ","), for: .normal)
            dropdownBtn.setTitle(str.joined(separator: ","), for: .selected)
        }
        
        NotificationCenter.default.addObserver(forName: .addedList, object: nil, queue: .main) { _ in
            guard let uid = user?.uid else {return}
            fetchPlaceLists(uid) { result in
                placeLists = result
                DispatchQueue.main.async{
                    self.listTableView.reloadData()
                }
            }
        }
    }
    
    func popUpListAddView(){
        
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        self.listTableView.isHidden = !self.listTableView.isHidden
    }
    
    @IBAction func addPlace(_ sender: Any) {
        let indexes = selectedIndexPath.map { $0.row }
        for i in 0..<(placeLists?.count ?? 0){
            if indexes.contains(i){
                placeLists?[i].addPlace(place)
            } else {
                placeLists?[i].removePlace(place)
            }
        }
        
        NotificationCenter.default.post(name: .placeAdded, object: nil)
        
        dismiss(animated: true)
    }
    
}

extension AddPlaceViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (placeLists?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        
        
        //리스트 추가 셀 생성
        if indexPath.row == placeLists?.count{
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.text = "리스트 추가하기"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.accent
            cell.accessoryType = .none
        } else {
            guard let placeLists else {return cell}
            cell.imageView?.image = UIImage(systemName: "circle.fill")
            cell.accessoryType = selectedIndexPath.contains(indexPath) ? .checkmark : .none
            cell.imageView?.tintColor = UIColor(hexCode: placeLists[indexPath.row].color)
            cell.textLabel?.text = placeLists[indexPath.row].name
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listTableView.isHidden = true
        
        guard let placeLists else {return}
        if selectedIndexPath.contains(indexPath){
            str.removeAll {
                $0 == placeLists[indexPath.row].name
            }
            
            self.selectedIndexPath.removeAll(where: {
                $0 == indexPath
            })
            
            if let currentCell = tableView.cellForRow(at: indexPath) {
                currentCell.accessoryType = .none
            }
            
        } else if indexPath.row < placeLists.count{
            if let name = placeLists[indexPath.row].name{
                str.append(name)
            }
            self.selectedIndexPath.append(indexPath)
            if let currentCell = tableView.cellForRow(at: indexPath) {
                currentCell.accessoryType = .checkmark
            }
        }
        
        if indexPath.row != placeLists.count{
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
