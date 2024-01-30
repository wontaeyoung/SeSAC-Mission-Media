//
//  Router.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Alamofire
import Foundation

protocol Router: URLRequestConvertible {
  
  var method: HTTPMethod { get }
  var baseURL: String { get }
  var path: String { get }
  var headers: HTTPHeaders { get }
  var parameters: Parameters? { get }
}

extension Router {
  
  func asURLRequest() throws -> URLRequest {
    let url: URL = try baseURL.asURL().appendingPathComponent(path)
    
    let request = URLRequest(url: url).configured {
      $0.httpMethod = method.rawValue
      $0.headers = headers
    }
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
