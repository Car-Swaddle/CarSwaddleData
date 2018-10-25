//
//  TemplateTimeSpan+Requests.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 10/23/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import Store
import CarSwaddleNetworkRequest
import CoreData


public class TemplateTimeSpanNetwork {
    
    let availabilityService = AvailabilityService()
    
    public init() {}
    
    @discardableResult
    public func getTimeSpans(in context: NSManagedObjectContext, completion: @escaping (_ timeSpans: [NSManagedObjectID], _ error: Error?) -> Void) -> URLSessionDataTask? {
        return availabilityService.getAvailability { jsonArray, error in
            context.perform {
                var timeSpans: [NSManagedObjectID] = []
                defer {
                    completion(timeSpans, error)
                }
                
                for json in jsonArray ?? [] {
                    guard let span = TemplateTimeSpan(json: json, context: context) else { continue }
                    timeSpans.append(span.objectID)
                }
                context.persist()
            }
        }
    }
    
}


public extension TemplateTimeSpan {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss zzz"
        return formatter
    }()
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let identifier = json["id"] as? String,
            let duration = json["duration"] as? Double,
            let weekdayInt = json["weekDay"] as? Int16,
            let mechanicID = json["mechanicID"] as? String,
            let mechanic = Mechanic.fetch(with: mechanicID, in: context),
            let weekday = Weekday(rawValue: weekdayInt) else { return nil }
        
        
        print("startTime: \(json["startTime"] as? String)")
        
        if let str = json["startTime"] as? String {
            let date = TemplateTimeSpan.dateFormatter.date(from: str)
            print(date)
        }
        
        self.init(context: context)
        self.identifier = identifier
        self.duration = duration
        self.startTime = 0
        self.weekday = weekday
        self.mechanic = mechanic
    }
    
}
