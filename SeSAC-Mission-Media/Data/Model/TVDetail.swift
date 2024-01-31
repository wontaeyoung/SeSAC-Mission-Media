//
//  TVDetail.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

struct TVDetailDTO: DTO {
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
  
  func asModel() -> TVDetail {
    return TVDetail(
      id: id,
      name: name,
      overview: overview,
      startDate: startDate,
      posterURL: posterURL ?? ""
    )
  }
}

struct TVDetail: Model {
  let id: Int
  let name: String
  let overview: String
  let startDate: String
  let posterURL: String
}
