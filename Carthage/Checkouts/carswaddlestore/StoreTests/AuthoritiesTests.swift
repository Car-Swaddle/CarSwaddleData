//
//  AuthoritiesTests.swift
//  StoreTests
//
//  Created by Kyle Kendall on 6/13/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import XCTest
@testable import Store

class AuthoritiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        try? store.destroyAllData()
        store.mainContext.persist()
    }
    
    func testCreateAuthority() {
        let authority = Authority.fetchOrCreate(json: authorityJSON, context: store.mainContext)
        XCTAssert(authority != nil, "Should have authority")
        XCTAssert(authority?.authorityConfirmation != nil, "Should have confirmation")
        XCTAssert(authority?.authorityConfirmation?.confirmer != nil, "Should have confirmation")
        XCTAssert(authority?.user != nil, "Should have confirmation")
        
        let result = store.mainContext.persist()
        
        XCTAssert(result, "Should be true")
    }
    
    func testCreateAuthority2() {
        let authority = Authority.fetchOrCreate(json: testAuthorityJSON, context: store.mainContext)
        XCTAssert(authority != nil, "Should have authority")
        XCTAssert(authority?.authorityConfirmation != nil, "Should have confirmation")
        XCTAssert(authority?.authorityConfirmation?.confirmer != nil, "Should have confirmation")
        XCTAssert(authority?.user != nil, "Should have confirmation")
        
        let result = store.mainContext.persist()
        
        XCTAssert(result, "Should be true")
    }
    
    func testCreateAuthorityRequest() {
        let authorityRequest = AuthorityRequest.fetchOrCreate(json: authorityRequestJSON, context: store.mainContext)
        XCTAssert(authorityRequest != nil, "Should have authority")
        XCTAssert(authorityRequest?.requester != nil, "Should have confirmation")
        
        let result = store.mainContext.persist()
        
        XCTAssert(result, "Should be true")
    }
    
    func testCreateAuthorityRequest2() {
        let authorityRequest = AuthorityRequest.fetchOrCreate(json: authorityRequestJSON2, context: store.mainContext)
        XCTAssert(authorityRequest != nil, "Should have authority")
        XCTAssert(authorityRequest?.requester != nil, "Should have confirmation")
        
        let result = store.mainContext.persist()
        
        XCTAssert(result, "Should be true")
    }
    
}

private let authorityJSON: [String: Any] = [
    "id": "5c37d130-8e5f-11e9-8136-ffee546f26bb",
    "authorityName": "editAuthorities",
    "createdAt": "2019-06-14T04:46:23.176Z",
    "updatedAt": "2019-06-14T04:46:23.176Z",
    "userID": "19a48340-8e5f-11e9-8136-ffee546f26bb",
    "authorityConfirmation": [
        "id": "5c364a90-8e5f-11e9-8136-ffee546f26bb",
        "status": "approved",
        "createdAt": "2019-06-14T04:46:23.161Z",
        "updatedAt": "2019-06-14T04:46:23.189Z",
        "authorityID": "5c37d130-8e5f-11e9-8136-ffee546f26bb",
        "confirmerID": "19a48340-8e5f-11e9-8136-ffee546f26bb",
        "authorityRequestID": "27d09850-8e5f-11e9-8136-ffee546f26bb",
        "user": [
            "firstName": NSNull(),
            "lastName": NSNull(),
            "id": "19a48340-8e5f-11e9-8136-ffee546f26bb",
            "profileImageID": NSNull(),
            "email": "kyle@carswaddle.com",
            "phoneNumber": NSNull(),
            "timeZone": "America/Denver"
        ]
    ],
    "user": [
        "firstName": NSNull(),
        "lastName": NSNull(),
        "id": "19a48340-8e5f-11e9-8136-ffee546f26bb",
        "profileImageID": NSNull(),
        "email": "kyle@carswaddle.com",
        "phoneNumber": NSNull(),
        "timeZone": "America/Denver"
    ]
]

private let authorityRequestJSON: [String: Any] = [
    "id": "27d09850-8e5f-11e9-8136-ffee546f26bb",
    "authorityName": "editAuthorities",
    "expirationDate": "2019-06-15T04:44:55.253Z",
    "createdAt": "2019-06-14T04:44:55.254Z",
    "updatedAt": "2019-06-14T04:44:55.254Z",
    "authorityID": NSNull(),
    "requesterID": "19a48340-8e5f-11e9-8136-ffee546f26bb",
    "user": [
        "firstName": NSNull(),
        "lastName": NSNull(),
        "id": "19a48340-8e5f-11e9-8136-ffee546f26bb",
        "profileImageID": NSNull(),
        "email": "kyle@carswaddle.com",
        "phoneNumber": NSNull(),
        "timeZone": "America/Denver"
        ] as [String: Any],
    "authorityConfirmation": [
        "id": "5c364a90-8e5f-11e9-8136-ffee546f26bb",
        "status": "approved",
        "createdAt": "2019-06-14T04:46:23.161Z",
        "updatedAt": "2019-06-14T04:46:23.189Z",
        "authorityID": "5c37d130-8e5f-11e9-8136-ffee546f26bb",
        "confirmerID": "19a48340-8e5f-11e9-8136-ffee546f26bb",
        "authorityRequestID": "27d09850-8e5f-11e9-8136-ffee546f26bb"
    ]
]



private let testAuthorityJSON: [String: Any] = [
    "requesterID": "ad1b8fe0-92a3-11e9-92eb-bb97e25e7bcd",
    "authorityName": "someAuthorityA9408C3E-8493-40DD-A47B-FC04BE6AC8A7",
    "authorityConfirmation": NSNull(),
    "user": [
        "email": "mechanic@carswaddle.com",
        "firstName": NSNull(),
        "id": "ad1b8fe0-92a3-11e9-92eb-bb97e25e7bcd",
        "lastName": NSNull(),
        "phoneNumber": NSNull(),
        "profileImageID": NSNull(),
        "timeZone": "America/Denver"
    ],
    "secretID": "5e15a741-92a4-11e9-92eb-bb97e25e7bcd",
    "expirationDate": "2019-06-20T15:10:26.228Z", "id": "5e15a740-92a4-11e9-92eb-bb97e25e7bcd",
    "authorityID": NSNull()
]

private let authorityRequestJSON2: [String: Any] = [
    "secretID": "62f30781-8f2f-11e9-a954-6b4feb351242",
    "updatedAt": "2019-06-15T05:35:29.785Z",
    "expirationDate": "2019-06-16T05:35:29.784Z",
    "requesterID": "19a48340-8e5f-11e9-8136-ffee546f26bb",
    "authorityID": NSNull(),
    "id": "62f30780-8f2f-11e9-a954-6b4feb351242",
    "createdAt": "2019-06-15T05:35:29.785Z",
    "authorityName": "someAuthoritysgUdtJWyN6",
    "user": [
        "email": "kyle@carswaddle.com",
        "firstName": NSNull(),
        "id": "19a48340-8e5f-11e9-8136-ffee546f26bb",
        "lastName": NSNull(),
        "phoneNumber": NSNull(),
        "profileImageID": NSNull(),
        "timeZone": "America/Denver",
    ]
]




/*
 
 ["createdAt": 2019-06-15T05:44:14.611Z, "authorityName": someAuthorityUsnYYBBSvD, "requesterID": 19a48340-8e5f-11e9-8136-ffee546f26bb, "authorityID": <null>, "expirationDate": 2019-06-16T05:44:14.610Z, "updatedAt": 2019-06-15T05:44:14.611Z, , "id": 9bc51f20-8f30-11e9-9571-f1a6d19d87af, "secretID": 9bc51f21-8f30-11e9-9571-f1a6d19d87af]
 */
