//
//  Transaction+CoreDataClass.swift
//  Store
//
//  Created by Kyle Kendall on 1/12/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//
//

import Foundation
import CoreData

typealias TransactionValues = (identifier: String, amount: Int, availableOn: Date, created: Date, currency: String, transactionDescription: String?, exchangeRate: NSNumber?, fee: Int, net: Int, source: String, status: String, type: String)

@objc(Transaction)
final public class Transaction: NSManagedObject, NSManagedObjectFetchable, JSONInitable {
    
    public convenience init?(json: JSONObject, context: NSManagedObjectContext) {
        guard let values = Transaction.values(from: json) else { return nil }
        self.init(context: context)
        configure(with: values, in: context)
    }
    
    public func configure(with json: JSONObject) throws {
        guard let values = Transaction.values(from: json) else { throw StoreError.invalidJSON }
        guard let context = managedObjectContext else { return }
        self.configure(with: values, in: context)
    }
    
    static private func values(from json: JSONObject) -> TransactionValues? {
        guard let identifier = json["id"] as? String,
            let amount = json["amount"] as? Int,
            let availableOnInt = json["available_on"] as? Int,
            let createdInt = json["created"] as? Int,
            let currency = json["currency"] as? String,
            let fee = json["fee"] as? Int,
            let net = json["net"] as? Int,
            let source = json["source"] as? String,
            let status = json["status"] as? String,
            let type = json["type"] as? String else { return nil }
        
        let avilableOnDate = Date(timeIntervalSince1970: TimeInterval(availableOnInt))
        let createdDate = Date(timeIntervalSince1970: TimeInterval(createdInt))
        
        let transactionDescription = json["transaction_description"] as? String
        
        var exchangeRateNumber: NSNumber?
        if let exchangeRateFloat = json["exchange_rate"] as? Float {
            exchangeRateNumber = NSNumber(value: exchangeRateFloat)
        }
        
        return (identifier, amount, avilableOnDate, createdDate, currency, transactionDescription, exchangeRateNumber, fee, net, source, status, type)
    }
    
    private func configure(with values: TransactionValues, in context: NSManagedObjectContext) {
        self.identifier = values.identifier
        self.amount = values.amount
        self.availableOn = values.availableOn
        self.created = values.created
        self.currency = values.currency
        self.fee = values.fee
        self.net = values.net
        self.source = values.source
        self.status = values.status
        self.type = values.type
        self.transactionDescription = values.transactionDescription
        self.exchangeRate = values.exchangeRate
    }
    
    
}
