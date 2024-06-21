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
    var list = ["리스트1","리스트2","리스트3"]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.isHidden = true
        
        listTableView.layer.borderWidth = 1
        listTableView.layer.cornerRadius = 5
        listTableView.layer.borderColor = UIColor.accent.cgColor
    }
    
    func popUpListAddView(){
        
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        self.listTableView.isHidden = !self.listTableView.isHidden
    }
    
    @IBAction func addPlace(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddPlaceViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        
        //리스트 추가 셀 생성
        if indexPath.row == list.count{
            cell.imageView?.image = UIImage(systemName: "plus.circle")
            cell.textLabel?.text = "리스트 추가하기"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.accent
            cell.accessoryType = selectedIndexPath == indexPath ? .checkmark : .none
        } else {
            cell.textLabel?.text = list[indexPath.row]
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listTableView.isHidden = true
        
        if let selectedIndexPath = selectedIndexPath {
            
            if let previousCell = tableView.cellForRow(at: selectedIndexPath) {
                previousCell.accessoryType = .none
            }
        }
        
        if let currentCell = tableView.cellForRow(at: indexPath) {
            currentCell.accessoryType = .checkmark
        }
        
        selectedIndexPath = indexPath
        
        if indexPath.row != list.count{
            dropdownBtn.setTitle(list[indexPath.row], for: .normal)
            dropdownBtn.setTitle(list[indexPath.row], for: .selected)
        } else {
            let storyBoard = UIStoryboard.init(name: "Jinhee", bundle: nil)
            let popupVC = storyBoard.instantiateViewController(withIdentifier: "AddListViewController")
            popupVC.modalPresentationStyle = .overFullScreen
            present(popupVC, animated: false, completion: nil)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            dropdownBtn.setTitle("리스트 선택하기", for: .normal)
            dropdownBtn.setTitle("리스트 선택하기", for: .selected)
        }
        
    }
    
}
