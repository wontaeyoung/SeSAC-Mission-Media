//
//  ThreadManager.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 2/5/24.
//

import Foundation

final class GCD {
  static func main(work: @escaping () -> Void) {
    DispatchQueue.main.async {
      work()
    }
  }
  
  static func global(work: @escaping () -> Void) {
    DispatchQueue.global().async {
      work()
    }
  }
}
