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
    
    func testCreateBalanceReserved() {
        let context = store.mainContext
        var json = balanceJSON
        json["connect_reserved"] = nil
        let balance = Balance(json: json, context: context)
        context.persist()
        XCTAssert(balance != nil, "Must have region from: \(json)")
    }
    
    func testTransaction() {
        let context = store.mainContext
        let json = singleTransaction
        let transaction = Transaction(json: json, context: context)
        context.persist()
        XCTAssert(transaction != nil, "Must have transaction from: \(json)")
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

private let singleTransaction: [String: Any] = [
    "id": "txn_1DrkLNEuZcoNxiqA9hcSyMmJ",
    "object": "balance_transaction",
    "amount": 4983,
    "available_on": 1547856000,
    "created": 1547291281,
    "currency": "usd",
    "description": NSNull(),
    "exchange_rate": NSNull(),
    "fee": 0,
    "fee_details": [],
    "net": 4983,
    "source": "py_1DrkLNEuZcoNxiqAGScYdQpJ",
    "status": "pending",
    "type": "payment"
]

private let transactionJSON: [String: Any] = [
    "object": "list",
    "data": [
        singleTransaction,
    ],
    "has_more": false,
    "url": "/v1/balance/history"
]
