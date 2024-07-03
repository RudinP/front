//
//  MyPlaceScrollableViewController.swift
//  Foodle
//
//  Created by 루딘 on 5/16/24.
//

import UIKit

class MyPlaceScrollableViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
       
    var fullView: CGFloat = 100
    var partialView: CGFloat {
        UIScreen.main.bounds.height - headerView.bounds.height - (self.tabBarController?.tabBar.bounds.height ?? 49)
    }
    var secondPartialView: CGFloat {
        UIScreen.main.bounds.height - headerView.bounds.height - 300 - (self.tabBarController?.tabBar.bounds.height ?? 49)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(MyPlaceScrollableViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    var childView: UIView!
    var button: UIButton?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.secondPartialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
            })
        self.view.roundCorners(corners: [.topLeft,.topRight], radius: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func returnToList(_ sender: UIButton){
        stackView.removeArrangedSubview(childView)
        sender.removeFromSuperview()
        button = nil
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.secondPartialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                    }
            })
        }
    }

}

extension MyPlaceScrollableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyPlaceLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceTableViewCell") as! MyPlaceTableViewCell
        cell.color = UIColor(hexCode: dummyPlaceLists[indexPath.row].color, alpha: 1.0)
        cell.listNameLabel.text = dummyPlaceLists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bottomSheetVCSB = UIStoryboard(name: "Jinhee", bundle: nil)
        let bottomSheetVC = bottomSheetVCSB.instantiateViewController(withIdentifier: "MyPlaceTableViewController") as? MyPlaceTableViewController
        if let bottomSheetVC{
            bottomSheetVC.placeListIndex = indexPath.row
            self.addChild(bottomSheetVC)
            
            childView = bottomSheetVC.view
            stackView.addArrangedSubview(childView)
            bottomSheetVC.didMove(toParent: self)
        }
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        if button == nil{
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            button?.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            button?.setTitleColor(.accent, for: .normal)
            
            self.view.addSubview(button ?? UIButton())
            button?.addTarget(self, action: #selector(returnToList), for: .touchUpInside)

        }
    }
        
}

extension MyPlaceScrollableViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == secondPartialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
    
}

