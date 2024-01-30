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
  
  var method: HTTPMethod {
    switch self {
      case .topRated:
        return .get
        
      case .popular:
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
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    let language: Constant.Parameter = .language(iso: .kor)
    
    return [language.key: language.value]
  }
}
