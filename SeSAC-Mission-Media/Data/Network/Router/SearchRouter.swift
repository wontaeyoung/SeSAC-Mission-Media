//
//  SearchRouter.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import Alamofire
import Foundation

enum SearchRouter: Router {
  
  case tv(query: String)
  case person(query: String)
  
  var method: HTTPMethod {
    switch self {
      case .tv:
        return .get
        
      case .person:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.themoviedb.org/3/search"
  }
  
  var path: String {
    switch self {
      case .tv:
        return "tv"
        
      case .person:
        return "person"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    let parameters = Constant.Parameter.self
    
    switch self {
      case .tv(let query):
        return [
          parameters.language(iso: .kor).key: parameters.language(iso: .kor).value,
          parameters.query.key: query
        ]
        
      case .person(let query):
        return [
          parameters.language(iso: .kor).key: parameters.language(iso: .kor).value,
          parameters.query.key: query
        ]
    }
  }
}

