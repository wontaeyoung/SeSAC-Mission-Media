//
//  Constant.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

enum Constant {
  
  enum AlternativeData {
    static let text = "-"
    static let date = "????-??-??"
    static let imagePath = ""
    static let id = 0
    static let minute = 0
  }
  
  enum Parameter {
    enum ISO: String {
      case kor = "ko-KR"
      case eng = "en-US"
    }
    
    case language(iso: ISO)
    case query
    
    var key: String {
      switch self {
        case .language:
          return "language"
          
        case .query:
          return "query"
      }
    }
    
    var value: String {
      switch self {
        case .language(let iso):
          return iso.rawValue
          
        case .query:
          return ""
      }
    }
  }
}
