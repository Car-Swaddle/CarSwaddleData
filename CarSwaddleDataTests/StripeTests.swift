//
//  StripeTests.swift
//  CarSwaddleDataTests
//
//  Created by Kyle Kendall on 12/27/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleData
import Store

class StripeTests: LoginTestCase {
    
    private let stripeNetwork: StripeNetwork = StripeNetwork(serviceRequest: serviceRequest)
    
    func testRequestVerification() {
        let exp = expectation(description: "\(#function)\(#line)")
        self.stripeNetwork.requestVerification { verification, error in
            XCTAssert(verification != nil, "Should have fields needed")
            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testRequestBalance() {
        let exp = expectation(description: "\(#function)\(#line)")
        store.privateContext { pCtx in
            self.stripeNetwork.requestBalance(in: pCtx) { objectID, error in
                store.mainContext{ mCtx in
                    if let objectID = objectID, let balance = mCtx.object(with: objectID) as? Balance {
                        let mechanic = Mechanic.currentLoggedInMechanic(in: mCtx)
                        XCTAssert(mechanic?.balance == balance, "Should have balance")
                    } else {
                        XCTAssert(false, "No balance.")
                    }
                    exp.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
}
