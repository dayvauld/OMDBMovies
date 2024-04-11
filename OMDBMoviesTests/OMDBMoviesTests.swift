//
//  OMDBMoviesTests.swift
//  OMDBMoviesTests
//
//  Created by David Auld on 2024-04-10.
//

import XCTest
import Combine
@testable import OMDBMovies

final class OMDBMoviesTests: XCTestCase {
  var subscriptions: Set<AnyCancellable>!
  
  override func setUp() {
    subscriptions = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    subscriptions = nil
    super.tearDown()
  }
  
  func test_fetchMovies() {
    let expectation = XCTestExpectation(description: "Fetch movies")
    let mockMovieService = MockMovieService(throwFailure: false)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    viewModel.$state
      .dropFirst()
      .sink { state in
        switch state {
        case .success(let movies):
          XCTAssertNotNil(movies)
          expectation.fulfill()
        default:
          break
        }
      }
      .store(in: &subscriptions)
    
    viewModel.searchByTitle(title: "batman")
    wait(for: [expectation], timeout: 5)
  }
  
  func test_idleState() {
    let mockMovieService = MockMovieService(throwFailure: false)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    XCTAssertEqual(viewModel.state, .idle)
  }
  
  func test_loadingState() {
    let mockMovieService = MockMovieService(throwFailure: false, mockDelay: true)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    XCTAssertEqual(viewModel.state, .idle)
    viewModel.searchByTitle(title: "batman")
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      XCTAssertEqual(viewModel.state, .loading)
    }
  }
  
  func test_successState() {
    let movieSearch = Movies(
      searchResults: [
        MockMovieService.mockMovie(),
        MockMovieService.mockMovie(),
        MockMovieService.mockMovie(),
      ],
      responseSuccessful: true,
      errorMessage: nil)
    let mockMovieService = MockMovieService(mockMovieSearch: movieSearch)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    XCTAssertEqual(viewModel.state, .idle)
    
    viewModel.searchByTitle(title: "batman")
    // Simulate the asynchronous data loading
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .success(movies: movieSearch))
    }
  }
  
  func test_errorState() {
    let mockMovieService = MockMovieService(throwFailure: true)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    XCTAssertEqual(viewModel.state, .idle)
    
    viewModel.searchByTitle(title: "batman")
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .error(.generalError))
    }
  }
  
  func test_errorStateFromResponse() {
    let movieSearch = Movies(
      searchResults: [],
      responseSuccessful: false,
      errorMessage: "Too many results.")
    let mockMovieService = MockMovieService(mockMovieSearch: movieSearch)
    let viewModel = MovieListViewModel(movieService: mockMovieService)
    XCTAssertEqual(viewModel.state, .idle)
    
    viewModel.searchByTitle(title: "batman")
    DispatchQueue.main.async {
      XCTAssertEqual(viewModel.state, .error(.tooManyResults))
    }
  }
}
