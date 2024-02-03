//
//  String+.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/3/24.
//

extension String {
  var replacedEmptyToDash: String {
    return self.isEmpty ? "-" : self
  }
}
