//
//  BindTests.swift
//  BindTests
//
//  Created by Albert Q Park on 1/16/22.
//

import XCTest
@testable import Bind

class BindTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetOAuthBearerToken() {
        let service = ServiceRoot()
        
        let wait = expectation(description: "")
        
        service.oAuthNew { (a: Any?) in
            print(a ?? "nil")
            wait.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (e: Error?) in
            print(e ?? "nil")
        }
        
        XCTAssertNotNil(service.oauthBearerToken)
    }
    
    func testFindPet() {
        let service = ServiceRoot()
        let wait = expectation(description: "service responsed")
        
        service.findPet { (a: Any?) in
            print(a ?? "nil")
            wait.fulfill()
            XCTAssertNotNil(a)
        }
        
        waitForExpectations(timeout: 10) { (e:Error?) in
            print(e ?? "nil")
        }
    }
}
