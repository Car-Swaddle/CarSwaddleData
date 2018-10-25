//
//  CarSwaddleDataTests.swift
//  CarSwaddleDataTests
//
//  Created by Kyle Kendall on 10/9/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleData
import CoreData
//import Store

let store = Store(bundle: Bundle(identifier: "CS.Store")!, storeName: "CarSwaddleStore", containerName: "StoreContainer")

class CarSwaddleDataTests: XCTestCase {

//    override func setUp() {
//        let exp = expectation(description: "The ex")
//        store.privateContext { context in
//            Auth().login(email: "k@k.com", password: "password", context: context) { error in
//                print("in")
//                exp.fulfill()
//            }
//        }
//        waitForExpectations(timeout: 40, handler: nil)
//    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




private let modelFileExtension = "momd"

class Store {
    
    public let bundle: Bundle
    public let storeName: String
    public let containerName: String
    
    public init(bundle: Bundle, storeName: String, containerName: String) {
        self.bundle = bundle
        self.storeName = storeName
        self.containerName = containerName
    }
    
    // MARK: - Core Data stack
    
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let modelURL = bundle.url(forResource: storeName, withExtension: modelFileExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName, managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var mainContext: NSManagedObjectContext {
        assert(Thread.isMainThread, "Must be on main")
        return persistentContainer.viewContext
    }
    
    public func mainContext(_ closure: @escaping (NSManagedObjectContext) -> Void) {
        mainContext.perform {
            closure(self.mainContext)
        }
    }
    
    public func mainContextAndWait(_ closure: @escaping (NSManagedObjectContext) -> Void) {
        mainContext.performAndWait {
            closure(self.mainContext)
        }
    }
    
    public func privateContext(_ closure: @escaping (NSManagedObjectContext)->()) {
        persistentContainer.performBackgroundTask { context in
            closure(context)
        }
    }
    
    public func privateContextAndWait(_ closure: @escaping (NSManagedObjectContext)->()) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            closure(context)
        }
    }
    
}


public extension NSManagedObjectContext {
    
    public func persist() {
        guard  hasChanges else { return }
        do {
            try save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}


