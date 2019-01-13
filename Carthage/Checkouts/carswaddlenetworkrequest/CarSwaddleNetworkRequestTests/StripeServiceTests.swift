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
    
    func testGetTransactions() {
        let exp = expectation(description: "\(#function)\(#line)")
        
        stripeService.getTransactions { json, error in
            XCTAssert(json != nil, "Json is nil")
            
            if let data = json?["data"] as? [JSONObject], let first = data.first {
                XCTAssert((first["id"] as? String) != nil, "Should have available")
                XCTAssert((first["amount"] as? Int) != nil, "Should have available")
                XCTAssert((first["available_on"] as? Int) != nil, "Should have available")
                XCTAssert((first["currency"] as? String) != nil, "Should have available")
//                XCTAssert((first["description"] as? String) != nil, "Should have available")
//                XCTAssert((first["exchange_rate"] as? String) != nil, "Should have available")
                XCTAssert((first["fee"] as? Int) != nil, "Should have available")
                XCTAssert((first["fee_details"] as? [Any]) != nil, "Should have available")
                XCTAssert((first["net"] as? Int) != nil, "Should have available")
                XCTAssert((first["source"] as? String) != nil, "Should have available")
                XCTAssert((first["status"] as? String) != nil, "Should have available")
                XCTAssert((first["type"] as? String) != nil, "Should have available")
            } else {
                XCTAssert(false, "Should have `data`.first")
            }
            
            XCTAssert((json?["has_more"] as? Bool) != nil, "Should have `hasMore`")
            XCTAssert(error == nil, "Got error: \(error?.localizedDescription ?? "")")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    /*
     {
     "id": "txn_1DrkLNEuZcoNxiqA9hcSyMmJ",
     "object": "balance_transaction",
     "amount": 4983,
     "available_on": 1547856000,
     "created": 1547291281,
     "currency": "usd",
     "description": null,
     "exchange_rate": null,
     "fee": 0,
     "fee_details": [],
     "net": 4983,
     "source": "py_1DrkLNEuZcoNxiqAGScYdQpJ",
     "status": "pending",
     "type": "payment"
     */
    
}
