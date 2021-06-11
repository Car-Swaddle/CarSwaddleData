//
//  User+Requests.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 11/10/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import UIKit
import CarSwaddleNetworkRequest
import CoreData
import CarSwaddleStore

public final class UserNetwork: Network {
    
    private var userService: UserService
    private var fileService: FileService
    
    override public init(serviceRequest: Request) {
        self.userService = UserService(serviceRequest: serviceRequest)
        self.fileService = FileService(serviceRequest: serviceRequest)
        super.init(serviceRequest: serviceRequest)
    }
    
    
    @discardableResult
    public func update(user: UpdateUser, in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return userService.updateCurrentUser(updateUser: user) { user, error in
            
        }
    }
    
    @discardableResult
    public func update(user: CarSwaddleStore.User, in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return update(firstName: user.firstName, lastName: user.lastName, phoneNumber: user.phoneNumber, token: nil, timeZone: user.timeZone, referrerID: nil, in: context, completion: completion)
    }
    
    @discardableResult
    public func update(firstName: String?, lastName: String?, phoneNumber: String?, token: String?, timeZone: String?, referrerID: String?, adminKey: String? = nil, in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return userService.updateCurrentUser(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, token: token, timeZone: timeZone, referrerID: referrerID, adminKey: adminKey) { json, error in
            context.performOnImportQueue {
                var userObjectID: NSManagedObjectID?
                defer {
                    completion(userObjectID, error)
                }
                
                guard let json = json else { return }
                let user = User.fetchOrCreate(json: json, context: context)
                context.persist()
                userObjectID = user?.objectID
            }
        }
    }
    
    @discardableResult
    public func requestCurrentUser(in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return userService.getCurrentUser { json, error in
            context.performOnImportQueue {
                var userObjectID: NSManagedObjectID?
                defer {
                    DispatchQueue.global().async {
                        completion(userObjectID, error)
                    }
                }
                
                guard let json = json else { return }
                let user = User.fetchOrCreate(json: json, context: context)
                context.persist()
                userObjectID = user?.objectID
            }
        }
    }
    
    @discardableResult
    public func setProfileImage(fileURL: URL, in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return fileService.uploadProfileImage(fileURL: fileURL) { json, error in
            context.performOnImportQueue {
                var userObjectID: NSManagedObjectID?
                defer {
                    DispatchQueue.global().async {
                        completion(userObjectID, error)
                    }
                }
                
                guard let currentUser = User.currentUser(context: context), error == nil else { return }
                currentUser.profileImageID = json?["profileImageID"] as? String
                context.persist()
                
                if let currentUserID = User.currentUserID {
                    _ = try? profileImageStore.storeFile(at: fileURL, userID: currentUserID, in: context)
                }
                
                userObjectID = currentUser.objectID
            }
        }
    }
    
    @discardableResult
    public func getProfileImage(userID: String, in context: NSManagedObjectContext, completion: @escaping (_ fileURL: URL?, _ error: Error?) -> Void) -> URLSessionDownloadTask? {
        return fileService.getProfileImage(userID: userID) { url, responseError in
            context.perform {
                var completionError: Error? = responseError
                var permanentURL: URL?
                defer {
                    completion(permanentURL, completionError)
                }
                guard let url = url else { return }
                do {
                    permanentURL = try profileImageStore.storeFile(at: url, userID: userID, in: context)
                } catch { completionError = error }
            }
        }
    }
    
    @discardableResult
    public func getImage(imageName: String, completion: @escaping (_ fileURL: URL?, _ error: Error?) -> Void) -> URLSessionDownloadTask? {
        return fileService.getImage(imageName: imageName) { url, responseError in
            var completionError: Error? = responseError
            var permanentURL: URL?
            defer {
                completion(permanentURL, completionError)
            }
            guard let url = url else { return }
            do {
                permanentURL = try profileImageStore.storeFile(at: url, fileName: imageName)
            } catch {
                completionError = error
            }
        }
    }
    
    @discardableResult
    public func verifySMS(withCode code: String, in context: NSManagedObjectContext, completion: @escaping (_ userObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return userService.verifySMS(withCode: code) { json, error in
            context.performOnImportQueue {
                var userObjectID: NSManagedObjectID?
                defer {
                    DispatchQueue.global().async {
                        completion(userObjectID, error)
                    }
                }
                
                guard let json = json else { return }
                let user = User.fetchOrCreate(json: json, context: context)
                context.persist()
                userObjectID = user?.objectID
            }
        }
    }
    
}

extension CarSwaddleStore.User {
    
    public convenience init?(user: CarSwaddleNetworkRequest.User, context: NSManagedObjectContext) {
//        guard let values = User.values(from: json) else { return nil }
        self.init(context: context)
//        configure(with: values, json: json)
        
        self.identifier = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.phoneNumber = user.phoneNumber
        self.profileImageID = user.profileImageID
        self.email = user.email
        if let isEmailVerified = user.isEmailVerified {
            self.isEmailVerified = isEmailVerified
        }
        if let isPhoneNumberVerified = user.isPhoneNumberVerified {
            self.isPhoneNumberVerified = isPhoneNumberVerified
        }
        self.timeZone = user.timeZone
        
//        if let firstName = json["firstName"] as? String {
//            self.firstName = firstName
//        }
//        if let lastName = json["lastName"] as? String {
//            self.lastName = lastName
//        }
//        if let phoneNumber = json["phoneNumber"] as? String {
//            self.phoneNumber = phoneNumber
//        }
//
//        if let imageID = json["profileImageID"] as? String {
//            self.profileImageID = imageID
//        }
//        if let email = json["email"] as? String {
//            self.email = email
//        }
//        if let verified = (json["isEmailVerified"] as? Bool) {
//            self.isEmailVerified = verified
//        }
//        if let verified = (json["isPhoneNumberVerified"] as? Bool) {
//            self.isPhoneNumberVerified = verified
//        }
//        if let timeZone = json["timeZone"] as? String {
//            self.timeZone = timeZone
//        }
//
//        guard let context = managedObjectContext else { return }
//
//        if let mechanicJSON = json["mechanic"] as? JSONObject,
//           let mechanic = Mechanic.fetchOrCreate(json: mechanicJSON, context: context) {
//            self.mechanic = mechanic
//        } else if let mechanicID = json["mechanicID"] as? String,
//                  let mechanic = Mechanic.fetch(with: mechanicID, in: context) {
//            self.mechanic = mechanic
//        }
        
    }
    
}
