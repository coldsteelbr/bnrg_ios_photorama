//
//  Photo+CoreDataProperties.swift
//  bnrg_ios_photorama
//
//  Created by Roman Brazhnikov on 04.06.2018.
//  Copyright © 2018 Roman Brazhnikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var remoteURL: NSURL?

}
