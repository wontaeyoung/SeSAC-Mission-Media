//
//  Collection.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

enum Collection {
  
  enum Home: Int, DisplayableCollection {
    case trend
    case topRated
    case popular
    
    var title: String {
      switch self {
        case .trend:
          return "트렌디한 TV 프로그램"
          
        case .topRated:
          return "별점이 높은 TV 프로그램"
          
        case .popular:
          return "인기있는 TV 프로그램"
      }
    }
  }
  
  enum MediaDetail: Int, DisplayableCollection {
    case recommend
    case cast
    
    var title: String {
      switch self {
        case .recommend:
          return "비슷한 TV 프로그램"
          
        case .cast:
          return "출연진"
      }
    }
  }
  
  enum PersonDetail: Int, DisplayableCollection {
    case tvFilmography
    case movieFilmography
    
    var title: String {
      switch self {
        case .tvFilmography:
          return "출연작 - TV"
          
        case .movieFilmography:
          return "출연작 - 영화"
      }
    }
  }
}
