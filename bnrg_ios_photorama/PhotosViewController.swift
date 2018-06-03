//
//  PhotosViewController.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 02.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos{
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                // setting the photos
                print("Successfully found \(photos.count) photos.")
                self.photoDataSource.photos = photos
            case let .failure(error):
                // removing all in case of error
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            // refreshing the view
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
    }// func
    
}// class
