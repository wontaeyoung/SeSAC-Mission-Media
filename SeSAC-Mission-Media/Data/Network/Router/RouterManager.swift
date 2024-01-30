//
//  RouterManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

final class RouterManager {
  
  static let shared = RouterManager()
  
  private init() { }
  
  func callRequest(
    collection: TVCollection,
    completion: @escaping ([Model]) -> Void
  ) {
    
    switch collection {
      case .trend:
        APIManager.shared.callRequest(
          responseType: TMDBTVResponseDTO.self,
          router: TrendRouter.trendTV(timeWindow: .week),
          completion: completion
        )
        
      case .topRated:
        APIManager.shared.callRequest(
          responseType: TMDBTVResponseDTO.self,
          router: TVRouter.topRated,
          completion: completion
        )
        
      case .popular:
        APIManager.shared.callRequest(
          responseType: TMDBTVResponseDTO.self,
          router: TVRouter.popular,
          completion: completion
        )
    }
  }
}
