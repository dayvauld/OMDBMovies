//
//  OMDBMoviesUITests.swift
//  OMDBMoviesUITests
//
//  Created by David Auld on 2024-04-10.
//

import XCTest

final class OMDBMoviesUITests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_collectionViewPopulatesFromSearchAndTapCell() throws {
    let app = XCUIApplication()
    app.launch()
    
    let searchOrEnterMovieNameTextField = app.textFields["Search or enter movie name"]
    searchOrEnterMovieNameTextField.tap()
    searchOrEnterMovieNameTextField.typeText("Batman")
    
    // check if collectionview has elements
    let collectionView = app.collectionViews.firstMatch
    let cells = collectionView.cells
    
    // detect cell with Batman begins exists
    let movieLabel = app.staticTexts["Batman Begins"]
    XCTAssert(movieLabel.exists)
    
    // tap first cell
    cells.firstMatch.tap()
    
    // detect navigation to detail page
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
