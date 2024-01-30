//
//  TVModel.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

struct TMDBTVResponse: Decodable {
  let results: [TV]
}

struct TV: Model {
  let name: String
  let posterURL: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case posterURL = "poster_path"
  }
}
