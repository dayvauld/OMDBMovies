//
//  MovieListViewModel.swift
//  OMDBMovies
//
//  Created by David Auld on 2024-04-10.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
  enum State: Equatable {
    case idle
    case loading
    case success(movies: Movies)
    case error(MovieServiceError)
  }
  
  @Published var state: State = .idle
  
  private var movieService: MovieService
  
  private var subscriptions = Set<AnyCancellable>()
  
  init(movieService: MovieService) {
    self.movieService = movieService
  }
  
  func searchByTitle(title: String) {
    self.state = .loading
    movieService.getMovies(searchTerm: title)
      .sink(receiveCompletion: { completion in
        guard case let .failure(error) = completion else { return }
        self.state = .error(error)
      }, receiveValue: { movies in
        self.state = .success(movies: movies)
      })
      .store(in: &subscriptions)
  }
}
