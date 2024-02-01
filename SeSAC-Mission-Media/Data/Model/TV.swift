//
//  TV.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

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
  let startDate: String
  let posterURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, overview
    case startDate = "first_air_date"
    case posterURL = "poster_path"
  }
  
  func asModel() -> TV {
    return TV(
      id: id,
      name: name,
      overview: overview,
      startDate: startDate,
      posterURL: posterURL ?? ""
    )
  }
}

struct TV: Model {
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterURL: String
}
