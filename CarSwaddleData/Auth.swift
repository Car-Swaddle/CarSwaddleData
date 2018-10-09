//
//  Auth.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 10/9/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import Authentication
import CarSwaddleNetworkRequest

public class Auth {
    
    private let authService = AuthService()
    private let authentication = AuthController()
    
    public init() { }
    
    @discardableResult
    public func signUp(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) -> URLSessionDataTask? {
        return authService.signUp(email: email, password: password) { [weak self] token, error in
            self?.complete(token: token, error: error, completion: completion)
        }
    }
    
    @discardableResult
    public func login(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) -> URLSessionDataTask? {
        return authService.login(email: email, password: password) { [weak self] token, error in
            self?.complete(token: token, error: error, completion: completion)
        }
    }
    
    private func complete(token: String?, error: Error?, completion: (_ error: Error?) -> Void) {
        var error: Error?
        defer {
            completion(error)
        }
        guard let token = token else {
            // TODO: error
            return
        }
        authentication.setToken(token)
    }
    
    @discardableResult
    public func logout(completion: @escaping (_ error: Error?) -> Void) -> URLSessionDataTask? {
        authentication.removeToken()
        return authService.logout(completion: completion)
    }
    
}
