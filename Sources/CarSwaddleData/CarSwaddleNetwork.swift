//
//  Network.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 11/8/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import CoreData
import CarSwaddleStore
import CarSwaddleNetworkRequest

open class Network {
    
//    public var serviceRequest: Request
    
    public init(serviceRequest: Request) {
//        fatalError("subclass must override")
//        self.serviceRequest = serviceRequest
//        NotificationCenter.default.addObserver(self, selector: #selector(Network.updateServiceRequest(_:)), name: .serviceRequestDidChange, object: nil)
    }
    
//    @objc private func updateServiceRequest(_ notification: Notification) {
//        guard let newServiceRequest = notification.userInfo?[Service.newServiceRequestKey] as? Request else {
//            return
//        }
//        self.serviceRequest = newServiceRequest
//    }
    
}

public let repoFactory = RepositoryFactory()

public class RepositoryFactory {
    
    public init() { }
    
    private struct RepoServiceRequest: Hashable {
        static func == (lhs: RepositoryFactory.RepoServiceRequest, rhs: RepositoryFactory.RepoServiceRequest) -> Bool {
            return lhs.request == rhs.request && lhs.repoType == rhs.repoType
        }
        
        var request: Request
        var repoType: Repository.Type
        func hash(into hasher: inout Hasher) {
            hasher.combine(request)
            hasher.combine(String(describing: repoType))
        }
    }
    
    private var cache: [RepoServiceRequest: Repository] = [:]
    
    public func repository<Repo: Repository>(serviceRequest: Request) -> Repo {
        if let cachedRepo = cache[RepoServiceRequest(request: serviceRequest, repoType: Repo.self)] as? Repo {
            return cachedRepo
        } else {
            let newRepo = Repo(serviceRequest: serviceRequest)
            cache[RepoServiceRequest(request: serviceRequest, repoType: Repo.self)] = newRepo
            return newRepo
        }
    }
    
    public func clear() {
        cache.removeAll()
    }
    
}


open class Repository: Hashable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        return String(describing: type(of: lhs)) == String(describing: type(of: rhs)) && lhs.serviceRequest == rhs.serviceRequest
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
    
    public required init(serviceRequest: Request) {
        self.serviceRequest = serviceRequest
    }
    
    public let serviceRequest: Request
}


public class MechanicRepository: Repository {
}

public class PoopRepository: Repository {
}

