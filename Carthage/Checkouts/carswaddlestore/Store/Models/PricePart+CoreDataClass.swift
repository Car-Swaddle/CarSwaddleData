//
//  PricePart+CoreDataClass.swift
//  
//
//  Created by Kyle Kendall on 9/16/18.
//
//

import Foundation
import CoreData

@objc(PricePart)
public final class PricePart: NSManagedObject {
    
    public convenience init(key: String, value: NSDecimalNumber, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.key = key
        self.value = value
    }
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let key = json["key"] as? String,
            let value = json["value"] as? String else { return nil }
        self.init(key: key, value: NSDecimalNumber(string: value), in: context)
    }
    
}
