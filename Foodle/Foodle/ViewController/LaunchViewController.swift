//
//  LaunchViewController.swift
//  Foodle
//
//  Created by 루딘 on 7/14/24.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData {
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "didFinishLoading", sender: nil)
            }
        }
    }
    
    final func prepareData(completion: @escaping () -> Void){
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchUser("1") { result in
            user = result
            
            guard let uid = user?.uid else {
                dispatchGroup.leave()
                return
            }
            
            dispatchGroup.enter()
            fetchFriends(uid) { result in
                friends = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            fetchMeeting(uid) { result in
                meetings = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            fetchPlaceLists(uid) { result in
                placeLists = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.leave()
            
            
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
}
