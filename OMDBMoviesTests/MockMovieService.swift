//
//  MockMovieService.swift
//  OMDBMoviesTests
//
//  Created by David Auld on 2024-04-11.
//

import Foundation
import Combine

@testable import OMDBMovies

class MockMovieService: MovieService {
  let throwFailure: Bool
  let mockDelay: Bool
  let mockMovieSearch: Movies
  
  static let defaultMovies = Movies(
    searchResults: [
      mockMovie(),
      mockMovie(),
    ],
    responseSuccessful: true,
    errorMessage: nil)
  
  init(throwFailure: Bool = false, mockDelay: Bool = false, mockMovieSearch: Movies? = nil) {
    self.throwFailure = throwFailure
    self.mockDelay = mockDelay
    self.mockMovieSearch = mockMovieSearch ?? MockMovieService.defaultMovies
  }
  
  func getMovies(searchTerm: String) -> AnyPublisher<Movies, MovieServiceError> {
    if throwFailure {
      return Fail(error: MovieServiceError.generalError)
        .eraseToAnyPublisher()
    } else {
      return Just(mockMovieSearch)
        .delay(for: mockDelay ? 5 : 0, scheduler: RunLoop.main)
        .setFailureType(to: MovieServiceError.self)
        .eraseToAnyPublisher()
    }
  }
  
  static func mockMovie() -> Movie {
    return Movie(
      title: "Mock Movie " + String(Int.random(in: 0...200)),
      year: "19" + String(Int.random(in: 10...99)),
      imdbId: UUID().uuidString,
      type: "movie",
      poster: "mockPoster")
  }
}
