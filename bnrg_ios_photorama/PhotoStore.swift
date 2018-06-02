//
//  PhotoStore.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 02.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//

import Foundation

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Sends URL request to fetch photos using JSON data
    func fetchInterestingPhotos(){
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) ->Void in
            
            // getting JSON data
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    print(jsonObject)
                } catch let error{
                    print("Error createing JSON object: \(error)")
                }
                
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        } // let task
        task.resume()
        
    } // func
} // class
