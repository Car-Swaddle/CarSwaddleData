//
//  StripeServiceTests.swift
//  CarSwaddleNetworkRequestTests
//
//  Created by Kyle Kendall on 12/22/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleNetworkRequest
import Authentication
import MapKit


class StripeServiceTests: CarSwaddleLoginTestCase {
    
    private let stripeService = StripeService(serviceRequest: serviceRequest)
    
    func testEphemeralKeys() {
        let exp = expectation(description: "\(#function)\(#line)")
        
        stripeService.getKeys(apiVersion: "2018-11-08") { json, error in
            XCTAssert(json != nil, "Json is nil")
            XCTAssert(error == nil, "Got error: \(error?.localizedDescription ?? "")")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testStripeVerification() {
        let exp = expectation(description: "\(#function)\(#line)")
        
        stripeService.getVerification { json, error in
            XCTAssert(json != nil, "Json is nil")
            XCTAssert((json?["fields_needed"] as? [String]) != nil, "Does not have fields needed")
            XCTAssert(error == nil, "Got error: \(error?.localizedDescription ?? "")")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testStripeBalance() {
        let exp = expectation(description: "\(#function)\(#line)")
        
        stripeService.getBalance { json, error in
            XCTAssert(json != nil, "Json is nil")
            
            if let available = json?["available"] as? [JSONObject], let first = available.first {
                XCTAssert((first["amount"] as? Int) != nil, "Should have available")
                XCTAssert((first["currency"] as? String) != nil, "Should have available")
            } else {
                XCTAssert(false, "Should have availabel")
            }
            if let reserved = json?["connect_reserved"] as? [JSONObject], let first = reserved.first {
                XCTAssert((first["amount"] as? Int) != nil, "Should have available")
                XCTAssert((first["currency"] as? String) != nil, "Should have available")
            } else {
                XCTAssert(false, "Should have connect_reserved")
            }
            if let pending = json?["pending"] as? [JSONObject], let first = pending.first {
                XCTAssert((first["amount"] as? Int) != nil, "Should have available")
                XCTAssert((first["currency"] as? String) != nil, "Should have available")
            } else {
                XCTAssert(false, "Should have pending")
            }
            XCTAssert(error == nil, "Got error: \(error?.localizedDescription ?? "")")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    
    /*
     {
     "object": "balance",
     "available": [
     {
     "amount": 0,
     "currency": "usd",
     "source_types": {
     "card": 0
     }
     }
     ],
     "connect_reserved": [
     {
     "amount": 0,
     "currency": "usd"
     }
     ],
     "livemode": false,
     "pending": [
     {
     "amount": 3466,
     "currency": "usd",
     "source_types": {
     "card": 3466
     }
     }
     ]
     }
     */
    
}
