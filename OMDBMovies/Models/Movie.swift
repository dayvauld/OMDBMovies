//
//  Movie.swift
//  OMDBMovies
//
//  Created by David Auld on 2024-04-11.
//

import Foundation

struct Movies: Codable, Hashable {
  let searchResults: [Movie]?
  let responseSuccessful: Bool
  let errorMessage: String?
  
  private enum CodingKeys : String, CodingKey {
    case searchResults = "Search"
    case responseSuccessful = "Response"
    case errorMessage = "Error"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    searchResults = try container.decodeIfPresent([Movie].self, forKey: .searchResults)
    errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
    let responseString = try container.decode(String.self, forKey: .responseSuccessful)
    responseSuccessful = responseString.lowercased() == "true"
  }
  
  init(searchResults: [Movie], responseSuccessful: Bool, errorMessage: String?) {
    self.searchResults = searchResults
    self.responseSuccessful = responseSuccessful
    self.errorMessage = errorMessage
  }
}

struct Movie: Codable, Hashable {
  let title : String
  let year : String
  let imdbId : String
  let type : String
  let poster : String
  
  private enum CodingKeys : String, CodingKey {
    case title = "Title"
    case year = "Year"
    case imdbId = "imdbID"
    case type = "Type"
    case poster = "Poster"
  }
  
  static func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.imdbId == rhs.imdbId
  }
}

