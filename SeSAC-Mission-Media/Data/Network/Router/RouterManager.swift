//
//  RouterManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

final class RouterManager {
  
  static let shared = RouterManager()
  
  private init() { }
  
  /// 제네릭으로 설정하고 간접적으로 TV 모델인걸 구현체에서 구체화 해야함
  func callRequest(
    collection: TVCollection,
    completion: @escaping ([TV]) -> Void
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
