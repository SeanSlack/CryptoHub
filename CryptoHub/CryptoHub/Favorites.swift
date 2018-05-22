//
//  File.swift
//  CryptoHub
//
//  Created by Sean on 19/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(Favorites)
public class Favorites: NSManagedObject {
    
}

extension Favorites {

    static var viewContext : NSManagedObjectContext?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }
    
    @NSManaged public var saveCoinID: String?
    
}

