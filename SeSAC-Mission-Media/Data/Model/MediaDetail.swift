//
//  MediaDetail.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

import Foundation

struct MediaDetailResponseDTO: DTO {
  let results: [MediaDetailDTO]
  
  func asModel() -> MediaDetailResponse {
    return MediaDetailResponse(results: results.map { $0.asModel() })
  }
}

struct MediaDetailResponse: Model {
  let results: [MediaDetail]
}

struct MediaDetailDTO: DTO {
  
  // MARK: - Property
  let id: Int
  let title: String
  let overview: String
  let startDate: String
  let posterPath: String
  let backdropPath: String
  let runningTime: Int
  let genres: [GenreDTO]
  let company: CompanyDTO
  
  /// Client Created
  let type: String
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case tvTitle = "name", movieTitle = "title"
    case overview
    case tvStartDate = "first_air_date", movieStartDate = "release_date"
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case tvRuntime = "episode_run_time", movieRuntime = "runtime"
    case genres
    case tvCompany = "networks", movieCompany = "production_companies"
  }
  
  init(from decoder: Decoder) throws {
    let alternative = Constant.AlternativeData.self
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? alternative.id
    self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? alternative.text
    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? alternative.imagePath
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? alternative.imagePath
    self.genres = try container.decodeIfPresent([GenreDTO].self, forKey: .genres) ?? []
    
    if let tvTitle = try container.decodeIfPresent(String.self, forKey: .tvTitle) {
      self.title = tvTitle
      self.type = "tv"
    } else {
      self.title = try container.decodeIfPresent(String.self, forKey: .movieTitle) ?? alternative.text
      self.type = "movie"
    }
    
    if let tvStartDate = try container.decodeIfPresent(String.self, forKey: .tvStartDate) {
      self.startDate = tvStartDate
    } else {
      self.startDate = try container.decodeIfPresent(String.self, forKey: .movieStartDate) ?? alternative.date
    }
    
    if let tvRuntime = try container.decodeIfPresent([Int].self, forKey: .tvRuntime)?.first {
      self.runningTime = tvRuntime
    } else {
      self.runningTime = try container.decodeIfPresent(Int.self, forKey: .movieRuntime) ?? alternative.minute
    }
    
    if let tvCompany = try container.decodeIfPresent([CompanyDTO].self, forKey: .tvCompany)?.first {
      self.company = tvCompany
    } else if let movieCompany = try container.decodeIfPresent([CompanyDTO].self, forKey: .movieCompany)?.first {
      self.company = movieCompany
    } else {
      self.company = CompanyDTO(name: alternative.text, logoPath: alternative.imagePath)
    }
  }
  
  // MARK: - Method
  func asModel() -> MediaDetail {
    return MediaDetail(
      id: id,
      name: title,
      overview: overview,
      startDate: startDate,
      posterPath: posterPath,
      backdropPath: backdropPath,
      runningTime: runningTime == .zero ? "" : String(runningTime),
      genres: genres.map { $0.name },
      companyName: company.name,
      companyLogoPath: company.logoPath,
      type: MediaType(rawValue: type) ?? .unknown
    )
  }
  
  // MARK: - SubType
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
  
  struct CompanyDTO: Decodable {
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
    
    init(name: String, logoPath: String) {
      self.name = name
      self.logoPath = logoPath
    }
  }
}

struct MediaDetail: Model {
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterPath: String
  let backdropPath: String
  let runningTime: String
  let genres: [String]
  let companyName: String
  let companyLogoPath: String
  let type: MediaType
  
  var posterURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + posterPath)
  }
  
  var backdropURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + backdropPath)
  }
  
  var broadcasterLogoURL: URL? {
    return URL(string: APIKey.TMDB.imageRequestPath + companyLogoPath)
  }
}

