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
  
  static let shared = APIManager()
  
  private init() { }
  
  private let networkLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "",
    category: "Network"
  )
  
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
            networkLogger.error("Request Failed: \(error.localizedDescription)")
        }
      }
  }
}
