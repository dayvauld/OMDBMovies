//
//  APIService.swift
//  OMDBMovies
//
//  Created by David Auld on 2024-04-10.
//

import Foundation
import Combine

enum MovieServiceError: Error {
  case generalError
  case movieNotFound
  case tooManyResults
}

protocol MovieService {
  func getMovies(searchTerm: String) -> AnyPublisher<Movies, MovieServiceError>
}

class OMDBService: MovieService {
  let urlSession: URLSession
  
  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  func getMovies(searchTerm: String) -> AnyPublisher<Movies, MovieServiceError> {
    let url = URL(string: "http://www.omdbapi.com/?s=\(searchTerm)&apikey=fd91ab31")!
    return urlSession.dataTaskPublisher(for: url)
      .map {
#if DEBUG // Print JSON response in debug mode
        if let jsonString = String(data: $0.data, encoding: .utf8) {
          print(jsonString)
        } else {
          print("Failed to convert Data to JSON String")
        }
#endif
        return $0.data
      }
      .decode(type: Movies.self, decoder: JSONDecoder())
      .tryMap {
        if !$0.responseSuccessful {
          switch $0.errorMessage {
          case "Movie not found!":
            throw MovieServiceError.movieNotFound
          case "Too many results.":
            throw MovieServiceError.tooManyResults
          default:
            throw MovieServiceError.generalError
          }
        }
        return $0
      }
      .mapError { error in
        if let error = error as? MovieServiceError {
          return error
        }
        return MovieServiceError.generalError
      }
      .eraseToAnyPublisher()
  }
}
