//
//  RouterManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

final class RouterManager {
  
  static let shared = RouterManager()
  
  private init() { }
  
  func callTVRequest(
    collection: HomeTVCollection,
    completion: @escaping ([TV]) -> Void
  ) {
    
    switch collection {
      case .trend:
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: TrendRouter.trendTV(timeWindow: .week),
          completion: completion
        )
        
      case .topRated:
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: TVRouter.topRated,
          completion: completion
        )
        
      case .popular:
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: TVRouter.popular,
          completion: completion
        )
    }
  }
  
  func callTVRequest(
    collection: SearchTVCollection,
    completion: @escaping ([TV]) -> Void
  ) {
    
    switch collection {
      case .search(let query):
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: SearchRouter.tv(query: query),
          completion: completion
        )
        
      default:
        print("")
    }
  }
}
