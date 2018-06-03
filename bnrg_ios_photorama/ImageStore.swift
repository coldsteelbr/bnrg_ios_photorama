//
//  ImageStore.swift
//  bnrg_ios_homepwner
//
//  Created by Roman Brazhnikov on 29.05.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import UIKit

class ImageStore{
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String){
        cache.setObject(image, forKey: key as NSString)
        
        // creating file URL
        let url = imageURL(forKey: key)
        
        // saving as JPEG
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        //return cache.object(forKey: key as NSString)
        
        // from cache
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // from filesystem
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String){
        // from cache
        cache.removeObject(forKey: key as NSString)
        
        // from filesystem
        let url = imageURL(forKey: key)
        do {
           try FileManager.default.removeItem(at: url)
        }catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
        
    }
    
    //
    // For saving to the filesystem
    //
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
}
