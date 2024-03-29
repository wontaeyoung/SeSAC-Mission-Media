//
//  DTO.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

protocol DTO: Decodable {
  associatedtype EntityType: Entity
  
  func toEntity() -> EntityType
}
