//
//  PhotoCollectionViewCell.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 03.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    /// Turns on an off the downloading process spinner on a cell
    func update(with image: UIImage?){
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
}
