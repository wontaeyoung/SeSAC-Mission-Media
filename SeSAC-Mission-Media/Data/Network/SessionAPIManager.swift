//
//  SessionAPIManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import Foundation

enum SessionError: AppError {
  
  case invalidURL
  case requestFailed
  case noData
  case invalidResponse
  case unexceptedResponse(status: Int)
  case dataDecodingFailed
  
  var logDescription: String {
    switch self {
      case .invalidURL:
        return "유효하지 않은 URL입니다."
        
      case .requestFailed:
        return "요청에 실패했습니다."
        
      case .noData:
        return "응답 데이터를 찾을 수 없습니다."
        
      case .invalidResponse:
        return "유효하지 않은 응답입니다."
        
      case .unexceptedResponse(let status):
        return "응답 실패, 상태값 : \(status)"
        
      case .dataDecodingFailed:
        return "데이터 디코딩에 실패했습니다."
    }
  }
  
  var alertDescription: String {
    switch self {
      case .invalidURL:
        return "요청하신 주소를 찾을 수 없어요. 주소를 확인하고 다시 시도해주세요."
        
      case .requestFailed:
        return "요청에 실패했어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인하시고, 잠시 후 다시 시도해주세요."
        
      case .noData, .invalidResponse, .unexceptedResponse, .dataDecodingFailed:
        return "데이터 응답에 실패했어요. 잠시 후 다시 시도해주세요."
    }
  }
}

final class SessionAPIManager {
  
  // MARK: - Singleton
  static let shared = SessionAPIManager()
  private init() { }
  
  // MARK: - Method
  func callRequest<T: DTO>(
    responseType: T.Type,
    router: any Router,
    completion: @escaping ((T.ModelType)?, SessionError?) -> Void
  ) {
    
    guard let request = try? router.asURLRequest() else {
      completion(nil, .invalidURL)
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard error == nil else {
        completion(nil, .requestFailed)
        return
      }
      
      guard let data else {
        completion(nil, .noData)
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        completion(nil, .invalidResponse)
        return
      }
      
      guard 200...299 ~= response.statusCode else {
        completion(nil, .unexceptedResponse(status: response.statusCode))
        return
      }
      
      guard let result = try? JSONDecoder().decode(responseType.self, from: data) else {
        completion(nil, .dataDecodingFailed)
        return
      }
      
      let entity = result.asModel()
      
      GCD.main {
        completion(entity, nil)
      }
    }
    .resume()
  }
}
