//
//  Media.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Foundation

struct MediaResponseDTO: DTO {
  let results: [MediaDTO]
  
  func toEntity() -> MediaResponse {
    return MediaResponse(results: results.map { $0.toEntity() })
  }
}

struct MediaResponse: Entity {
  let results: [Media]
}

struct MediaDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let title: String
  let overview: String
  let posterPath: String
  
  /// Client Created
  let type: String
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case tvTitle = "name", movieTitle = "title"
    case overview
    case posterPath = "poster_path"
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? alternative.text
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? alternative.imagePath
    
    if let tvTitle = try container.decodeIfPresent(String.self, forKey: .tvTitle) {
      self.title = tvTitle
      self.type = MediaType.tv.rawValue
    } else {
      self.title = try container.decodeIfPresent(String.self, forKey: .movieTitle) ?? alternative.text
      self.type = MediaType.movie.rawValue
    }
  }
  
  // MARK: - Method
  func toEntity() -> Media {
    return Media(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      type: MediaType(rawValue: type) ?? .unknown
    )
  }
}

struct Media: Entity {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String
  let type: MediaType
  
  var posterURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + posterPath)
  }
}

enum MediaType: String {
  case tv
  case movie
  case unknown
}
