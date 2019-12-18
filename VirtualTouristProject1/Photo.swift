//
//  Photo.swift
//  VirtualTouristProject1
//
//  Created by AMJAD - on 06/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    static let name = "Photo"
    
    convenience init( url: String, forPin: Pin, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Photo.name, in: context) {
            self.init(entity: ent, insertInto: context)
            
            self.photo = nil
            self.url = url
            self.pin = forPin
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}
