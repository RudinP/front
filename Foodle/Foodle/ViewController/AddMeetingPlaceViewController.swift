//
//  AddMeetingPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/21/24.
//

import UIKit

class AddMeetingPlaceViewController: UIViewController{
    
    @IBOutlet weak var addMeetingPlaceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
}

extension AddMeetingPlaceViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
}

extension AddMeetingPlaceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addMeetingPlaceTableView.dequeueReusableCell(withIdentifier: "AddMeetingPlaceTableViewCell", for: indexPath) as? AddMeetingPlaceTableViewCell else {return UITableViewCell()}
        
        cell.placeLabel.text = "가나다라마바사아자차카타파하"
        cell.timeLabel.text = "11:00am"
        cell.orderLabel.text = "\(indexPath.row + 1)"
        
        
        
        return cell
    }
    
    
}
