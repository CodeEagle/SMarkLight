//
//  SMarkLightTests.swift
//  SMarkLightTests
//
//  Created by LawLincoln on 16/8/30.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import XCTest
@testable import SMarkLight

class SMarkLightTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testExample() {
		let a = SMarkTheme()
		print(a)
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			// Put the code you want to measure the time of here.
		}
	}

}
