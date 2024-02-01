//
//  TVDetail.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/1/24.
//

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
  let posterURL: String
  let backdropURL: String
  let runningTime: Int
  let genres: [GenreDTO]
  let networks: [NetworkDTO]
  
  // MARK: - Decoding
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case overview
    case startDate = "first_air_date"
    case posterURL = "poster_path"
    case backdropURL = "backdrop_path"
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
    self.posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL) ?? alternative.imageURL
    self.backdropURL = try container.decodeIfPresent(String.self, forKey: .backdropURL) ?? alternative.imageURL
    self.runningTime = try container.decodeIfPresent(Int.self, forKey: .runningTime) ?? alternative.minute
    self.genres = try container.decodeIfPresent([TVDetailDTO.GenreDTO].self, forKey: .genres) ?? []
    self.networks = try container.decodeIfPresent([TVDetailDTO.NetworkDTO].self, forKey: .networks) ?? []
  }
  
  // MARK: - Method
  func asModel() -> TVDetail {
    return TVDetail(
      id: id,
      name: name,
      overview: overview,
      startDate: startDate,
      posterURL: posterURL,
      backdropURL: backdropURL,
      runningTime: runningTime == .zero ? "-" : String(runningTime),
      genres: genres.map { $0.name },
      broadcasterName: networks.first?.name ?? Constant.AlternativeData.text,
      broadcasterLogo: networks.first?.logoURL ?? Constant.AlternativeData.imageURL
    )
  }
  
  struct GenreDTO: Decodable {
    let name: String
  }
  
  struct NetworkDTO: Decodable {
    let name: String
    let logoURL: String
    
    enum CodingKeys: String, CodingKey {
      case name
      case logoURL = "logo_path"
    }
  }
}

struct TVDetail: Model {
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterURL: String
  let backdropURL: String
  let runningTime: String
  let genres: [String]
  let broadcasterName: String
  let broadcasterLogo: String
}

