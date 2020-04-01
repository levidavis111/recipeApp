//
//  AzureOverallTests.swift
//  AzureOverallTests
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import XCTest
@testable import AzureOverall

class AzureOverallTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRecipeFromJSON() {
        let recipeService = RecipeClientService()
        let testBundle = Bundle(for: type(of: self))
        guard let pathToData = testBundle.path(forResource: "RecipeJSON", ofType: "json") else {XCTFail(); return}
        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            let recipes = recipeService.getRecipes(from: data)
            guard recipes.count > 0 else {XCTFail(); print("there are \(recipes.count))"); return}
        } catch {
            XCTFail()
        }
        XCTAssert(true)
    }

}
