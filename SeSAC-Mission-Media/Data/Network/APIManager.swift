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
  func callRequest<T: DTO, U: Model>(
    responseType: T.Type,
    router: Router,
    completion: @escaping ([U]) -> Void
  ) where T.Entity == U {
    
    AF
      .request(router)
      .validate()
      .responseDecodable(of: T.self) { [weak self] response in
        
        guard let self else { return }
        
        switch response.result {
            
          case .success(let dto):
            completion(dto.results)
            
          case .failure(let error):
            LogManager.shared.log(with: error, to: .network)
        }
      }
  }
}
