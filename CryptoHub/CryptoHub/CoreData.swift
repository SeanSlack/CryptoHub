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

//These are the manual settings for CoreData entities
@objc(Favorites)
public class Favorites: NSManagedObject {
    
}

extension Favorites {

    static var viewContext : NSManagedObjectContext?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }
    
    @NSManaged public var favCoinID: String?
    
}

@objc(Holdings)
public class Holdings: NSManagedObject {
    
}

extension Holdings {
    
    static var viewContext : NSManagedObjectContext?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Holdings> {
        return NSFetchRequest<Holdings>(entityName: "Holdings")
    }
    
    @NSManaged public var holdCoinID: String?
    @NSManaged public var holdAmount: String?
    
    
}
