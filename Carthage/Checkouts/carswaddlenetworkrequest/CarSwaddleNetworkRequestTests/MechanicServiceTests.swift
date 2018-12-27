//
//  MechanicServiceTests.swift
//  CarSwaddleNetworkRequestTests
//
//  Created by Kyle Kendall on 11/7/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleNetworkRequest

class MechanicServiceTests: CarSwaddleLoginTestCase {
    
    private let service = MechanicService(serviceRequest: serviceRequest)
    
    private let closeLatitude: Double = 40.38754862123388
    private let closeLongitude: Double = -111.82703949226095
    
    private let atlanticLatitude: Double = 28.237381
    private let atlanticLongitude: Double = -47.420196
    
    private var dob: Date {
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: nil, year: 1990, month: 11, day: 20, hour: 0)
        return dateComponents.date ?? Date()
    }
    
    func testNearestMechanics() {
        let exp = expectation(description: "\(#function)\(#line)")
        service.getNearestMechanics(limit: 10, latitude: closeLatitude, longitude: closeLongitude, maxDistance: 1000) { jsonArray, error in
            
            if let jsonArray = jsonArray {
                XCTAssert(jsonArray.count > 0, "Should have gotten at least one mechanic")
            } else {
                XCTAssert(false, "Should have gotten jsonArray")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testNearestMechanicsAtlantic() {
        let exp = expectation(description: "\(#function)\(#line)")
        service.getNearestMechanics(limit: 10, latitude: atlanticLatitude, longitude: atlanticLongitude, maxDistance: 1000) { jsonArray, error in
            
            if let jsonArray = jsonArray {
                XCTAssert(jsonArray.count == 0, "Should have gotten at least one mechanic")
            } else {
                XCTAssert(false, "Should have gotten jsonArray")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testUpdateMechanic() {
        let exp = expectation(description: "\(#function)\(#line)")
        let token = "The token"
        let isActive = true
        service.updateCurrentMechanic(isActive: isActive, token: token, dateOfBirth: nil, addressJSON: nil) { json, error in
            if let json = json {
                XCTAssert(json["isActive"] as? Bool == isActive, "Should have gotten at least one mechanic")
            } else {
                XCTAssert(false, "Should have gotten jsonArray")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testUpdateMechanicDOBAndAddress() {
        let exp = expectation(description: "\(#function)\(#line)")
        let address = MechanicService.addressJSON(line1: "1541 N 1300 W St", postalCode: "84062", city: "American Fork", state: "Ut")
        service.updateCurrentMechanic(isActive: nil, token: nil, dateOfBirth: dob, addressJSON: address) { json, error in
            if let json = json {
                if let dateString = json["dateOfBirth"] as? String,
                    let date = serverDateFormatter.date(from: dateString) {
                    XCTAssert(date == self.dob, "Should have correctJSON")
                }
                if let addressJSON = json["address"] as? JSONObject {
                    XCTAssert((addressJSON["line1"] as? String) == address["line1"] as? String, "Should have correctJSON")
                    XCTAssert((addressJSON["postalCode"] as? String) == address["postalCode"] as? String, "Should have correctJSON")
                    XCTAssert((addressJSON["city"] as? String) == address["city"] as? String, "Should have correctJSON")
                    XCTAssert((addressJSON["state"] as? String) == address["state"] as? String, "Should have correctJSON")
                }
            } else {
                XCTAssert(false, "Should have gotten jsonArray")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testGetMechanic() {
        let exp = expectation(description: "\(#function)\(#line)")
        service.getCurrentMechanic { json, error in
            if let json = json {
                XCTAssert(json["isActive"] as? Bool != nil, "Should have gotten at least one mechanic")
                XCTAssert(json["id"] as? String != nil, "Should have gotten at least one mechanic")
            } else {
                XCTAssert(false, "Should have gotten jsonArray")
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testPerformanceNearestMechanics() {
        measure {
            let exp = expectation(description: "\(#function)\(#line)")
            service.getNearestMechanics(limit: 10, latitude: closeLatitude, longitude: closeLongitude, maxDistance: 1000) { jsonArray, error in
                exp.fulfill()
            }
            waitForExpectations(timeout: 40, handler: nil)
        }
    }
    
}
