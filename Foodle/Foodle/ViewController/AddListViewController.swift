//
//  AddListViewController.swift
//  Foodle
//
//  Created by 루딘 on 6/20/24.
//

import UIKit

class AddListViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var listNameTextField: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    let colorList = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.black, UIColor.accent]
    var selectedColor: UIColor?
    var listName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        listNameTextField.layer.borderColor = UIColor.accent.cgColor
        
        listNameTextField.delegate = self
        
        popUp()
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func addList(_ sender: Any) {
        if let listName, let selectedColor{
            dummyPlaceLists.append(PlaceList(listID: dummyPlaceLists.last?.listID ?? 0 + 1, name: listName, color: selectedColor.toHexString(), places: [Place]()))
            
            NotificationCenter.default.post(name: .addedList, object: nil)
            
            dismiss(animated: false)
        } else {
            alertPop()
        }
    }
    
    func alertPop(){
        let cont = UIAlertController(title: "주의", message: "", preferredStyle: .alert)
        if listName == nil {
            cont.message?.append("리스트의 이름을 입력해주세요.\n")
        }
        if selectedColor == nil {
            cont.message?.append("리스트의 색상을 선택해주세요.")
        }
        
        let ok = UIAlertAction(title: "확인", style: .default)
        cont.addAction(ok)
        
        present(cont, animated: true)
    }
    
    func popUp(){
        let containerView = UIView()
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 1
        containerView.addSubview(popUpView)
        
        popUpView.layer.cornerRadius = 25
        popUpView.clipsToBounds = true
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
}


extension AddListViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        
        let symbolImage = UIImage(systemName: "circle.fill")
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .default)
        let configuredImage = symbolImage?.withConfiguration(configuration)
        
        cell.imageView.image = configuredImage
        cell.imageView.tintColor = colorList[indexPath.item]
        cell.checkMarkImageView.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 2  // 컬렉션뷰의 너비를 두 개의 열로 나누고 간격을 고려
        return CGSize(width: height, height: height)  // 셀의 크기 설정 (정사각형으로 설정)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
        selectedColor = colorList[indexPath.item]
        cell.checkMarkImageView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
        selectedColor = colorList[indexPath.item]
        cell.checkMarkImageView.isHidden = true
    }
    
}

extension AddListViewController: UITextFieldDelegate{

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard let text = textField.text else {return true}
        listName = text + string
        return true
    }
}

extension Notification.Name{
    static let addedList = Notification.Name(rawValue: "addedList")
}
