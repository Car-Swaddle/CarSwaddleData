//
//  StripeTests.swift
//  StoreTests
//
//  Created by Kyle Kendall on 1/12/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import XCTest
@testable import Store


class StripeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        try? store.destroyAllData()
    }
    
    func testCreateBalance() {
        let context = store.mainContext
        let balance = Balance(json: balanceJSON, context: context)
        context.persist()
        XCTAssert(balance != nil, "Must have region from: \(balanceJSON)")
    }
    
}


private let balanceJSON: [String: Any] = [
    "object": "balance",
    "available": [
        [
            "amount": Int(0),
            "currency": "usd",
            "source_types": [
                "card": Int(0)
            ]
        ]
    ],
    "connect_reserved": [
        [
            "amount": Int(0),
            "currency": "usd"
        ]
    ],
    "livemode": false,
    "pending": [
        [
            "amount": Int(3466),
            "currency": "usd",
            "source_types": [
                "card": Int(3466)
            ]
        ]
    ]
]
