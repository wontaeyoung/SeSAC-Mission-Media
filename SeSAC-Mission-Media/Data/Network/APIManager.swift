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
  func callRequest<D: DTO>(
    responseType: D.Type,
    router: Router,
    completion: @escaping (D.EntityType) -> Void
  ) {
    
    AF.request(router)
      .validate()
      .responseDecodable(of: responseType.self) { response in
        
        switch response.result {          
          case .success(let result):
            completion(result.toEntity())
            
          case .failure(let error):
            LogManager.shared.log(with: error, to: .network)
        }
      }
  }
}
