//
//  AutoService+Request.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 11/20/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import Store
import CarSwaddleNetworkRequest
import CoreData

public final class AutoServiceNetwork: Network {
    
    private lazy var autoServiceService = AutoServiceService(serviceRequest: serviceRequest)
    
    @discardableResult
    public func createAutoService(autoService: AutoService, in context: NSManagedObjectContext, completion: @escaping (_ autoService: AutoService?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let json = try? autoService.toJSON() else { return nil }
        return autoServiceService.createAutoService(autoServiceJSON: json) { autoServiceJSON, error in
            context.perform {
                var newAutoService: AutoService?
                defer {
                    DispatchQueue.global().async {
                        completion(newAutoService, error)
                    }
                }
                
                guard let autoServiceJSON = autoServiceJSON else { return }
                context.delete(autoService)
                
                guard let convertedAutoService = AutoService.fetchOrCreate(json: autoServiceJSON, context: context) else { return }
                newAutoService = convertedAutoService
                context.persist()
            }
        }
    }
    
}

struct StoreError: Error {
    let rawValue: String
    
    static let invalidJSON = StoreError(rawValue: "invalidJSON")
    
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter
}()

extension AutoService {
    
    func toJSON() throws -> JSONObject {
        var json: JSONObject = [:]
                
        if let locationID = location?.identifier {
            json["locationID"] = locationID
        } else if let location = location {
            json["location"] = location.toJSON
        } else {
            throw StoreError.invalidJSON
        }
        
        if let mechanic = mechanic {
            json["mechanicID"] = mechanic.identifier
        } else {
            throw StoreError.invalidJSON
        }
        
        if let scheduledDate = scheduledDate {
            json["scheduledDate"] = dateFormatter.string(from: scheduledDate)
        } else {
            throw StoreError.invalidJSON
        }
        
        let jsonArray = serviceEntities.toJSONArray
        if jsonArray.count > 0 {
            json["serviceEntities"] = serviceEntities.toJSONArray
        } else {
            throw StoreError.invalidJSON
        }
        
        if let vehicleID = vehicle?.identifier {
            json["vehicleID"] = vehicleID
        } else {
            throw StoreError.invalidJSON
        }
        
        json["status"] = status.rawValue
        json["notes"] = notes
        
        return json
    }
    
    var firstOilChange: OilChange? {
        return serviceEntities.first(where: { entity -> Bool in
            return entity.entityType == .oilChange
        })?.oilChange
    }
    
}

extension Sequence where Iterator.Element == ServiceEntity {
    
    var toJSONArray: [JSONObject] {
        var jsonArray: [JSONObject] = []
        for entity in self {
            jsonArray.append(entity.toJSON)
        }
        return jsonArray
    }
    
}

extension ServiceEntity {
    
    var toJSON: JSONObject {
        var entityJSON: JSONObject = [:]
        entityJSON["entityType"] = entityType.rawValue
        switch entityType {
        case .oilChange:
            if let oilChange = oilChange {
                entityJSON["specificService"] = oilChange.toJSON()
            }
        }
        return entityJSON
    }
    
}

extension OilChange {
    
    func toJSON(includeID: Bool = false) -> JSONObject {
        var json: JSONObject = [:]
        json["oilType"] = oilType.rawValue
        if includeID {
            json["identifier"] = identifier
        }
        return json
    }
    
}


extension Location {
    
    var toJSON: JSONObject {
        var json: JSONObject = [:]
        
        json["latitude"] = latitude
        json["longitude"] = longitude
        //        json["identifier"] = identifier
        json["streetAddress"] = streetAddress
        
        return json
    }
    
}
