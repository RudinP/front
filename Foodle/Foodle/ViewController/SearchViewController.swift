//
//  SearchViewController.swift
//  Foodle
//
//  Created by 루딘 on 4/4/24.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var bottomSheetVC: UIViewController?
    var newMeeting: Meeting?
    
    func addSearchBar(){
        let search = UISearchController()
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        search.searchBar.placeholder = ""
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
        search.searchBar.text = keyword
        search.searchBar.searchTextField.autocorrectionType = .no
        search.searchBar.searchTextField.spellCheckingType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways{
            manager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bottomSheetVC?.dismiss(animated: false)
        super.viewWillDisappear(animated)
        manager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        addSearchBar()
        
        NotificationCenter.default.addObserver(forName: .meetingPlaceAdded, object: nil, queue: .main) { _ in
            guard let vc = addMeetingPlaceVC else {return}
            self.bottomSheetVC?.dismiss(animated: true, completion: {
                self.navigationController?.popToViewController(vc, animated: true)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setResultView()
    }
    
    
    private func setResultView(){
        let bottomSheetVCSB = UIStoryboard(name: "Jinhee", bundle: nil)
        bottomSheetVC = bottomSheetVCSB.instantiateViewController(withIdentifier: "ScrollableBottomSheetViewController")
        
        if let sheet = bottomSheetVC?.sheetPresentationController {
            let fraction = UISheetPresentationController.Detent.custom { context in
                if self.newMeeting != nil {
                    return 200
                } else {
                    return 140
                }
            }
            sheet.detents = [.medium(), .large(), fraction]
            sheet.largestUndimmedDetentIdentifier = fraction.identifier  // nil 기본값
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
            sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
            sheet.prefersGrabberVisible = true
        }
        
        if let vc = bottomSheetVC as? ScrollableBottomSheetViewController{
            vc.newMeeting = newMeeting
        }
        
        if let bottomSheetVC{
            bottomSheetVC.isModalInPresentation = true
            present(bottomSheetVC, animated: true)
        }
    }
    
}

extension SearchViewController: MKMapViewDelegate{
    
}

extension SearchViewController: CLLocationManagerDelegate{
    
    func move(to location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            let alert = UIAlertController(title: "알림", message: "위치 서비스를 활성화시켜 주세요.", preferredStyle: .alert)
            
            let settingAction = UIAlertAction(title: "설정", style: .cancel){ _ in
                //string에 저장된 문자열로 url을 만든 다음에 open으로 전달하면 설정 앱으로 바로 이동 가능
                if let url = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(settingAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //에러를 확인하려면 NSError타입으로 캐스팅해야함.
        let error = error as NSError
        guard error.code != CLError.Code.locationUnknown.rawValue else {return}
        
        print(error)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            move(to: currentLocation)
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
}

