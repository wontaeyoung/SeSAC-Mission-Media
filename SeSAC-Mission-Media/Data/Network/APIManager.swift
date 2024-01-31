//
//  APIManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Alamofire
import os
import Foundation

final class APIManager {
  
  // MARK: - Singleton
  static let shared = APIManager()
  private init() { }
  
  
  // MARK: - Method
  /// Request By ResponseDTO
  func callRequest<T: ResponseDTO, U: Model>(
    responseType: T.Type,
    router: Router,
    completion: @escaping ([U]) -> Void
  ) where T.Object.Entity == U {
    
    AF
      .request(router)
      .validate()
      .responseDecodable(of: T.self) { response in
        
        switch response.result {
            
          case .success(let result):
            let models = result.results.map { $0.asModel() }
            completion(models)
            
          case .failure(let error):
            LogManager.shared.log(with: error, to: .network)
        }
      }
  }
  
  /// Request By DTO
  func callRequest<T: DTO, U: Model>(
    responseType: T.Type,
    router: Router,
    completion: @escaping ([U]) -> Void
  ) where T.Entity == U {
    
    AF
      .request(router)
      .validate()
      .responseDecodable(of: [T].self) { response in
        
        switch response.result {
            
          case .success(let result):
            let models = result.map { $0.asModel() }
            completion(models)
            
          case .failure(let error):
            LogManager.shared.log(with: error, to: .network)
        }
      }
  }
}
