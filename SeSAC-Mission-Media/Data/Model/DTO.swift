//
//  DTO.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

protocol ResponseDTO: Decodable {
  associatedtype Object: DTO
  
  var results: [Object] { get }
}


protocol DTO: Decodable {
  associatedtype Entity: Model
  
  func asModel() -> Entity
}
