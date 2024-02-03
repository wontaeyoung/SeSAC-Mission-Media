//
//  TVDetail.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import Foundation

struct TVDetailResponseDTO: DTO {
  let results: [TVDetailDTO]
  
  func asModel() -> TVDetailResponse {
    return TVDetailResponse(results: results.map { $0.asModel() })
  }
}

struct TVDetailResponse: Model {
  let results: [TVDetail]
}

struct TVDetailDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterPath: String
  let backdropPath: String
  let runningTime: Int
  let genres: [GenreDTO]
  let networks: [NetworkDTO]
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case overview
    case startDate = "first_air_date"
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case runningTime = "episode_run_time"
    case genres
    case networks
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? alternative.text
    self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate) ?? alternative.date
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? alternative.imagePath
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? alternative.imagePath
    self.runningTime = try container.decodeIfPresent([Int].self, forKey: .runningTime)?.first ?? alternative.minute
    self.genres = try container.decodeIfPresent([GenreDTO].self, forKey: .genres) ?? []
    self.networks = try container.decodeIfPresent([NetworkDTO].self, forKey: .networks) ?? []
  }
  
  // MARK: - Method
  func asModel() -> TVDetail {
    return TVDetail(
      id: id,
      name: name,
      overview: overview,
      startDate: startDate,
      posterPath: posterPath,
      backdropPath: backdropPath,
      runningTime: runningTime == .zero ? "" : String(runningTime),
      genres: genres.map { $0.name },
      broadcasterName: networks.first?.name ?? Constant.AlternativeData.text,
      broadcasterLogoPath: networks.first?.logoPath ?? Constant.AlternativeData.imagePath
    )
  }
  
  struct GenreDTO: Decodable {
    let name: String
    
    enum CodingKeys: CodingKey {
      case name
    }
    
    init(from decoder: Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? Constant.AlternativeData.text
    }
  }
  
  struct NetworkDTO: Decodable {
    let name: String
    let logoPath: String
    
    enum CodingKeys: String, CodingKey {
      case name
      case logoPath = "logo_path"
    }
    
    init(from decoder: Decoder) throws {
      let alternative = Constant.AlternativeData.self
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      
      self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? alternative.text
      self.logoPath = try container.decodeIfPresent(String.self, forKey: .logoPath) ?? alternative.imagePath
    }
  }
}

struct TVDetail: Model {
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterPath: String
  let backdropPath: String
  let runningTime: String
  let genres: [String]
  let broadcasterName: String
  let broadcasterLogoPath: String
  
  var posterURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + posterPath)
  }
  
  var backdropURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + backdropPath)
  }
  
  var broadcasterLogoURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + broadcasterLogoPath)
  }
}

