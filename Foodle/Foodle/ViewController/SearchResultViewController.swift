//
//  SearchResultViewController.swift
//  Foodle
//
//  Created by 루딘 on 7/10/24.
//

import UIKit

var resultPlaces = [Place]()
var keyword = String()

class SearchResultViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!

    
    func addSearchBar(){
        let search = UISearchController()
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        search.searchBar.placeholder = ""
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
        search.searchBar.searchTextField.autocorrectionType = .no
        search.searchBar.searchTextField.spellCheckingType = .no
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        addSearchBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
}
extension SearchResultViewController: UISearchControllerDelegate, UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        keyword = text + searchText
        searchPlace(keyword) { result in
            guard let result else { return }
            resultPlaces = result
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        let target = resultPlaces[indexPath.row]
        cell.textLabel?.text = target.placeName
        cell.detailTextLabel?.text = target.address
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultPlaces.swapAt(0, indexPath.row)
        performSegue(withIdentifier: "toSearchView", sender: nil)
    }
    
}
