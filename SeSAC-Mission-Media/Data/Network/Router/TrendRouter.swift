//
//  TrendRouter.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Alamofire
import Foundation

enum TrendRouter: Router {
  
  case trendTV(timeWindow: TimeWindow)
  
  var method: HTTPMethod {
    switch self {
      case .trendTV:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.themoviedb.org/3/trending"
  }
  
  var path: String {
    switch self {
      case .trendTV(let timeWindow):
        return "/tv/\(timeWindow.rawValue)"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  var parameters: Parameters? {
    switch self {
      case .trendTV:
        return nil
    }
  }
}

extension TrendRouter {
  enum TimeWindow: String {
    case week
    case day
  }
}
