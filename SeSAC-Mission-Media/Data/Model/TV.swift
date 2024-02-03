//
//  TV.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Foundation

struct TVResponseDTO: DTO {
  let results: [TVDTO]
  
  func asModel() -> TVResponse {
    return TVResponse(results: results.map { $0.asModel() })
  }
}

struct TVResponse: Model {
  let results: [TV]
}

struct TVDTO: DTO {
  let id: Int
  let name: String
  let overview: String
  let posterPath: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, overview
    case posterPath = "poster_path"
  }
  
  func asModel() -> TV {
    return TV(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath
    )
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? alternative.text
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? alternative.imagePath
  }
}

struct TV: Model {
  let id: Int
  let name: String
  let overview: String
  let posterPath: String
  
  var posterURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + posterPath)
  }
}
