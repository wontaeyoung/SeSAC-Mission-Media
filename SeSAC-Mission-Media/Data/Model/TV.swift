//
//  TV.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

struct TVResponseDTO: ResponseDTO {
  let results: [TVDTO]
}

struct TVDTO: DTO {
  let name: String
  let posterURL: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case posterURL = "poster_path"
  }
  
  func asModel() -> TV {
    return TV(name: name, posterURL: posterURL ?? "")
  }
}

struct TV: Model {
  let name: String
  let posterURL: String
}
