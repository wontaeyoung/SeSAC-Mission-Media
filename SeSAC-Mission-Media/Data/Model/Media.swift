//
//  Media.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Foundation

struct MediaResponseDTO: DTO {
  let results: [MediaDTO]
  
  func asModel() -> MediaResponse {
    return MediaResponse(results: results.map { $0.asModel() })
  }
}

struct MediaResponse: Model {
  let results: [Media]
}

struct MediaDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let title: String
  let overview: String
  let posterPath: String
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case name, title
    case overview
    case posterPath = "poster_path"
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.title = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? alternative.text
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? alternative.imagePath
  }
  
  // MARK: - Method
  func asModel() -> Media {
    return Media(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath
    )
  }
}

struct Media: Model {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String
  
  var posterURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + posterPath)
  }
}
