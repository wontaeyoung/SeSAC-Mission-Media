//
//  PersonRouter.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/6/24.
//

import Alamofire
import Foundation

enum PersonRouter: Router {
  
  case personDetails(personID: Int)
  
  var method: HTTPMethod {
    switch self {
      case .personDetails:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.themoviedb.org/3/person"
  }
  
  var path: String {
    switch self {
      case .personDetails(let personID):
        return "/\(personID)"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    let parameters = Constant.Parameter.self
    
    switch self {
      case .personDetails:
        return [parameters.language(iso: .kor).key: parameters.language(iso: .kor).value]
    }
  }
}
