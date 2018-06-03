//
//  PhotoDataSource.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 03.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource{
    
    var photos = [Photo]()
    
    //
    // UICollectionViewDataSource protocol's required methods
    //
    
    // tells how many cell should be shown in the screen
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    // asks for the Cell to display for a give index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifire = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath)
        
        return cell
    }
    
    
}
