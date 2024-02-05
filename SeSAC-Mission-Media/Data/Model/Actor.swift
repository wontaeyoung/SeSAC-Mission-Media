//
//  Actor.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/3/24.
//

import Foundation

struct ActorResponseDTO: DTO {
  let results: [ActorDTO]
  
  enum CodingKeys: String, CodingKey {
    case results = "cast"
  }
  
  func asModel() -> ActorResponse {
    return ActorResponse(results: results.map { $0.asModel() })
  }
}

struct ActorResponse: Model {
  let results: [Actor]
}

struct ActorDTO: DTO {
  
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
  func asModel() -> Actor {
    return Actor(
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

struct Actor: Model {
  let id: Int
  let name: String
  let character: String
  let profilePath: String
  
  var profileURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + profilePath)
  }
}
