//
//  Cast.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/3/24.
//

import Foundation

struct CastResponseDTO: DTO {
  let results: [CastDTO]
  
  func asModel() -> CastResponse {
    return CastResponse(results: results.map { $0.asModel() })
  }
}

struct CastResponse: Model {
  let results: [Cast]
}

struct CastDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let name: String
  let roles: [Role]
  let profilePath: String
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id, name
    case roles
    case profilePath = "profile_path"
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
    self.roles = try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? alternative.imagePath
  }
  
  // MARK: - Method
  func asModel() -> Cast {
    return Cast(
      id: id,
      name: name,
      character: roles.first?.character ?? "",
      profilePath: profilePath
    )
  }
  
  // MARK: - SubType
  struct Role: Decodable {
    let character: String
  }
}

struct Cast: Model {
  let id: Int
  let name: String
  let character: String
  let profilePath: String
  
  var profileURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + profilePath)
  }
}
