//
//  Constant.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

enum Constant {
  
  enum Parameter {
    enum ISO: String {
      case kor = "ko-KR"
      case eng = "en-US"
    }
    
    case language(iso: ISO)
    
    var key: String {
      switch self {
        case .language:
          return "language"
      }
    }
    
    var value: String {
      switch self {
        case .language(let iso):
          return iso.rawValue
      }
    }
  }
}
