//
//  Service.swift
//  CarSwaddleNetworkRequest
//
//  Created by Kyle Kendall on 10/20/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import UIKit
import NetworkRequest

extension Notification.Name {
    public static let serviceRequestDidChange: Notification.Name = Notification.Name(rawValue: "serviceRequestDidChange")
}

public class Service {
    
    public static let newServiceRequestKey: String = "newServiceRequestObject"
    
    public private(set) var serviceRequest: Request
    
    public init(serviceRequest: Request) {
        self.serviceRequest = serviceRequest
        NotificationCenter.default.addObserver(self, selector: #selector(Service.updateServiceRequest(_:)), name: .serviceRequestDidChange, object: nil)
    }
    
    @objc private func updateServiceRequest(_ notification: Notification) {
        guard let newServiceRequest = notification.userInfo?[Service.newServiceRequestKey] as? Request else { return }
        self.serviceRequest = newServiceRequest
    }
    
    func sendWithAuthentication(urlRequest: NSMutableURLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        do {
            try urlRequest.authenticate()
        } catch { print("couldn't authenticate") }
        return serviceRequest.send(urlRequest: urlRequest as URLRequest, completion: completion)
    }
    
    func sendWithAuthentication(urlRequest: URLRequest, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        var urlRequest = urlRequest
        do {
            try urlRequest.authenticate()
        } catch { print("couldn't authenticate") }
        return serviceRequest.send(urlRequest: urlRequest, completion: completion)
    }
    
    func completeWithJSONArray(data: Data?, error: Error?, completion: @escaping (_ jsonArray: [JSONObject]?, _ error: Error?) -> Void) {
        guard let data = data,
            let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [JSONObject] else {
                completion(nil, error)
                return
        }
        completion(jsonArray, error)
    }
    
    func completeWithJSON(data: Data?, error: Error?, completion: @escaping (_ json: JSONObject?, _ error: Error?) -> Void) {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONObject else {
                completion(nil, error)
                return
        }
        completion(json, error)
    }
    
}
