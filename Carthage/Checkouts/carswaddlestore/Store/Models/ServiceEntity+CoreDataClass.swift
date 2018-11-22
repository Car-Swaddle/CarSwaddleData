//
//  ServiceEntity+CoreDataClass.swift
//  Store
//
//  Created by Kyle Kendall on 11/17/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ServiceEntity)
final public class ServiceEntity: NSManagedObject, NSManagedObjectFetchable, JSONInitable {
    
    public static let tempID = "tempID"
    
    public enum EntityType: String, CaseIterable {
        case oilChange = "OIL_CHANGE"
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveIdentifier = ServiceEntity.tempID
    }
    
    @NSManaged private var primitiveIdentifier: String
    
    /// Must set actual eneity relationship on your own. It is not set here and does not require it.
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let id = json.identifier,
            let entityTypeString = json["entityType"] as? String,
            let entityType = EntityType(rawValue: entityTypeString) else { return nil }
        
        self.init(context: context)
        self.identifier = id
        self.entityType = entityType
        
        if let autoServiceID = json["autoServiceID"] as? String,
            let autoService = AutoService.fetch(with: autoServiceID, in: context) {
            self.autoService = autoService
        }
        
        switch entityType {
        case .oilChange:
            if let oilChangeJSON = json["oilChange"] as? JSONObject,
                let oilChange = OilChange(json: oilChangeJSON, context: context) {
                self.oilChange = oilChange
            }
        }
    }
    
    
    public convenience init(autoService: AutoService, oilChange: OilChange, context: NSManagedObjectContext) {
        self.init(context: context)
        self.autoService = autoService
        self.oilChange = oilChange
        self.entityType = .oilChange
    }
    
    private let entityTypeKey = "entityType"
    @NSManaged private var primitiveEntityType: String
    
    public var entityType: EntityType {
        set {
            willChangeValue(forKey: entityTypeKey)
            primitiveEntityType = newValue.rawValue
            didChangeValue(forKey: entityTypeKey)
        }
        get {
            willAccessValue(forKey: entityTypeKey)
            let enumValue = EntityType(rawValue: primitiveEntityType) ?? .oilChange
            didAccessValue(forKey: entityTypeKey)
            return enumValue
        }
    }
    
}
