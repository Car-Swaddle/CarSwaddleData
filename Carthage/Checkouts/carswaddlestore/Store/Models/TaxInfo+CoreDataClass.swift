//
//  TaxInfo+CoreDataClass.swift
//  Store
//
//  Created by Kyle Kendall on 2/10/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//
//

import Foundation
import CoreData


typealias TaxInfoValues = (year: String, metersDriven: Int, mechanicCostInCents: Int)

@objc(TaxInfo)
public class TaxInfo: NSManagedObject {
    
    public convenience init?(year: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.year = year
    }
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let values = TaxInfo.values(from: json) else { return nil }
        self.init(context: context)
        configure(with: values, json: json, in: context)
    }
    
    public func configure(with json: JSONObject) throws {
        guard let values = TaxInfo.values(from: json) else { throw StoreError.invalidJSON }
        guard let context = managedObjectContext else { return }
        self.configure(with: values, json: json, in: context)
    }
    
    private static func values(from json: JSONObject) -> TaxInfoValues? {
        guard let metersDriven = json["metersDriven"] as? Int,
            let mechanicCostInCents = json["mechanicCostInCents"] as? Int,
            let taxYear = json["taxYear"] as? String else { return nil }
        return (taxYear, metersDriven, mechanicCostInCents)
    }
    
    private func configure(with values: TaxInfoValues, json: JSONObject, in context: NSManagedObjectContext) {
        self.metersDriven = values.metersDriven
        self.mechanicCostInCents = values.mechanicCostInCents
        self.year = values.year
    }
    
    public static func fetchTaxInfo(withYear year: String, in context: NSManagedObjectContext) -> TaxInfo? {
        let fetchRequest: NSFetchRequest<TaxInfo> = TaxInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TaxInfo.year), year)
        fetchRequest.fetchLimit = 1
        
        return (try? context.fetch(fetchRequest))?.first
    }
    
}
