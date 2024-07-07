
import UIKit

class ScrollableBottomSheetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var targetIndex: Int?
    
    @IBAction func addPlaceToList(_ sender: UIButton) {
        targetIndex = sender.tag
        performSegue(withIdentifier: "addPlaceToList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddPlaceViewController{
            if let targetIndex{
                vc.place = dummyPlaces[targetIndex]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(forName: .placeAdded, object: nil, queue: .main) { _ in
            self.tableView.reloadData()
        }
        
    }
    
}

extension ScrollableBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCell") as! ResultTableViewcell
        let target = dummyPlaces[indexPath.row]
        if target.getIsStarred(){
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.addressLabel.text = target.address
        cell.breakLabel.text = "휴일 " + target.close
        cell.distanceLabel.text = target.distance
        cell.isOpenLabel.text = target.isWorking
        cell.placeCategoryLabel.text = target.category
        cell.placeNameLabel.text = target.placeName
        
        if let imageUrlString = target.images?.first {
            cell.placeImageView.setImageFromStringURL(imageUrlString)
        }
        
        cell.starButton.tag = indexPath.row
        
        return cell
    }
    
    
}
