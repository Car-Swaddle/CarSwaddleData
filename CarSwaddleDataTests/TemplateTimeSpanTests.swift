//
//  TemplateTimeSpanTests.swift
//  CarSwaddleDataTests
//
//  Created by Kyle Kendall on 10/23/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleData
import CoreData

class TemplateTimeSpanTests: LoginTestCase {
    
    let network = TemplateTimeSpanNetwork()
    
    func testSavingTemplateTimeSpans() {
        let exp = expectation(description: "\(#function)\(#line)")
        let context = store.mainContext
        network.getTimeSpans(in: context) { ids, error in
            XCTAssert(ids.count > 0, "Should have ids")
            print(ids)
            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }

}
