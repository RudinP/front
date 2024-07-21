//
//  MyPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 5/16/24.
//

import UIKit
import MapKit
class MyPlaceViewController: UIViewController {
    
    let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    

    let manager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways{
            manager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        manager.stopUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        setMap()
        setSheetView()
    }
    
    private func setMapConstraints(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setMap(){
        setMapConstraints()
    }
    
    private func setSheetView(){
        
        let bottomSheetVCSB = UIStoryboard(name: "Jinhee", bundle: nil)
        let bottomSheetVC = bottomSheetVCSB.instantiateViewController(withIdentifier: "MyPlaceScrollableViewController")
        let nav = UINavigationController(rootViewController: bottomSheetVC)
        let tab = UITabBarController()
        tab.delegate = self
        tab.viewControllers = self.navigationController?.tabBarController?.viewControllers
        tab.viewControllers?[2] = nav
        nav.tabBarItem.title = "플레이스"
        nav.tabBarItem.image = UIImage(systemName: "star")
        tab.selectedIndex = 2
        if let sheet = tab.sheetPresentationController {
            let fraction = UISheetPresentationController.Detent.custom { context in
                140
            }
            sheet.detents = [.medium(), .large(), fraction]
            sheet.largestUndimmedDetentIdentifier = .medium  // nil 기본값
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false  // true 기본값
            sheet.prefersEdgeAttachedInCompactHeight = true // false 기본값
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
            sheet.prefersGrabberVisible = true
        }
        
        tab.isModalInPresentation = true

        present(tab, animated: true, completion: nil)
        
    }
    
}

extension MyPlaceViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex != 2 {
            dismiss(animated: true)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Jinhee", bundle: nil)
                if let tab = storyboard.instantiateViewController(identifier: "InitialTabBar") as? UITabBarController{
                    sceneDelegate.window?.rootViewController = tab
                    tab.selectedIndex = tabBarController.selectedIndex
                }
            }
        }
        
    }
}
extension MyPlaceViewController: MKMapViewDelegate{
    
}

extension MyPlaceViewController: CLLocationManagerDelegate{
    
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

