//
//  MovieRouter.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/7/24.
//

import Alamofire
import Foundation

enum MovieRouter: Router {
  
  case details(movieID: Int)
  case recommandation(movieID: Int)
  case credits(movieID: Int)
  case videos(movieID: Int)
  
  var method: HTTPMethod {
    switch self {
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
    return "https://api.themoviedb.org/3/movie"
  }
  
  var path: String {
    switch self {
      case .details(let movieID):
        return "/\(movieID)"
        
      case .recommandation(let movieID):
        return "/\(movieID)/recommendations"
        
      case .credits(let movieID):
        return "/\(movieID)/credits"
        
      case .videos(let movieID):
        return "/\(movieID)/videos"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    let parameters = Constant.Parameter.self
    
    switch self {
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
