//
//  DisplayableCollection.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/4/24.
//

protocol DisplayableCollection: CaseIterable {
  var title: String { get }
  var tag: Int { get }
}

extension DisplayableCollection where Self: RawRepresentable, Self.RawValue == Int {
  var tag: Int {
    return self.rawValue
  }
}
