//
//  BindTests.swift
//  BindTests
//
//  Created by Albert Q Park on 1/16/22.
//

import XCTest
@testable import Bind

class BindTests: XCTestCase {
    var count = 0
    var waitServiceSeriese: XCTestExpectation?
    
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
    
    func testImageCalls() {
        let service = ServiceRoot()
        service.delegate = self
        let mainService = expectation(description: "service responsed")
        service.findPet { (a: Any?) in
            print(a ?? "nil")
            mainService.fulfill()
            XCTAssertNotNil(a)
        }
        
        wait(for: [mainService], timeout: 10)
        
        let _waitServiceSeriese = expectation(description: "image services")
        waitServiceSeriese = _waitServiceSeriese
        
        let animalWithPhoto = service.dataRoot.animals.filter { $0.animal.photos.count > 0 }
        
        _waitServiceSeriese.expectedFulfillmentCount = animalWithPhoto.count
        
        wait(for: [_waitServiceSeriese], timeout: 50)
        
        XCTAssertEqual(animalWithPhoto.count, count)
    }
}

extension BindTests: ServiceDelegate {
    func imageLoaded(index: Int) {
        count += 1
        waitServiceSeriese?.fulfill()
        print("index \(index) loaded")
    }
}
