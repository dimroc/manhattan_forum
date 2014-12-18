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

    func testParsingValidGoogleResponse() {
        let fixture = TestHelper.loadJsonFixture("geocodeResponse")
        let location = MFLocation.fromGoogleJson(fixture)
        
        XCTAssertEqual(location.neighborhood!, "East Village")
        XCTAssertEqual(location.sublocality!, "Manhattan")
        XCTAssertEqual(location.locality!, "New York")
        XCTAssertEqual(location.coordinate!.latitude, 40.7292449)
        XCTAssertEqual(location.coordinate!.longitude, -73.9873784)
    }
    
    func testParsingNoHoodGoogleResponse() {
        let fixture = TestHelper.loadJsonFixture("noHoodGeocodeResponse")
        let location = MFLocation.fromGoogleJson(fixture)
        
        XCTAssert(location.neighborhood == nil, "Should be nil")
        XCTAssertEqual(location.sublocality!, "Manhattan")
        XCTAssertEqual(location.description, "Manhattan")
    }
    
    func testParsingWrongKeysGoogleResponse() {
        let fixture = TestHelper.loadJsonFixture("wrongKeysGeocodeResponse")
        let location = MFLocation.fromGoogleJson(fixture)
        
        XCTAssertEqual(location, MFLocation.empty())
    }
}
