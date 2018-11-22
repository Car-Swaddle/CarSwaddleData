//
//  Location+CoreDataClass.swift
//  
//
//  Created by Kyle Kendall on 9/16/18.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
public final class Location: NSManagedObject, NSManagedObjectFetchable, JSONInitable {
    
    public static let tempID: String = "tempID"
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveIdentifier = Location.tempID
    }
    
    @NSManaged private var primitiveIdentifier: String
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let id = json.identifier else { return nil }
        let latitudeOptional = json["latitude"] as? Double
        let longitudeOptional = json["longitude"] as? Double
        
        let point = ((json["point"] as? JSONObject)?["coordinates"] as? [Double])
        
        let pointLongitude = point?.first
        let pointLatitude = (point?.count ?? 0) > 0 ? point?[1] : nil
        
        guard let longitude = longitudeOptional ?? pointLongitude,
            let latitude = latitudeOptional ?? pointLatitude else { return nil }
        
        self.init(context: context)
        self.identifier = id
        self.latitude = latitude
        self.longitude = longitude
        self.streetAddress = json["streetAddress"] as? String
    }
    
    public convenience init(context: NSManagedObjectContext, autoService: AutoService, coordinate: CLLocationCoordinate2D) {
        self.init(context: context)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.autoService = autoService
    }

}
