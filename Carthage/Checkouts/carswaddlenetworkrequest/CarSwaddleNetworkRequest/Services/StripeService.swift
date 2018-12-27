//
//  StripeService.swift
//  CarSwaddleNetworkRequest
//
//  Created by Kyle Kendall on 12/22/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import UIKit

extension NetworkRequest.Request.Endpoint {
    fileprivate static let ephemeralKeys = Request.Endpoint(rawValue: "/api/ephemeral-keys")
}


final public class StripeService: Service {
    
    @discardableResult
    public func getKeys(apiVersion: String, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "apiVersion", value: apiVersion)]
        guard let urlRequest = serviceRequest.post(with: .ephemeralKeys, queryItems: queryItems, body: Data()) else { return nil }
        return sendWithAuthentication(urlRequest: urlRequest) { [weak self] data, error in
            self?.completeWithJSON(data: data, error: error, completion: completion)
        }
    }
    
}
