//
//  VC+Extention.swift
//  VirtualTouristProject1
//
//  Created by AMJAD - on 06/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//


import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func save() {
        do {
            try CoreDataStack.shared().saveContext()
        } catch {
            
            print("Error : \(error) ")
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
