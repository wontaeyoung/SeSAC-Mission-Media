//
//  AppError.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

protocol AppError: Error {
  var logDescription: String { get }
  var alertDescription: (title: String, message: String) { get }
  
}
