//
//  Array+.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

extension Array {
  subscript(at index: Int) -> Element? {
    guard index < self.count else {
      return nil
    }
    
    return self[index]
  }
}
