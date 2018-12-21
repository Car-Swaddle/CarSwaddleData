//
//  PriceTests.swift
//  CarSwaddleNetworkRequestTests
//
//  Created by Kyle Kendall on 12/20/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleNetworkRequest
import Authentication
import MapKit


class PriceTests: CarSwaddleLoginTestCase {
    
    private let priceService = PriceService(serviceRequest: serviceRequest)
    
    func testGetPrice() {
        let exp = expectation(description: "\(#function)\(#line)")
        let location = CLLocationCoordinate2D(latitude: -111.8657987654, longitude: 40.36)
        priceService.getPrice(mechanicID: currentMechanicID, oilType: "conventional", location: location) { json, error in
            XCTAssert(json != nil, "Should have at least one json object")
            XCTAssert(error == nil, "Should have not have error")
            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
}
