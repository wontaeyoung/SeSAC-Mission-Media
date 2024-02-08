//
//  Video.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import Foundation

struct VideoResponseDTO: DTO {
  
  let results: [VideoDTO]
  
  func toEntity() -> VideoResponse {
    return VideoResponse(results: results.map { $0.toEntity() })
  }
}

struct VideoResponse: Entity {
  
  let results: [Video]
}

struct VideoDTO: DTO {
  
  let key: String
  let site: String
  
  enum CodingKeys: CodingKey {
    case key
    case site
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
    self.site = try container.decodeIfPresent(String.self, forKey: .site) ?? "Youtube"
  }
  
  func toEntity() -> Video {
    return Video(key: key, site: site)
  }
}

struct Video: Entity {
  
  let key: String
  let site: String
}
