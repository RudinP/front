//
//  SearchResultViewController.swift
//  Foodle
//
//  Created by 루딘 on 7/10/24.
//

import UIKit

var keyword = String()

class SearchResultViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var newMeeting: Meeting?
    var resultPlaces = [Place]()
    
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
        if let vc = segue.destination as? SearchViewController{
            vc.newMeeting = newMeeting
            vc.searchResults = resultPlaces
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultPlaces.removeAll()
        tableView.reloadData()
    }
    
}
extension SearchResultViewController: UISearchControllerDelegate, UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let keyword = (searchBar.text ?? "") + searchText
//        
//        if keyword.isEmpty {
//            resultPlaces.removeAll()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } else {
//            searchPlace(keyword) { result in
//                guard let result = result else { return }
//                resultPlaces = result
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultPlaces.removeAll()
        keyword.removeAll()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = (searchBar.text ?? "")
        
        if keyword.isEmpty {
            resultPlaces.removeAll()
            tableView.reloadData()
        } else {
            if newMeeting != nil{
                searchPlace(keyword, newMeeting) { result in
                    guard let result = result else { return }
                    self.resultPlaces = result
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                searchPlace(keyword) { result in
                    guard let result = result else { return }
                    self.resultPlaces = result
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        if !keyword.isEmpty && !resultPlaces.isEmpty{
            performSegue(withIdentifier: "toSearchView", sender: nil)
        }
        searchBar.resignFirstResponder()
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
        let selected = resultPlaces.remove(at: indexPath.row)
        resultPlaces.insert(selected, at: 0)
        performSegue(withIdentifier: "toSearchView", sender: nil)
    }
    
}
