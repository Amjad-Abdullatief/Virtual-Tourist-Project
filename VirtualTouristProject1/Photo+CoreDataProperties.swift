//
//  Photo+CoreDataProperties.swift
//  VirtualTouristProject1
//
//  Created by AMJAD - on 06/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
