//
//  MainViewController.swift
//  Foodle
//
//  Created by 루딘 on 3/14/24.
//

import UIKit

class MainViewController: UIViewController, MainTableViewCellDelegate {
    
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var addMeetButton: UIButton!
    @IBOutlet weak var floatingStackView: UIStackView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedSection: Int?
    var selectedIndex: Int?
    var selectedItemIndex: Int?
    
    lazy var buttons: [UIButton] = [self.addMeetButton]
    var isFloatShowing = false
    var profileImg: UIImage?

    lazy var floatingDimView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true

        self.view.insertSubview(view, belowSubview: self.floatingStackView)

        return view
    }()
    
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, sender: Any?) -> Bool {
        showFloatMenu(floatingButton)
        return true
    }
    
    @IBAction func openMap(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSearchBar()
        updateDaily()
        
        NotificationCenter.default.addObserver(forName: .meetingAdded, object: nil, queue: .main){_ in 
            if let uid = user?.uid{
                fetchMeeting(uid) { result in
                    meetings = result
                    DispatchQueue.main.async{
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addProfileIcon(user?.profileImage)
    }
    
    func updateDaily(){
        let calendar = Calendar.current
        
        let now = Date()
        let date = calendar.date(bySettingHour: 00, minute: 00, second: 0, of: now)!
        
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(reloadData), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func reloadData(){
        meetingsToday = getToday(meetings: meetings)
        meetingsUpcoming = getUpcoming(meetings: meetings)
        if mainTableView != nil{
            mainTableView.reloadData()
        }
    }
    
    
    func addSearchBar(){
        let search = UISearchController()
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        search.searchBar.placeholder = ""
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
        search.searchBar.searchTextField.autocorrectionType = .no
        search.searchBar.searchTextField.spellCheckingType = .no
    }
    
    func addProfileIcon(_ image: String?){
        let profileButton = UIButton(frame: CGRect(x: 0, y: -5, width: 40, height: 40))
        profileButton.layer.cornerRadius = profileButton.frame.height / 2
        profileButton.clipsToBounds = true
        profileButton.contentMode = .scaleAspectFill
        profileButton.setBackgroundImage(profileImg ?? UIImage(systemName: "pawprint.circle"), for: .normal)


        if profileImg == nil, let str = user?.profileImage, let url = URL(string: str){
            url.asyncImage { image in
                DispatchQueue.main.async{
                    profileButton.setBackgroundImage(image ?? UIImage(systemName: "pawprint.circle"), for: .normal)
                    self.profileImg = image?.resize(newWidth: 40)
                }
            }
        }
        profileButton.addTarget(self, action: #selector(toProfile), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        
    }
    
    @objc func toProfile(){
        performSegue(withIdentifier: "ToProfile", sender: nil)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    func showFloat(){
        buttons.forEach { [weak self] button in
            button.isHidden = false
            button.alpha = 0

            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
                self?.view.layoutIfNeeded()
            }
        }
        
    }
    
    func hideFloat(){
        buttons.reversed().forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = true
                self.view.layoutIfNeeded()
            }
        }

    }
    
    func dimViewAnim(_ flag: Bool){
        if flag{
            /** DimView Show 애니메이션 **/
            UIView.animate(withDuration: 0.5, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else{
            /** DimView Hide 애니메이션 **/
            self.floatingDimView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.floatingDimView.alpha = 1
            }
        }
    }
    
    @IBAction func showFloatMenu(_ sender: UIButton) {
                
        if isFloatShowing{
            hideFloat()
            dimViewAnim(isFloatShowing)
        } else {
            showFloat()
            dimViewAnim(isFloatShowing)
        }
        
        isFloatShowing = !isFloatShowing
        let rotation = isFloatShowing ? CGAffineTransform(rotationAngle: .pi - (.pi / 4)) : CGAffineTransform.identity
        UIView.animate(withDuration: 0.3) {
            sender.transform = rotation
        }
    }
    
    func didSelectItem(section: Int, index: Int, itemIndex: Int) {
        guard selectedSection != section || selectedIndex != index || selectedItemIndex != itemIndex else {
            return
        }
        
        selectedSection = section
        selectedIndex = index
        selectedItemIndex = itemIndex
        
        performSegue(withIdentifier: "detailMeeting", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMeeting" {
            guard let detailVC = segue.destination as? DetailMeetingViewController else { return }
            
            detailVC.section = selectedSection
            detailVC.index = selectedIndex
            detailVC.collectionViewItem = selectedItemIndex
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return meetingsToday.isEmpty ? 1 : meetingsToday.count
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        cell.section = indexPath.section
        cell.index = indexPath.row
        
        if indexPath.row != 0 {
            cell.prepare(bgColor: .systemGray6, textColor: .gray)
        } else {
            cell.prepare(bgColor: .secondAccent, textColor: .black)
        }
        
        cell.delegate = self
        cell.configure()
        
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
        case 0 : 70
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

extension MainViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "showSearch", sender: nil)
    }
}
