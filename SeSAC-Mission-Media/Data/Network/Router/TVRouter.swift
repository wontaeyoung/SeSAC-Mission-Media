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
  case seriesDetails(seriesID: Int)
  case seriesRecommandation(seriesID: Int)
  case seriesAggregateCredits(seriesID: Int)
  
  var method: HTTPMethod {
    switch self {
      case .topRated:
        return .get
        
      case .popular:
        return .get
        
      case .seriesDetails:
        return .get
        
      case .seriesRecommandation:
        return .get
        
      case .seriesAggregateCredits:
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
        
      case .seriesDetails(let seriesID):
        return "/\(seriesID)"
        
      case .seriesRecommandation(let seriesID):
        return "/\(seriesID)/recommendations"
        
      case .seriesAggregateCredits(let seriesID):
        return "/\(seriesID)/aggregate_credits"
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
        
      case .seriesDetails:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .seriesRecommandation:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
        
      case .seriesAggregateCredits:
        return nil
    }
  }
}
