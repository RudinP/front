//
//  MainViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/14/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBAction func openMap(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationContrlloer()
    }
    
    func setNavigationContrlloer(){
        addSearchBar()
        addProfileIcon()
        
    }
    
    func addSearchBar(){
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        search.searchBar.placeholder = ""
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
        }
    
    func addProfileIcon(){
        let containView = UIView(frame: CGRect(x: 0, y: -5, width: 40, height: 40))
        let imageview = UIImageView(frame: containView.frame)
        imageview.image = UIImage(systemName: "pawprint.circle")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        imageview.layer.cornerRadius = imageview.frame.width / 2
        imageview.layer.masksToBounds = true
        containView.addSubview(imageview)
        
        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return 5
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        if indexPath.section != 0 || indexPath.row != 0{
            cell.prepare(color: .systemGray6)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0 : "오늘의 약속"
        case 1: "다가오는 약속"
        default: ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0 : 50
        case 1: 50
        default: 0
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        if section == 0 {
            var config = header.defaultContentConfiguration()
            config.textProperties.font = UIFont.boldSystemFont(ofSize: 30)
            config.textProperties.color = .black
            config.text = "오늘의 약속"
            
            header.contentConfiguration = config
        } else if section == 1{
            var config = header.defaultContentConfiguration()
            config.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
            config.textProperties.color = .gray
            config.text = "다가오는 약속"
            
            header.contentConfiguration = config

        }
    }
}



