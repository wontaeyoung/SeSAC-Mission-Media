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
    case personResults = "results", castResults = "cast"
  }
  
  func toEntity() -> ActorResponse {
    return ActorResponse(results: results.map { $0.toEntity() })
  }
  
  /// cast에서 사용하는 배우와 person에서 사용하는 배우의 items 프로퍼티 키가 다른 상황
  /// 조건 분기로 현재 Response에서 전달한 프로퍼티 키를 찾아서 할당하는 로직 필요
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    /// results 프로퍼티로 디코딩이 가능하지 않으면 -> cast 프로퍼티로 디코딩 시도
    if let personResults = try container.decodeIfPresent([ActorDTO].self, forKey: .personResults) {
      self.results = personResults
    } else {
      self.results = try container.decodeIfPresent([ActorDTO].self, forKey: .castResults) ?? []
    }
  }
}

struct ActorResponse: Entity {
  let results: [Actor]
}

struct ActorDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let name: String
  let profilePath: String
  
  /// cast
  let roles: [Role]
  
  /// person
  let filmography: [MediaDTO]
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case profilePath = "profile_path"
    case roles
    case filmography = "known_for"
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
    self.roles = try container.decodeIfPresent([Role].self, forKey: .roles) ?? []
    self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? alternative.imagePath
    self.filmography = try container.decodeIfPresent([MediaDTO].self, forKey: .filmography) ?? []
  }
  
  // MARK: - Method
  func toEntity() -> Actor {
    return Actor(
      id: id,
      name: name,
      character: roles.first?.character ?? "",
      profilePath: profilePath,
      filmography: filmography.map { $0.toEntity() }
    )
  }
  
  // MARK: - SubType
  struct Role: Decodable {
    let character: String
  }
}

struct Actor: Entity {
  let id: Int
  let name: String
  let character: String
  let profilePath: String
  let filmography: [Media]
  var bioInfo: ActorBio?
  
  var profileURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + profilePath)
  }
  
  mutating func combineMoreInfo(with actorBio: ActorBio) {
    self.bioInfo = actorBio
  }
}

struct ActorBioDTO: DTO {
  let birthday: String
  let biography: String
  
  func toEntity() -> ActorBio {
    return ActorBio(birthday: birthday, biography: biography)
  }
}

struct ActorBio: Entity {
  let birthday: String
  let biography: String
}
