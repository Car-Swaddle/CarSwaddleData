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
    
    public let serviceRequest: Request
    
    public init(serviceRequest: Request) {
        self.serviceRequest = serviceRequest
    }
    
    private lazy var availabilityService = AvailabilityService(serviceRequest: serviceRequest)
    
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
    
    @discardableResult
    public func postTimeSpans(templateTimeSpans: [TemplateTimeSpan], in context: NSManagedObjectContext, completion: @escaping (_ timeSpans: [NSManagedObjectID], _ error: Error?) -> Void) -> URLSessionDataTask? {
        
        var jsonArray: [JSONObject] = []
        for timeSpan in templateTimeSpans {
            jsonArray.append(timeSpan.toJSON)
        }
        
        return availabilityService.postAvailability(jsonArray: jsonArray) { jsonArray, error in
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
    
    var toJSON: JSONObject {
        return ["startTime": startTime, "duration": duration, "weekDay": weekday.rawValue]
    }
    
    var startTimeStringFormat: String {
        return startTime.timeOfDayFormattedString
    }
    
}

extension Int64 {
    
    var numberOfDigits: Int {
        var numberOfDigits: Int = 0
        var dividedValue = self
        while dividedValue > 0 {
            dividedValue = dividedValue / 10
            numberOfDigits += 1
        }
        return numberOfDigits
    }
    
    var timeOfDayFormattedString: String {
        let hours = self / (60*60)
        let minutes = (self / 60) % 60
        let seconds = self % 60
        
        var hoursString: String = String(hours)
        if hours.numberOfDigits < 2 {
            hoursString = "0" + hoursString
        }
        var minutesString: String = String(minutes)
        if minutes.numberOfDigits < 2 {
            minutesString = "0" + minutesString
        }
        var secondsString: String = String(seconds)
        if seconds.numberOfDigits < 2 {
            secondsString = "0" + secondsString
        }
        
        return hoursString + ":" + minutesString + ":" + secondsString
    }
    
}


//public extension TemplateTimeSpan {
//
//    private static let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        return formatter
//    }()
//
//    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
//        guard let identifier = json["id"] as? String,
//            let duration = json["duration"] as? Double,
//            let weekdayInt = json["weekDay"] as? Int16,
//            let mechanicID = json["mechanicID"] as? String,
//            let mechanic = Mechanic.fetch(with: mechanicID, in: context),
//            let weekday = Weekday(rawValue: weekdayInt),
//            let dateString = json["startTime"] as? String,
//            let date = TemplateTimeSpan.dateFormatter.date(from: dateString) else { return nil }
//
//        self.init(context: context)
//        self.identifier = identifier
//        self.duration = duration
//        self.startTime = Int64(date.secondsSinceMidnight())
//        self.weekday = weekday
//        self.mechanic = mechanic
//    }
//
//}
