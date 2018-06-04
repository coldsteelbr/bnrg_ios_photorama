//
//  PhotoStore.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 02.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error{
    case imageCreationError
}

enum PhotoResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let contrainer = NSPersistentContainer(name: "Photorama")
        contrainer.loadPersistentStores{ (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return contrainer
    }()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Fetches all photos from the CoreData
    func fetchAllPhotos(completion: @escaping (PhotoResult) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDataTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        
        fetchRequest.sortDescriptors = [sortByDataTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Sends URL request to fetch photos using JSON data
    func fetchInterestingPhotos(completion: @escaping (PhotoResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) ->Void in
            
            // getting JSON data
            var result = self.processPhotoRequest(data: data, error: error)
            
            // saving changes to the CoreData
            if case .success = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch let error {
                    result = .failure(error)
                }
            }
            
            // Running in the UI Thread
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        } // let task
        task.resume()
        
    } // func
    
    private func processPhotoRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        // saving image to the ImageStore
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        
        // fetching
        guard let photoURL = photo.remoteURL else {
            preconditionFailure("Photo expected to have a remote URL.")
        }
        let request = URLRequest(url: photoURL as URL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }

        }
        task.resume()
    } // func
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                // couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        } // guard else
        return .success(image)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
} // class
