//
//  AutoServiceTests.swift
//  CarSwaddleDataTests
//
//  Created by Kyle Kendall on 11/20/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleData
import CoreData
import Store

class AutoServiceTests: LoginTestCase {
    
    private let autoServiceNetwork = AutoServiceNetwork(serviceRequest: serviceRequest)
    
    func testCreateAutoService() {
        
        let exp = expectation(description: "\(#function)\(#line)")
        let context = store.mainContext
        let autoService = createAutoService(in: context)

        autoServiceNetwork.createAutoService(autoService: autoService, in: context) { newAutoService, error in
            XCTAssert(newAutoService != nil, "Should have auto service")
            XCTAssert(error == nil, "Should not have error")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let exp = expectation(description: "\(#function)\(#line)")
            let context = store.mainContext
            let autoService = createAutoService(in: context)
            autoServiceNetwork.createAutoService(autoService: autoService, in: context) { newAutoService, error in
                XCTAssert(newAutoService != nil, "Should have auto service")
                XCTAssert(error == nil, "Should not have error")
                exp.fulfill()
            }
            
            
            waitForExpectations(timeout: 40, handler: nil)
        }
    }

}


private func createAutoService(in context: NSManagedObjectContext) -> AutoService {
    let autoService = AutoService(context: context)
    
    let location = Location(context: context)
    location.identifier = "9849c390-eb67-11e8-8d83-876032d55422"
    location.latitude = 40.89
    location.longitude = 23.3525
    
    autoService.location = location
    
    let user = User(context: context)
    user.identifier = "SomeID"
    user.firstName = "Roopert"
    
    autoService.creator = user
    
    let mechanic = Mechanic(context: context)
    mechanic.identifier = "Some id"
    
    autoService.mechanic = mechanic
    
    let oilChange = OilChange(context: context)
    oilChange.identifier = "oil cha"
    oilChange.oilType = .blend
    
    _ = ServiceEntity(autoService: autoService, oilChange: oilChange, context: context)
    
    let vehicle = Vehicle(context: context)
    vehicle.creationDate = Date()
    vehicle.identifier = "bbb8c060-eaa9-11e8-a56c-2953c4831dcb"
    vehicle.licensePlate = "123 HYG"
    vehicle.name = "That name"
    
    autoService.vehicle = vehicle
    autoService.status = .inProgress
    autoService.scheduledDate = Date()
    
    return autoService
}
