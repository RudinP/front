//
//  DetailPlaceViewController.swift
//  Foodle
//
//  Created by 루딘 on 4/4/24.
//

import UIKit

class DetailPlaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension DetailPlaceViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCell", for: indexPath) as? PlaceImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.placeImageView.image = UIImage(named: "dummy")
        
        return cell
    }
    
    
}
