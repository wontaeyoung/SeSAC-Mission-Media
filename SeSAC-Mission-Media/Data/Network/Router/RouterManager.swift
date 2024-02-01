//
//  RouterManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

/*
 ViewController에서 직접 APIManager로 요청하는 것으로 수정
 - ViewController에서 프레젠터 단위의 열거형으로 요청 케이스를 관리했지만 Entity 타입의 불일치, 셀 재사용 불가 등의 이슈로 복잡한 구조가 형성되어서 다이렉트로 요청하는 것으로 변경
 
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
          router: TrendRouter.trendTV(timeWindow: .week)
        ) { response in
          completion(response.results)
        }
        
      case .topRated:
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: TVRouter.topRated
        ) { response in
          completion(response.results)
        }
        
      case .popular:
        APIManager.shared.callRequest(
          responseType: TVResponseDTO.self,
          router: TVRouter.popular
        ) { response in
          completion(response.results)
        }
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
          router: SearchRouter.tv(query: query)
        ) { response in
          completion(response.results)
        }
        
      default:
        print("")
    }
  }
  
  /*
   /// responsType에 명시한 DTO에 따라 completion에서 전달받은 모델의 타입이 구체화되기 때문에, 위의 메서드들처럼 직접 작성해야 함
  private func callRequest<D: DTO>(
    responseType: D.Type,
    router: Router,
    completion: @escaping ([TV]) -> Void
  ) {
    APIManager.shared.callRequest(responseType: responseType, router: router) { model in
      completion(model.results)
    }
  }
   */
}
*/
