//
//  AFError+.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import Alamofire

extension AFError: AppError {
  var logDescription: String {
    return self.errorDescription ?? "정의되지 않은 에러"
  }
  
  var alertDescription: (title: String, message: String) {
    return (title: self.errorDescription ?? "알 수 없는 오류가 발생했습니다.", message: "")
  }
}
