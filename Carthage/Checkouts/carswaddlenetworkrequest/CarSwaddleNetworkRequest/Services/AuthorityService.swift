//
//  AuthorityService.swift
//  CarSwaddleNetworkRequest
//
//  Created by Kyle Kendall on 6/13/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//


import Foundation

extension NetworkRequest.Request.Endpoint {
    /*
     /api/authorities/request?authority=readAuthorities
     /api/authorities/reject
     /api/authorities/approve
     /api/authorities
     /api/authorityRequests?pending=false
     */
    fileprivate static let requestAuthority = Request.Endpoint(rawValue: "/api/authorities/request")
    fileprivate static let rejectAuthority = Request.Endpoint(rawValue: "/api/authorities/reject")
    fileprivate static let approveAuthority = Request.Endpoint(rawValue: "/api/authorities/approve")
    fileprivate static let authorities = Request.Endpoint(rawValue: "/api/authorities")
    fileprivate static let authorityRequests = Request.Endpoint(rawValue: "/api/authorityRequests")
}

final public class AuthorityService: Service {
    
    @discardableResult
    public func getAuthorities(completion: @escaping JSONArrayCompletion) -> URLSessionDataTask? {
        guard let urlRequest = serviceRequest.get(with: .authorities) else { return nil }
        return sendWithAuthentication(urlRequest: urlRequest) { data, error in
            guard let data = data,
                let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [JSONObject] else {
                    completion(nil, error)
                    return
            }
            completion(jsonArray, error)
        }
    }
    
    @discardableResult
    public func getAuthorityRequests(completion: @escaping JSONArrayCompletion) -> URLSessionDataTask? {
        guard let urlRequest = serviceRequest.get(with: .authorityRequests) else { return nil }
        return sendWithAuthentication(urlRequest: urlRequest) { data, error in
            guard let data = data,
                let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [JSONObject] else {
                    completion(nil, error)
                    return
            }
            completion(jsonArray, error)
        }
    }
    
    @discardableResult
    public func requestAuthority(authority: String, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        var json = JSONObject()
        json["authority"] = authority
        guard let body = (try? JSONSerialization.data(withJSONObject: json, options: [])),
            let urlRequest = serviceRequest.post(with: .requestAuthority, body: body, contentType: .applicationJSON) else {
                completion(nil, NetworkRequestError.unableToCreateURLRequest)
                return nil
        }
        return sendWithAuthentication(urlRequest: urlRequest) { [weak self] data, error in
            self?.completeWithJSON(data: data, error: error, completion: completion)
        }
    }
    
    @discardableResult
    public func rejectAuthorityRequest(secretID: String, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        var json = JSONObject()
        json["secretID"] = secretID
        guard let body = (try? JSONSerialization.data(withJSONObject: json, options: [])),
            let urlRequest = serviceRequest.post(with: .rejectAuthority, body: body, contentType: .applicationJSON) else {
                completion(nil, NetworkRequestError.unableToCreateURLRequest)
                return nil
        }
        return sendWithAuthentication(urlRequest: urlRequest) { [weak self] data, error in
            self?.completeWithJSON(data: data, error: error, completion: completion)
        }
    }
    
    @discardableResult
    public func approveAuthorityRequest(secretID: String, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        var json = JSONObject()
        json["secretID"] = secretID
        guard let body = (try? JSONSerialization.data(withJSONObject: json, options: [])),
            let urlRequest = serviceRequest.post(with: .approveAuthority, body: body, contentType: .applicationJSON) else {
                completion(nil, NetworkRequestError.unableToCreateURLRequest)
                return nil
        }
        return sendWithAuthentication(urlRequest: urlRequest) { [weak self] data, error in
            self?.completeWithJSON(data: data, error: error, completion: completion)
        }
    }
    
}

