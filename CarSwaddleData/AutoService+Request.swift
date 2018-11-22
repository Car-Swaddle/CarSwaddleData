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
