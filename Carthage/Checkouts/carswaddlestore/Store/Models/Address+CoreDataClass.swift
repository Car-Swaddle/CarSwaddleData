//
//  Address+CoreDataClass.swift
//  Store
//
//  Created by Kyle Kendall on 12/25/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//
//

import Foundation
import CoreData


typealias AddressValues = (identifier: String, line1: String, postalCode: String, city: String, state: String)

@objc(Address)
final public class Address: NSManagedObject, NSManagedObjectFetchable, JSONInitable {
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let values = Address.values(from: json) else { return nil }
        self.init(context: context)
        configure(with: values)
    }
    
    public func configure(with json: JSONObject) throws {
        guard let values = Address.values(from: json) else { throw StoreError.invalidJSON }
        self.configure(with: values)
        
        guard let context = managedObjectContext else { return }
        
        if let mechanicID = json["mechanicID"] as? String {
            self.mechanic = Mechanic.fetch(with: mechanicID, in: context)
        }
    }
    
    static private func values(from json: JSONObject) -> AddressValues? {
        guard let identifier = json["id"] as? String,
            let line1 = json["line1"] as? String,
            let postalCode = json["postalCode"] as? String,
            let city = json["city"] as? String,
            let state = json["state"] as? String else { return nil }
        
        return (identifier, line1, postalCode, city, state)
    }
    
    private func configure(with values: AddressValues) {
        self.identifier = values.identifier
        self.line1 = values.line1
        self.postalCode = values.postalCode
        self.city = values.city
        self.state = values.state
    }
    
}
