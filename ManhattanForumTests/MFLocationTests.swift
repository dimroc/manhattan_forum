//
//  MFLocationTests.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/15/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit
import XCTest

class MFLocationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParsingGoogleResponse() {
        let fixture = TestHelper.loadJsonFixture("geocodeResponse")
        let location = MFLocation(response: fixture)
        XCTAssert(true, "Pass")
    }
}