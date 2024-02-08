//
//  TVRouter.swift
//  SeSAC-Mission-Movie
//
//  Created by 원태영 on 1/30/24.
//

import Alamofire
import Foundation

enum TVRouter: Router {
  
  case topRated
  case popular
  case details(seriesID: Int)
  case recommandation(seriesID: Int)
  case credits(seriesID: Int)
  case videos(seriesID: Int)
  
  var method: HTTPMethod {
    switch self {
      case .topRated:
        return .get
        
      case .popular:
        return .get
        
      case .details:
        return .get
        
      case .recommandation:
        return .get
        
      case .credits:
        return .get
        
      case .videos:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.themoviedb.org/3/tv"
  }
  
  var path: String {
    switch self {
      case .topRated:
        return "/top_rated"
        
      case .popular:
        return "/popular"
        
      case .details(let seriesID):
        return "/\(seriesID)"
        
      case .recommandation(let seriesID):
        return "/\(seriesID)/recommendations"
        
      case .credits(let seriesID):
        return "/\(seriesID)/aggregate_credits"
        
      case .videos(let seriesID):
        return "/\(seriesID)/videos"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    let parameters = Constant.Parameter.self
    
    switch self {
      case .topRated:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .popular:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .details:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .recommandation:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .credits:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .videos:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
    }
  }
}
