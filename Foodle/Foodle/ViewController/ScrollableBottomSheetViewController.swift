
import UIKit

class ScrollableBottomSheetViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var targetIndex: Int?
    var newMeeting: Meeting?
    
    @IBAction func addPlaceToList(_ sender: UIButton) {
        targetIndex = sender.tag
        performSegue(withIdentifier: "addPlaceToList", sender: nil)
    }
    
    @IBAction func addMeetingPlace(_ sender: UIButton) {
        NotificationCenter.default.post(name: .meetingPlaceAdded, object: nil, userInfo: ["placeToMeet":resultPlaces[sender.tag]])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPlaceToList"{
            if let vc = segue.destination as? AddPlaceViewController{
                if let targetIndex{
                    vc.place = resultPlaces[targetIndex]
                }
            }
        } else if segue.identifier == "showDetail"{
            if let vc = segue.destination as? DetailPlaceViewController{
                if let targetIndex{
                    vc.place = resultPlaces[targetIndex]
                }
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
        
        NotificationCenter.default.addObserver(forName: .annotationSelected, object: nil, queue: .main) { noti in
            guard let place = noti.userInfo?["place"] as? Place else {return}
            let row = resultPlaces.firstIndex { resultPlace in
                place.isEqual(resultPlace)
            }
            let indexPath = IndexPath(row: row ?? 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
}

extension ScrollableBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard newMeeting != nil else { return 170 }
        return 218
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCell") as! ResultTableViewcell
        let target = resultPlaces[indexPath.row]
        if target.getIsStarred(){
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        if newMeeting != nil{
            cell.hideButton(false)
        } else {
            cell.hideButton(true)
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
        cell.addMeetingPlaceButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        targetIndex = indexPath.row
        tableView.scrollToNearestSelectedRow(at: .top, animated: true)
        if let index = targetIndex{
            let place = resultPlaces[index]
            NotificationCenter.default.post(name: .placeSelected, object: nil, userInfo: ["place": place])
        }
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}

extension Notification.Name{
    static let meetingPlaceAdded = Notification.Name("meetingPlaceAdded")
    static let placeSelected = Notification.Name("placeSelected")
}
